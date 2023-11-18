//
//  EmptyParentViewModel.swift
//  
//
//  Created by Franklyn Weber on 24/02/2021.
//

import SwiftUI


public final class EmptyParentViewModel: SearchBarShowing {
    
    public typealias SearchListItemType = Text
    public typealias SearchListItemDetails = [String]
    
    public var searchResults: SearchResults<String> = SearchResults()
}
