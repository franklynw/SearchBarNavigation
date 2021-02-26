//
//  Coordinator.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


public class Coordinator<T: SearchBarShowing, Content: View>: NSObject, UISearchBarDelegate {
    
    let parent: SearchBarNavigation<T, Content>
    
    let rootViewController: UIHostingController<Content>
    let searchController: UISearchController
    
    
    init(_ parent: SearchBarNavigation<T, Content>) {
        
        self.parent = parent
        
        var searchController: UISearchController!
        var searchResultsController: UIHostingController<SearchResultsView<T>>?
        var searchResultsView = SearchResultsView(parent.viewModel)
        
        searchResultsView.recentsSectionTitle = parent.recentsSectionTitle
        searchResultsView.resultsSectionTitle = parent.resultsSectionTitle
        searchResultsView.recentsTextColor = parent.recentsTextColor
        searchResultsView.resultsTextColor = parent.resultsTextColor
        searchResultsView.recentsBackgroundColor = parent.recentsBackgroundColor
        searchResultsView.resultsBackgroundColor = parent.resultsBackgroundColor
        searchResultsView.maxRecents = parent.maxRecents
        searchResultsView.maxResults = parent.maxResults
        searchResultsView.itemSelected = parent.itemSelected
        
        searchResultsView.finished = {
            searchResultsController?.dismiss(animated: true, completion: nil)
            searchController.searchBar.text = ""
        }
        
        searchResultsController = UIHostingController(rootView: searchResultsView)
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        if let cancelButtonColor = parent.cancelButtonColor {
            searchController.searchBar.tintColor = UIColor(cancelButtonColor)
        }
        
        self.searchController = searchController
        
        rootViewController = UIHostingController(rootView: parent.content())
        
        super.init()
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchBar.placeholder = parent.placeholder
        
        if let barButtons = parent.barButtons {
            
            let leadingButtons = barButtons.leading.compactMap { $0.barButtonItem }
            let trailingButtons = barButtons.trailing.compactMap { $0.barButtonItem }
            
            if let color = barButtons.color {
                (leadingButtons + trailingButtons).forEach {
                    $0.tintColor = color.uiColor
                }
            }
            
            rootViewController.navigationItem.leftBarButtonItems = leadingButtons
            rootViewController.navigationItem.rightBarButtonItems = trailingButtons
        }
        
        rootViewController.navigationItem.searchController = searchController
    }
    
    func update(content: Content) {
        rootViewController.rootView = content
        rootViewController.view.setNeedsDisplay()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        parent.viewModel.searchTerm.wrappedValue = searchText
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        parent.viewModel.search(using: text)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        parent.viewModel.searchTerm.wrappedValue = ""
        parent.viewModel.searchCancelled()
    }
    
    fileprivate func clearSearchBar() {
        searchController.searchBar.text = ""
    }
}
