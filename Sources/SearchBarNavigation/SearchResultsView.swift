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
//    internal var pullToRefresh: ((@escaping () -> ()) -> ())?
    
    internal var finished: (() -> ())?
    
    
    init(_ viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        ZStack {
            
            searchViewBackgroundColor
            
//            if let pullToRefresh = pullToRefresh {
//                // A very hacky & not great implementation of pull-to-refresh, but until Apple give us a proper version...
//                VStack {
//                    PullToRefreshView(pullToRefreshOffset: $viewModel.pullToRefreshOffset, action: pullToRefresh)
//                    Spacer()
//                }
//            }
            
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


public struct PullToRefreshPreferenceKey: PreferenceKey {
    
    public static var defaultValue: [CGFloat] = [0]
    
    public static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}


struct PullToRefreshView: View {
    
    @Binding var pullToRefreshOffset: CGFloat
    @State var isRefreshing = false
    let action: (@escaping () -> ()) -> ()
    
    var body: some View {
        
        ZStack {
            Color.clear
            
            if pullToRefreshOffset < 40 {
                Spinner(percentage: pullToRefreshOffset / 40)
            } else {
                ProgressView()
                performAction()
            }
        }
        .frame(height: 40)
        .opacity(Double(max(min(pullToRefreshOffset / 40, 1), 0)))
    }
    
    func performAction() -> EmptyView {
        
        guard !isRefreshing else {
            return EmptyView()
        }
        
        action {
            DispatchQueue.main.async {
                isRefreshing = false
            }
        }
        return EmptyView()
    }
    
    struct Spinner: View {
        
        var percentage: CGFloat
        
        var body: some View {
            
            ForEach(1...8, id: \.self) {
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(1)
                    .frame(width: 2.5, height: 6.5)
                    .opacity(percentage * 8 >= CGFloat($0) ? Double($0) / 8 : 0)
                    .offset(x: 0, y: -3.5)
                    .rotationEffect(.degrees(Double(45 * $0)), anchor: .bottom)
            }
            .offset(y: -3.5)
            .frame(width: 40, height: 40)
        }
    }
}
