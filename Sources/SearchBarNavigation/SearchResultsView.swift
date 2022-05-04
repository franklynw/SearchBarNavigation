//
//  SearchResultsView.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


public struct SearchResultsView<T: SearchBarShowing>: View, Identifiable {
    
    public enum Select {
        case dismissSearch(_ itemSelected: (T.SearchListItemType.Content) -> ())
        case selectOnly(_ itemSelected: (T.SearchListItemType.Content) -> ())
    }
    
    @StateObject private var viewModel: T
    @State private var isEditing = false
    @State private var opacity: Double = 0
    
    public let id = "SearchResultsView"
    
    internal var searchViewBackgroundColor: Color?
    internal var otherResultsSectionTitle: String?
    internal var resultsSectionTitle: String?
    internal var otherResultsEmptyView: (() -> AnyView)?
    internal var resultsEmptyView: (() -> AnyView)?
    internal var searchResultsHeadersColor: Color?
    internal var searchResultsTextColor: Color?
    internal var maxOtherResults: Int = .max
    internal var maxResults: Int = .max
    internal var itemSelected: Select?
    internal var disablesResultsChangedAnimations = false
    
    internal var finished: (() -> ())?
    
    private var edgeInset: CGFloat {
        if #available(iOS 15, *) {
            return -16
        } else {
            return 0
        }
    }
    
    
    init(_ viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    public var body: some View {
        
        ZStack {
            
            searchViewBackgroundColor
            
            List {
                
                if let searchResults = viewModel.searchResults {
                    
                    ForEach(searchResults.sections) { section in
                        // show header if - we got results or (there's a resultsEmptyView and the empty results have returned)
                        if !section.results.isEmpty || (section.viewConfig?.resultsEmptyView?() != nil && section.hasReceivedContent) {
                            Section(header: ListHeader(header: section.header.withFallbackColor(searchResultsHeadersColor))) {
                                items(for: section)
                            }
                            .textCase(nil)
                            .listRowInsets(EdgeInsets(top: 0, leading: edgeInset, bottom: 0, trailing: edgeInset))
                        }
                    }
                }
            }
            .padding(.bottom, 1) // weird iOS 15 bug where the results overlay the tab bar at the bottom on appearances after the initial one; this fixes it...
            .opacity(viewModel.isSearching ? 0 : 1)
            .animation(disablesResultsChangedAnimations ? nil : .easeInOut(duration: 0.2), value: viewModel.isSearching)
            
            ProgressView()
                .opacity(viewModel.isSearching ? 1 : 0)
        }
    }
    
    @ViewBuilder
    private func items(for section: SearchResultsSection<T.SearchListItemType.Content>) -> some View {
        
        if section.results.isEmpty {
            emptyResults(for: section)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(section.results.prefix(section.maxShown), id: \.self) { item in
                T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: section.viewConfig?.textColor ?? searchResultsTextColor ?? Color(.label), backgroundColor: section.viewConfig?.backgroundColor)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapped(item)
                    }
                    .animation(nil)
            }
            .listRowBackground(Color(.clear))
        }
    }
    
    @ViewBuilder
    private func emptyResults(for section: SearchResultsSection<T.SearchListItemType.Content>) -> some View {
        
        if section.hasReceivedContent {
            section.viewConfig?.resultsEmptyView?()
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(Color(.clear))
        }
    }
    
    private func tapped(_ item: T.SearchListItemType.Content) {
        
        switch itemSelected {
        case .selectOnly(let select):
            select(item)
        case .dismissSearch(let select):
            
            UIApplication.shared.endEditing()
            
            viewModel.searchTerm.wrappedValue = ""
            select(item)
            
            finished?()
            
        case .none:
            break
        }
    }
    
    struct ListHeader: View {
        
        let header: SearchResultsSection<T.SearchListItemType.Content>.Header
        
        var body: some View {
            
            ZStack {
                
                header.color
                
                HStack {
                    Text(header.title)
                        .font(.caption)
                        .foregroundColor(header.textColor)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    if let button = header.button {
                        Button(action: button.action) {
                            Text(button.title)
                                .font(Font.caption.weight(.semibold))
                                .foregroundColor(header.textColor)
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
        }
    }
}
