//
//  Protocols.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


public protocol SearchBarShowing: ObservableObject {
    
    /// The type of the items used to populate the search results list
    associatedtype SearchListItemType: SearchResultsListItem
    
    /// A bound String for the viewModel to use to search
    var searchTerm: Binding<String> { get }
    
    /// The results obtained by the viewModel
    var searchResults: [SearchListItemType.Content] { get }
    
    /// Recent results from the viewModel - optional
    var recentSearchSelections: [SearchListItemType.Content] { get }
    
    /// This will be set on the viewModel when the user either selects from the list or presses the Search button on the keyboard
    var selectedSearchTerm: String { get set }
}

public extension SearchBarShowing {
    
    var recentSearchSelections: [String] {
        return []
    }
}


/// To use custom items for populating the results list, they must conform to this protocol
public protocol SearchResultsListItem: View {
    
    /// Whatever content is used, is must implement SearchTermContaining
    associatedtype Content: SearchTermContaining
    
    /// Required initialiser for search result items
    /// - Parameters:
    ///   - content: the content of the item
    ///   - textColor: an optional Color for the item
    init(content: Content, textColor: Color?)
}


/// Protocol which must be implemented by the content of the search result items
public protocol SearchTermContaining: Hashable {
    
    /// The searchTerm text
    var searchTerm: String { get }
}
