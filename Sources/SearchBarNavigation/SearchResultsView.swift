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
    
    internal var otherResultsSectionTitle: String?
    internal var resultsSectionTitle: String?
    internal var resultsTextColor: Color?
    internal var resultsBackgroundColor: Color?
    internal var otherResultsTextColor: Color?
    internal var otherResultsBackgroundColor: Color?
    internal var maxOtherResults: Int = .max
    internal var maxResults: Int = .max
    internal var itemSelected: ((String) -> ())?
    
    internal var finished: (() -> ())?
    
    
    init(_ viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        ZStack {
            
            List {
                
                if viewModel.otherResults?.isEmpty == false {
                    Section(header: Text(otherResultsSectionTitle ?? NSLocalizedString("Recents", bundle: Bundle.module, comment: "Recents")).font(.caption)) {
                        recentItems()
                    }
                    .textCase(nil)
                }
                
                if viewModel.searchResults?.isEmpty == false {
                    Section(header: Text(resultsSectionTitle ?? NSLocalizedString("Results", bundle: Bundle.module, comment: "Results")).font(.caption)) {
                        resultsItems()
                    }
                    .textCase(nil)
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
            ForEach(otherResults.prefix(maxOtherResults), id: \.self) { item in
                T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: otherResultsTextColor, select: itemSelected)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        finish(item)
                    }
            }
            .listRowBackground(otherResultsBackgroundColor ?? Color(.systemBackground))
        }
    }
    
    @ViewBuilder
    private func resultsItems() -> some View {
        
        if let searchResults = viewModel.searchResults {
            ForEach(searchResults.prefix(maxResults), id: \.self) { item in
                T.SearchListItemType(parentViewModel: viewModel, content: item, textColor: resultsTextColor, select: itemSelected)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        finish(item)
                    }
            }
            .listRowBackground(resultsBackgroundColor ?? Color(.systemBackground))
        }
    }
    
    private func finish(_ item: T.SearchListItemType.Content) {

        UIApplication.shared.endEditing()
        
        viewModel.searchItemWasSelected(item)
        viewModel.searchTerm.wrappedValue = ""
        
        finished?()
    }
}
