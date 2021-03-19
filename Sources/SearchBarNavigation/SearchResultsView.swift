//
//  SearchResultsView.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


struct SearchResultsView<T: SearchBarShowing>: View, Identifiable {
    
    @StateObject private var viewModel: T
    @State private var isEditing = false
    @State private var opacity: Double = 0
    
    let id = "SearchResultsView"
    
    internal var searchViewBackgroundColor: Color?
    internal var otherResultsSectionTitle: String?
    internal var resultsSectionTitle: String?
    internal var otherResultsEmptyView: (() -> AnyView)?
    internal var resultsEmptyView: (() -> AnyView)?
    internal var searchResultsHeadersColor: Color?
    internal var searchResultsTextColor: Color?
    internal var maxOtherResults: Int = .max
    internal var maxResults: Int = .max
    internal var itemSelected: ((String) -> ())?
    
    internal var finished: (() -> ())?
    
    
    init(_ viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        ZStack {
            
            searchViewBackgroundColor
            
            List {
                
                if let searchResults = viewModel.searchResults {
                    
                    ForEach(searchResults) { section in
                        
                        if !(section.results.isEmpty && section.viewConfig?.resultsEmptyView?() == nil) {
                            Section(header: ListHeader(color: section.viewConfig?.headerColor ?? searchResultsHeadersColor, text: section.title)) {
                                items(for: section)
                            }
                            .textCase(nil)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                }
            }
            .opacity(opacity)
            .onAppear {
                withAnimation {
                    opacity = 1
                }
            }
            .onDisappear {
                withAnimation {
                    opacity = 0
                }
            }
            
            ProgressView()
                .opacity(viewModel.isSearching ? 1 : 0)
        }
    }
    
    @ViewBuilder
    private func items(for section: SearchResultsSection<T.SearchListItemType.Content>) -> some View {
        
        if section.results.isEmpty {
            section.viewConfig?.resultsEmptyView?()
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(Color(.clear))
        } else {
            ForEach(section.results.prefix(section.maxShown), id: \.self) { item in
                T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: section.viewConfig?.textColor ?? searchResultsTextColor ?? Color(.label), backgroundColor: section.viewConfig?.backgroundColor, select: itemSelected)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        finish(item)
                    }
            }
            .listRowBackground(Color(.clear))
        }
    }
    
    private func finish(_ item: T.SearchListItemType.Content) {

        UIApplication.shared.endEditing()
        
        viewModel.searchItemWasSelected(item)
        viewModel.searchTerm.wrappedValue = ""
        
        finished?()
    }
    
    struct ListHeader: View {
        
        var color: Color?
        var text: String
        
        var body: some View {
            
            ZStack {
                color
                
                HStack {
                    Text(text)
                        .font(.caption)
                        .padding(.leading, 16)
                    
                    Spacer()
                }
            }
        }
    }
}
