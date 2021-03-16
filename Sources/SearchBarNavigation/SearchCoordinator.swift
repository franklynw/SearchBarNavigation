//
//  SearchCoordinator.swift
//
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig
import FWMenu


public class SearchCoordinator<T: SearchBarShowing & NavigationStyleProviding, Content: View>: NSObject, UISearchBarDelegate {
    
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
        
        searchResultsController = SearchHostingController(rootView: searchResultsView, showPreviousResults: parent.showsLastResultsOnActivate)
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
        
        setupInputAccessoryView()
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
        searchWasCancelled()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        var button : UIButton?
        
        switch parent.searchFieldButton {
        case .button(let buttonConfig):
            
            button = buttonConfig.button
            
        case .menu(let barMenuButton):
            
            let buttonAction = UIAction { _ in
                
                guard let button = button else {
                    return
                }
                let buttonRect = button.convert(button.bounds, to: self.rootViewController.view)
                
                MenuPresenter.present(parent: barMenuButton, with: buttonRect)
            }
            button = UIButton(type: .system, primaryAction: buttonAction)
            
            let image: UIImage?
            if let imageName = barMenuButton.imageName {
                image = UIImage(named: imageName)
            } else if let imageSystemName = barMenuButton.imageSystemName {
                image = UIImage(systemName: imageSystemName)
            } else {
                image = nil
            }
            
            button?.setImage(image, for: UIControl.State())
            
        case .none:
            break
        }
        
        guard let searchButton = button else {
            return
        }
        
        searchButton.tintColor = .gray
        searchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        searchController.searchBar.searchTextField.leftView = searchButton
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
        
        guard let barButtons = parent.barButtons else {
            return
        }
        
        let style = parent.style ?? parent.viewModel.navigationBarStyle
        parent.setupBarButtons(barButtons, style: style, for: rootViewController)
    }
    
    private func setupInputAccessoryView() {
                
        guard let searchInputAccessory = parent.searchInputAccessory else {
            return
        }
        
        let buttonColor: UIColor = parent.cancelButtonColor != nil ? UIColor(parent.cancelButtonColor!) : .label
        let accessoryView = searchInputAccessory.view(buttonColor: buttonColor, dismissKeyboard: { [weak self] in
            if self?.parent.cancelsSearchOnKeyboardDismiss == true {
                self?.cancelSearch()
            }
            UIApplication.shared.endEditing()
        })
        
        searchController.searchBar.inputAccessoryView = accessoryView
    }
    
    private func cancelSearch() {
        searchController.isActive = false
        searchWasCancelled()
    }
    
    private func searchWasCancelled() {
        parent.viewModel.searchTerm.wrappedValue = ""
        parent.viewModel.searchCancelled()
    }
}


private var hiddenKey: UInt8 = 0

class SearchHostingController<Content: View>: UIHostingController<Content> {
    
    private let showPreviousResults: Bool
    
    init(rootView: Content, showPreviousResults: Bool) {
        
        self.showPreviousResults = showPreviousResults
        
        super.init(rootView: rootView)
        
        if showPreviousResults {
            view.addObserver(self, forKeyPath: "hidden", options: [.new, .old], context: &hiddenKey)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if showPreviousResults {
            view.removeObserver(self, forKeyPath: "hidden")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &hiddenKey {
            if let changed = change?[.newKey] as? NSNumber, changed.boolValue {
                view.isHidden = false
            }
        } else {
            if super.responds(to: #selector(observeValue(forKeyPath:of:change:context:))) {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
}