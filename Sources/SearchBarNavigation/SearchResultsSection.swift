//
//  SearchResultsSection.swift
//  
//
//  Created by Franklyn Weber on 19/03/2021.
//

import SwiftUI


public struct SearchResultsSection<Content: Hashable>: Identifiable {
    
    public let id = UUID()
    
    let title: String
    let results: [Content]
    let maxShown: Int
    let viewConfig: ViewConfig?
    
    public struct ViewConfig {
        let headerColor: Color?
        let textColor: Color?
        let backgroundColor: Color?
        let resultsEmptyView: (() -> AnyView)?
        
        public init(headerColor: Color? = nil, textColor: Color? = nil, backgroundColor: Color? = nil, resultsEmptyView: (() -> AnyView)? = nil) {
            self.headerColor = headerColor
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.resultsEmptyView = resultsEmptyView
        }
    }
    
    public init(title: String, results: [Content], maxShown: Int = .max, viewConfig: ViewConfig? = nil) {
        self.title = title
        self.results = results
        self.maxShown = maxShown
        self.viewConfig = viewConfig
    }
}
