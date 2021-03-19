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
    
    /// A bound String for the viewModel to use to search - optional - if set, the viewModel will receive every every keystroke
    var searchTerm: Binding<String> { get }
    
    /// The search scope selected by the user
    var searchScope: Int { get set }
    
    /// Should be set to true when the search is being carried out
    var isSearching: Bool { get }
    
    /// The results obtained by the viewModel - should be @Published
    var searchResults: [SearchResultsSection<SearchListItemType.Content>]? { get }
    
    /// Called when the user selects from the list of results - optional
    func searchItemWasSelected(_ item: SearchListItemType.Content)
    
    /// Called when the user presses the Search button on the keyboard - optional
    func search(using searchTerm: String)
    
    /// Called when the cancel button is pressed - optional
    func searchCancelled()
}

public extension SearchBarShowing {
    
    var searchTerm: Binding<String> {
        Binding<String>(get: { "" }, set: { _ in })
    }
    
    var searchScope: Int {
        set {}
        get { 0 }
    }
    
    var isSearching: Bool {
        return false
    }
    
    func searchItemWasSelected(_ item: SearchListItemType.Content) {
        // nothing
    }
    
    func search(using searchTerm: String) {
        // nothing
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
    ///   - select: an optional closure which the item can invoke if necessary
    init(parentViewModel: Parent, content: Content, textColor: Color?, backgroundColor: Color?, select: ((String) -> ())?)
}


extension Text: SearchResultsListItem {
    
    public typealias Parent = EmptyParentViewModel
    public typealias Content = String
    
    public init(parentViewModel: Parent, content: Content, textColor: Color?, backgroundColor: Color?, select: ((String) -> ())?) {
        self = Text(content)
    }
}


