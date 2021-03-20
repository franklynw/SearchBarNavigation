//
//  SearchResultsSection.swift
//  
//
//  Created by Franklyn Weber on 19/03/2021.
//

import SwiftUI


public struct SearchResults<Content: Hashable>: Collection {
    
    public typealias Index = Int
    public typealias Element = SearchResultsSection<Content>
    
    var sections: [SearchResultsSection<Content>]
    
    public var startIndex: Int {
        sections.startIndex
    }
    public var endIndex: Int {
        sections.endIndex
    }
    
    public func index(after i: Int) -> Int {
        sections.index(after: i)
    }
    
    public subscript(position: Int) -> SearchResultsSection<Content> {
        get {
            sections[position]
        }
        set {
            sections[position] = newValue
        }
    }
    
    public subscript(identifier: String) -> SearchResultsSection<Content>? {
        get {
            section(forIdentifier: identifier)
        }
        set {
            guard let newValue = newValue, let position = sections.firstIndex(where: { $0.id == identifier }) else {
                return
            }
            sections[position] = newValue
        }
    }
    
    
    public init() {
        sections = []
    }
    
    public init(_ sections: [SearchResultsSection<Content>]) {
        self.sections = sections
    }
    
    public func section(forIdentifier identifier: String) -> SearchResultsSection<Content>? {
        sections.first { $0.id == identifier }
    }
    
    public mutating func updateSection(withIdentifier identifier: String, withNewContent content: [Content]) {
        guard var section = section(forIdentifier: identifier), let sectionIndex = index(ofSection: section) else {
            return
        }
        section.updateResults(content)
        sections[sectionIndex] = section
    }
    
    public mutating func appendSection(withIdentifier identifier: String, withAdditionContent content: [Content]) {
        guard var section = section(forIdentifier: identifier), let sectionIndex = index(ofSection: section) else {
            return
        }
        section.appendResults(with: content)
        sections[sectionIndex] = section
    }
    
    public mutating func clearSections(withIdentifiers identifiers: [String]? = nil) {
        
        sections = sections.map {
            
            var section = $0
            
            if identifiers == nil || identifiers!.contains(section.id) {
                section.clear()
            }
            
            return section
        }
    }
    
    private func index(ofSection section: SearchResultsSection<Content>) -> Int? {
        sections.firstIndex(where: { $0.id == section.id })
    }
}


public struct SearchResultsSection<Content: Hashable>: Collection, Identifiable {
    
    public typealias Index = Int
    public typealias Element = Content
    
    public var startIndex: Int {
        results.startIndex
    }
    public var endIndex: Int {
        results.endIndex
    }
    
    public func index(after i: Int) -> Int {
        results.index(after: i)
    }
    
    public subscript(position: Int) -> Content {
        get {
            results[position]
        }
        set {
            results[position] = newValue
            hasReceivedContent = true
        }
    }
    
    public var last: Content? {
        results.last
    }
    
    public let id: String
    
    var results: [Content]
    var hasReceivedContent = false // not the same as empty content
    
    let header: Header
    let maxShown: Int
    let viewConfig: ViewConfig?
    
    public struct Header {
        let title: String
        let color: Color?
        let textColor: Color?
        let button: Button?
        
        public struct Button {
            let title: String
            let action: () -> ()
            
            public init(title: String, action: @escaping () -> ()) {
                self.title = title
                self.action = action
            }
        }
        
        public init(title: String, color: Color? = nil, textColor: Color? = nil, button: Button? = nil) {
            self.title = title
            self.color = color
            self.textColor = textColor
            self.button = button
        }
        
        func withFallbackColor(_ fallbackColor: Color?) -> Header {
            let header = Header(title: title, color: color ?? fallbackColor, textColor: textColor, button: button)
            return header
        }
    }
    
    public struct ViewConfig {
        let textColor: Color?
        let backgroundColor: Color?
        let resultsEmptyView: (() -> AnyView)?
        
        public init(textColor: Color? = nil, backgroundColor: Color? = nil, resultsEmptyView: (() -> AnyView)? = nil) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.resultsEmptyView = resultsEmptyView
        }
    }
    
    public init(id: String = UUID().uuidString, title: String, results: [Content], maxShown: Int = .max, viewConfig: ViewConfig? = nil) {
        self.id = id
        header = Header(title: title, color: nil, textColor: nil)
        self.results = results
        self.maxShown = maxShown
        self.viewConfig = viewConfig
    }
    
    public init(id: String = UUID().uuidString, header: Header, results: [Content], maxShown: Int = .max, viewConfig: ViewConfig? = nil) {
        self.id = id
        self.header = header
        self.results = results
        self.maxShown = maxShown
        self.viewConfig = viewConfig
    }
    
    mutating func appendResults(with additionalItems: [Content]) {
        results.append(contentsOf: additionalItems)
        hasReceivedContent = true
    }
    
    mutating func updateResults(_ results: [Content]) {
        self.results = results
        hasReceivedContent = true
    }
    
    mutating func clear() {
        results.removeAll()
        hasReceivedContent = false
    }
}
