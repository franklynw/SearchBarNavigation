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
                
                if viewModel.otherResults?.isEmpty == false || otherResultsEmptyView != nil {
                    Section(header: ListHeader(color: searchResultsHeadersColor, text: otherResultsSectionTitle ?? NSLocalizedString("Recents", bundle: Bundle.module, comment: "Recents"))) {
                        recentItems()
                    }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
                if viewModel.searchResults?.isEmpty == false || resultsEmptyView != nil {
                    Section(header: ListHeader(color: searchResultsHeadersColor, text: resultsSectionTitle ?? NSLocalizedString("Results", bundle: Bundle.module, comment: "Results"))) {
                        resultsItems()
                    }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
    private func recentItems() -> some View {
        
        if let otherResults = viewModel.otherResults {
            if otherResults.isEmpty {
                otherResultsEmptyView?()
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color(.clear))
            } else {
                ForEach(otherResults.prefix(maxOtherResults), id: \.self) { item in
                    T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: searchResultsTextColor ?? Color(.label), select: itemSelected)
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            finish(item)
                        }
                }
                .listRowBackground(Color(.clear))
            }
        }
    }
    
    @ViewBuilder
    private func resultsItems() -> some View {
        
        if let searchResults = viewModel.searchResults {
            if searchResults.isEmpty {
                resultsEmptyView?()
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color(.clear))
            } else {
                ForEach(searchResults.prefix(maxResults), id: \.self) { item in
                    T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: searchResultsTextColor ?? Color(.label), select: itemSelected)
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            finish(item)
                        }
                }
                .listRowBackground(Color(.clear))
            }
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
