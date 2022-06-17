//
//  File.swift
//  
//
//  Created by Franklyn on 17/06/2022.
//

import SwiftUI
import Combine

/*
public class SplitViewCoordinator<T: SearchBarShowing & NavigationStyleProviding, MasterContent: View, DetailContent: View>: NSObject {
    
    let parent: SplitViewNavigation<T, MasterContent, DetailContent>
    
//    let rootViewController: UIHostingController<Content>
    let searchController: UISearchController
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    init(_ parent: SplitViewNavigation<T, MasterContent, DetailContent>) {
        
//        if let cancelButtonTitle = parent.cancelButtonTitle {
//            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = cancelButtonTitle
//        }
        
        self.parent = parent
        
        var searchController: UISearchController!
        var searchResultsController: UIHostingController<SearchResultsView<T>>?
        var searchResultsView = SearchResultsView(parent.viewModel)
        
        searchResultsView.searchViewBackgroundColor = parent.searchViewBackgroundColor
        searchResultsView.searchResultsTextColor = parent.searchResultsTextColor
        searchResultsView.searchResultsHeadersColor = parent.searchResultsHeadersColor
        searchResultsView.disablesResultsChangedAnimations = parent.disablesResultsChangedAnimations
        searchResultsView.itemSelected = parent.itemSelected
        
        searchResultsView.finished = {
            searchResultsController?.dismiss(animated: true, completion: nil)
            searchController.searchBar.text = ""
        }
        
        searchResultsController = SearchHostingController(rootView: searchResultsView, showPreviousResults: parent.showsLastResultsOnActivate)
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        if let cancelButtonColor = parent.cancelButtonColor {
            searchController.searchBar.tintColor = UIColor(cancelButtonColor)
        }
        
        self.searchController = searchController
        
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.viewControllers.append(searchController)
        
//        rootViewController = UIHostingController(rootView: parent.content())
        
        super.init()
        
        parent.pushController.pushedViewControllerPublisher
            .sink { [weak self] viewController in
                guard let self = self, let viewController = viewController else {
                    self?.rootViewController.navigationController?.popViewController(animated: true)
                    return
                }
                self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &subscriptions)
        
        parent.becomeFirstResponder?
            .sink {
                if $0 {
                    searchController.searchBar.searchTextField.becomeFirstResponder()
                }
            }
            .store(in: &subscriptions)
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.enablesReturnKeyAutomatically = parent.enableReturnKeyAutomatically
        
        searchController.searchBar.placeholder = parent.placeholder
        searchController.searchBar.scopeButtonTitles = parent.searchScopeTitles
        
        if parent.viewModel.search == nil {
            searchController.searchBar.returnKeyType = .done
        }
        
        setupInputAccessoryView()
        setupBarButtons()
        
        rootViewController.navigationItem.searchController = searchController
    }
}
*/
