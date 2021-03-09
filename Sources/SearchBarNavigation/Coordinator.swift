//
//  Coordinator.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig
import FWMenu


public class Coordinator<T: SearchBarShowing & NavigationStyleProviding, Content: View>: NSObject, UISearchBarDelegate {
    
    let parent: SearchBarNavigation<T, Content>
    
    let rootViewController: UIHostingController<Content>
    let searchController: UISearchController
    
    
    init(_ parent: SearchBarNavigation<T, Content>) {
        
        self.parent = parent
        
        var searchController: UISearchController!
        var searchResultsController: UIHostingController<SearchResultsView<T>>?
        var searchResultsView = SearchResultsView(parent.viewModel)
        
        searchResultsView.searchViewBackgroundColor = parent.searchViewBackgroundColor
        searchResultsView.otherResultsSectionTitle = parent.otherResultsSectionTitle
        searchResultsView.resultsSectionTitle = parent.resultsSectionTitle
        searchResultsView.otherResultsEmptyView = parent.otherResultsEmptyView
        searchResultsView.resultsEmptyView = parent.resultsEmptyView
        searchResultsView.searchResultsTextColor = parent.searchResultsTextColor
        searchResultsView.searchResultsHeadersColor = parent.searchResultsHeadersColor
        searchResultsView.maxOtherResults = parent.maxOtherResults
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
        searchController.searchBar.scopeButtonTitles = parent.searchScopeTitles
        
        setupBarButtons()
        
        rootViewController.navigationItem.searchController = searchController
    }
    
    func update(content: Content) {
        setupBarButtons()
        rootViewController.rootView = content
        rootViewController.view.setNeedsDisplay()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        parent.viewModel.searchTerm.wrappedValue = searchText
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        parent.viewModel.searchScope = selectedScope
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
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let searchFieldButton = parent.searchFieldButton {
            
            let button = searchFieldButton.button
            button.tintColor = .gray
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            searchController.searchBar.searchTextField.leftView = button
        }
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let magnifyingGlass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlass.tintColor = .gray
        
        searchController.searchBar.searchTextField.leftView = magnifyingGlass
    }
    
    fileprivate func clearSearchBar() {
        searchController.searchBar.text = ""
    }
    
    private func setupBarButtons() {
        
        var leadingButtons = [UIBarButtonItem]()
        var trailingButtons = [UIBarButtonItem]()
        var buttonsColor: Color? = nil
        
        if let barButtons = parent.barButtons {
            leadingButtons += barButtons.leading.compactMap { $0.barButtonItem }
            trailingButtons += barButtons.trailing.compactMap { $0.barButtonItem }
            buttonsColor = barButtons.color
        }
        
        if let barMenuButtons = parent.barMenuButtons {
            
            leadingButtons += barMenuButtons.leading.enumerated().map { pair in
                let buttonConfig = pair.element
                let barButton: UIBarButtonItem
                if let imageSystemName = buttonConfig.imageSystemName {
                    barButton = UIBarButtonItem.button(with: imageSystemName) {
                        MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: CGFloat(pair.offset + 1) * 0.15)
                    }
                } else {
                    let imageName = buttonConfig.imageName!
                    let image = UIImage(named: imageName)!
                    barButton = UIBarButtonItem.button(with: image) {
                        MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: CGFloat(pair.offset + 1) * 0.15)
                    }
                }
                return barButton
            }
            trailingButtons += barMenuButtons.trailing.enumerated().map { pair in
                let buttonConfig = pair.element
                let barButton: UIBarButtonItem
                if let imageSystemName = buttonConfig.imageSystemName {
                    barButton = UIBarButtonItem.button(with: imageSystemName) {
                        MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: 1 - CGFloat(pair.offset + 1) * 0.15)
                    }
                } else {
                    let imageName = buttonConfig.imageName!
                    let image = UIImage(named: imageName)!
                    barButton = UIBarButtonItem.button(with: image) {
                        MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: 1 - CGFloat(pair.offset + 1) * 0.15)
                    }
                }
                return barButton
            }
            buttonsColor = barMenuButtons.color
        }
        
        let color: Color? = buttonsColor ?? {
            
            let parentStyle = parent.style
            let viewModelStyle = parent.viewModel.navigationBarStyle
            
            switch parentStyle ?? viewModelStyle {
            case .colored(let textColor, _), .withImage(let textColor, _), .withColorAndImage(let textColor, _, _):
                return textColor
            case .none:
                return nil
            }
        }()
        
        if let color = color {
            (leadingButtons + trailingButtons).forEach {
                $0.tintColor = color.uiColor
            }
        }
        
        rootViewController.navigationItem.leftBarButtonItems = leadingButtons
        rootViewController.navigationItem.rightBarButtonItems = trailingButtons
    }
}
