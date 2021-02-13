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
    
    internal var recentsSectionTitle: String?
    internal var resultsSectionTitle: String?
    internal var recentsTextColor: Color?
    internal var recentsBackgroundColor: Color?
    internal var resultsTextColor: Color?
    internal var resultsBackgroundColor: Color?
    internal var maxRecents: Int = 3
    internal var maxResults: Int = .max
    
    internal var finished: (() -> ())?
    
    
    init(_ viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        if !viewModel.recentSearchSelections.isEmpty || !viewModel.searchResults.isEmpty {
            
            List {
                
                Section(header: Text(recentsSectionTitle ?? NSLocalizedString("Recents", bundle: Bundle.module, comment: "Recents")).font(.caption)) {
                    recentItems()
                }
                
                Section(header: Text(resultsSectionTitle ?? NSLocalizedString("Results", bundle: Bundle.module, comment: "Results")).font(.caption)) {
                    resultsItems()
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
        }
    }
    
    private func recentItems() -> some View {
        
        ForEach(viewModel.recentSearchSelections.prefix(maxRecents), id: \.self) { item in
            T.SearchListItemType(content: item, textColor: recentsTextColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    finish(item)
                }
        }
        .listRowBackground(recentsBackgroundColor ?? Color(.systemBackground))
    }
    
    private func resultsItems() -> some View {
        
        ForEach(viewModel.searchResults.prefix(maxResults), id: \.self) { item in
            T.SearchListItemType(content: item, textColor: resultsTextColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    finish(item)
                }
        }
        .listRowBackground(resultsBackgroundColor ?? Color(.systemBackground))
    }
    
    private func finish(_ item: T.SearchListItemType.Content) {

        UIApplication.shared.endEditing()
        viewModel.selectedSearchTerm = item.searchTerm
        viewModel.searchTerm.wrappedValue = ""
        
        finished?()
    }
}
