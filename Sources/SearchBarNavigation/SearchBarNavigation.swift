//
//  SearchBarNavigation.swift
//
//  Created by Franklyn Weber on 15/01/2021.
//  With guidance from Yugantar Jain - https://stackoverflow.com/a/63298758/331854
//

import SwiftUI
import Combine
import FWCommonProtocols
import ButtonConfig
import FWMenu


public struct SearchBarNavigation<T: SearchBarShowing & NavigationStyleProviding, Content: View>: UIViewControllerRepresentable, NavigationConfiguring {
    
    @ObservedObject internal var viewModel: T
    internal let content: () -> Content
    
    internal var style: NavigationBarStyle?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var placeholder: String?
    internal var searchScopeTitles: [String] = []
    internal var barButtons: BarButtons?
    internal var searchFieldButton: BarButton?
    internal var searchInputAccessory: SearchInputAccessory?
    internal var searchResultsHeadersColor: Color?
    internal var searchResultsTextColor: Color?
    internal var searchViewBackgroundColor: Color?
    internal var cancelButtonTitle: String?
    internal var cancelButtonColor: Color?
    internal var itemSelected: SearchResultsView<T>.Select?
    internal var showsLastResultsOnActivate = false
    internal var cancelsSearchOnKeyboardDismiss = false
    internal var disablesResultsChangedAnimations = false
    internal var enableReturnKeyAutomatically = true
    internal var becomeFirstResponder: Published<Bool>.Publisher?
    internal var shouldPop: ((@escaping (Bool) -> ()) -> ())?
    
    @State internal var pushController = PushController<Content>()
    
    
    public init(_ viewModel: T, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
        pushController.parent = self
    }

    public func makeUIViewController(context: Context) -> ControlledPopNavigationController {
        
        let navigationController = ControlledPopNavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        setupStyle(for: navigationController, viewModel: viewModel)
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        navigationController.popDelegate = context.coordinator
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: ControlledPopNavigationController, context: Context) {
        setupStyle(for: uiViewController, viewModel: viewModel)
        context.coordinator.update(content: content())
    }
    
    public func makeCoordinator() -> SearchCoordinator<T, Content> {
        SearchCoordinator(self)
    }
}
