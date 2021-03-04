# SearchBarNavigation

A SwiftUI implementation of a UINavigationController with a search bar & search controller.
Currently only tried out on iOS, requires iOS 14 upwards

Ignore the odd content of the example images, they're just to show how it works

<img src="Sources/SearchBarNavigation/Resources//Example1.png" alt="Example 1"/> <img src="Sources/SearchBarNavigation/Resources//Example2.png" alt="Example 2"/> <img src="Sources/SearchBarNavigation/Resources//Example3.png" alt="Example 3"/>

## Installation

### Swift Package Manager

In Xcode:
* File ⭢ Swift Packages ⭢ Add Package Dependency...
* Use the URL https://github.com/franklynw/SearchBarNavigation


## Example

> **NB:** All examples require `import SearchBarNavigation` at the top of the source file

This example is using a custom content type, so it can display icons as well as the search text (requires Combine as well) -

```swift
class MainViewModel: SearchBarShowing {
    
    typealias SearchListItemType = SearchItem
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var searchResults: [SearchItemInfo] = []
    @Published var otherResults: [SearchItemInfo] = []
    @Published var selectedSearchTerm = ""
    
    private var _searchTerm: String = ""
    var searchTerm: Binding<String> {
        Binding<String>(
            get: { self._searchTerm },
            set: {
                
                self._searchTerm = $0
                
                if self._searchTerm.isEmpty {
                    self.searchResults = []
                    self.otherResults = []
                } else {
                    self.fetchSearchResults(using: self._searchTerm) {
                        self.searchResults = $0
                    }
                }
            }
        )
    }
    
    init() {
        
        $selectedSearchTerm
            .sink {
                print("Selected: ", $0)
            }
            .store(in: &subscriptions)
            
            otherResults = ...
    }
}


struct MainView: View {
    
    @ObservedObject private var viewModel: MainViewModel
    
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        SearchBarNavigation(viewModel) {
            // page content here
        }
        .navigationBarTitle(.withImage(text: "Places to go", textColor: Color(.myCoolDarkBlue), image: UIImage(named: "Map")!))
        .placeHolder("Search for somewhere")
    }
}

struct SearchItem: View, SearchBarListItem {
    
    private let content: SearchItemInfo
    private let textColor: Color
    
    init(content: SearchItemInfo, textColor: Color?) {
        self.content = content
        self.textColor = textColor ?? Color(.label)
    }
    
    var body: some View {
        HStack {
            Text(content.name)
                .foregroundColor(textColor)
            Spacer()
            Image(systemName: content.systemImageName)
        }
    }
}

struct SearchItemInfo: SearchBarTermContaining {
    let name: String
    let systemImageName: String
    
    init(_ name: String, _ systemImageName: String) {
        self.name = name
        self.systemImageName = systemImageName
    }
    
    var searchTerm: String {
        return name
    }
}
```


Available modifiers -

### NavigationBar title

You can set the title attributes, either just providing a String, or using the Title enum which gives more customisation options such as title colour & background colour or image

```swift
SearchBarNavigation(viewModel)
    .navigationBarTitle("Places to go")
```

or 

```swift
SearchBarNavigation(viewModel)
    .navigationBarTitle(.colored(text: "Places to go", textColor: .purple, backgroundColor: Color(.lightGray)))
```

### Disable large titles

It defaults to using large titles, but you can disable that

```swift
SearchBarNavigation(viewModel)
    .disableLargeTitles
```

### Translucent background

Set this so you can see the content below the navigation bar. Note that if you set a background colour for the title, unless that colour has an alpha component of less than 1, the bar will appear opaque

```swift
SearchBarNavigation(viewModel)
    .translucentBackground
```

### Placeholder

You can set the search field's placeholder text

```swift
SearchBarNavigation(viewModel)
    .placeHolder("Search for something")
```

### Bar buttons

You can set the bar buttons, either with normal buttons or with menu buttons (they show a menu when you tap them). This is controlled by the type of ButtonConfig you provide

```swift
SearchBarNavigation(viewModel)
    .barButtons(viewModel.barButtons())
```

### Other Results section title

Sets the title of the other section of the results - if not used, will default to "Recents"

```swift
SearchBarNavigation(viewModel)
    .otherResultsSectionTitle("Recently viewed items -")
```

### Results section title

Sets the title of the "Results" section of the results - if not used, will default to "Results"

```swift
SearchBarNavigation(viewModel)
    .resultsSectionTitle("Search results -")
```

### Other Results items text colour

The colour to use for the text of the other results items - defaults to Color(.label) if unused

```swift
SearchBarNavigation(viewModel)
    .otherResultsTextColor(.black)
```

### Other Results items background colour

The colour to use for the background of the other area of the results list - defaults to Color(.systemBackground) if unused

```swift
SearchBarNavigation(viewModel)
    .otherResultsBackgroundColor(.orange)
```

### Results items text colour

The colour to use for the text of the result items - defaults to Color(.label) if unused

```swift
SearchBarNavigation(viewModel)
    .resultsTextColor(.red)
```

### Results items background colour

The colour to use for the background of the results area of the results list - defaults to Color(.systemBackground) if unused

```swift
SearchBarNavigation(viewModel)
    .resultsBackgroundColor(.yellow)
```

### Cancel button colour

The colour to use for the Cancel button - defaults to Color(.link) if unused

```swift
SearchBarNavigation(viewModel)
    .cancelButtonColor(.red)
```

### Maximum number of other results

The maximum number of rows to show in the recents section - defaults to 3 if unused

```swift
SearchBarNavigation(viewModel)
    .maxOtherResults(5)
```

### Maximum number of search results

The maximum number of rows to show in the results section - defaults to unlimited if unused

```swift
SearchBarNavigation(viewModel)
    .maxResults(5)
```


## Dependencies

Requires ButtonConfig, which is linked. GitHub page is [here](https://github.com/franklynw/ButtonConfig)
Requires FWCommonProtocols, which is linked. GitHub page is [here](https://github.com/franklynw/FWCommonProtocols)


## Issues

It all seems to work well, but there are probably still bugs... If anyone can suggest a better way of doing what I've done for the navBar background image (in SearchBarNavigation - setBackgroundImage) I'd really like to hear!


## License  

`SearchBarNavigation` is available under the MIT license
