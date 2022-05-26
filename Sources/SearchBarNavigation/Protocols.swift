//
//  Protocols.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


public protocol NavigationStyleProviding: ObservableObject {
    /// Sets the navigation bar style
    var navigationBarStyle: NavigationBarStyle? { get }
}

public protocol SearchBarShowing: NavigationStyleProviding {
    
    /// The type of the items used to populate the search results list
    associatedtype SearchListItemType: SearchResultsListItem where SearchListItemType.Parent == Self
    
    /// Called when the user presses the Search button on the keyboard - optional
    var search: ((String) -> ())? { get }
    
    /// The searchTerm as it appears in the searchBar textField
    var searchTerm: String { get set }
    
    /// The search scope selected by the user
    var searchScope: Int { get set }
    
    /// When the user has tapped in the search field
    var isSearchActive: Bool { get set }
    
    /// Should be set to true when the search is being carried out - causes the activity spinner to appear
    var isSearching: Bool { get }
    
    /// The results obtained by the viewModel - should be @Published
    var searchResults: SearchResults<SearchListItemType.Content> { get set }
    
    /// Called when the cancel button is pressed - optional
    func searchCancelled()
}

public extension SearchBarShowing {
    
    var search: ((String) -> ())? {
        get { nil }
    }
    
    var searchTerm: String {
        get { "" }
        set {}
    }
    
    var searchScope: Int {
        set {}
        get { 0 }
    }
    
    var isSearchActive: Bool {
        set {}
        get { false }
    }
    
    var isSearching: Bool {
        return false
    }
    
    func searchCancelled() {
        // nothing
    }
}


/// To use custom items for populating the results list, they must conform to this protocol
public protocol SearchResultsListItem: View {
    
    associatedtype Parent: SearchBarShowing where Parent.SearchListItemType == Self
    associatedtype Content: Hashable
    
    /// Required initialiser for search result items
    /// - Parameters:
    ///   - parentViewModel: the viewModel for the parent view
    ///   - content: the content of the item
    ///   - textColor: an optional Color for the item
    ///   - backgroundColor: an optional background Color for the item
    init(parentViewModel: Parent, content: Content, textColor: Color?, backgroundColor: Color?)
}


extension Text: SearchResultsListItem {
    
    public typealias Parent = EmptyParentViewModel
    public typealias Content = String
    
    public init(parentViewModel: Parent, content: Content, textColor: Color?, backgroundColor: Color?) {
        self = Text(content)
    }
}
