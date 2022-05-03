//
//  SearchBarNavigation+Extensions.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


extension SearchBarNavigation {
    
    /// Sets the navigation bar style - will override any value set by the viewModel
    /// - Parameter style: a NavigationBarStyle case
    public func navigationBarStyle(_ style: NavigationBarStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
    
    /// Disables the default prefersLargeTitles setting
    public var disableLargeTitles: Self {
        var copy = self
        copy.prefersLargeTitles = false
        return copy
    }
    
    /// Make the navigation bar translucent
    public var translucentBackground: Self {
        var copy = self
        copy.hasTranslucentBackground = true
        return copy
    }
    
    /// Sets the placeholder text in the search field
    /// - Parameter placeHolder: a String
    public func placeholder(_ placeholder: String) -> Self {
        var copy = self
        copy.placeholder = placeholder
        return copy
    }
    
    /// Set the search scope buttons
    /// - Parameter searchScopeTitles: the titles to use for the search scope buttons
    public func searchScopeTitles(_ searchScopeTitles: [String]) -> Self {
        var copy = self
        copy.searchScopeTitles = searchScopeTitles
        return copy
    }
    
    /// Buttons for the navigation bar
    /// - Parameter barButtons: a BarButtons instance
    public func barButtons(_ barButtons: BarButtons) -> Self {
        var copy = self
        copy.barButtons = barButtons
        return copy
    }
    
    /// Button for the left of the search text field
    /// - Parameter searchFieldButton: an SearchFieldButton case
    public func searchFieldButton(_ searchFieldButton: BarButton) -> Self {
        var copy = self
        copy.searchFieldButton = searchFieldButton
        return copy
    }
    
    /// Gives the searchField an inputAccessoryView
    /// - Parameter searchInputAccessory: a SearchInputAccessory describing the inputAccessoryView
    public func searchInputAccessory(_ searchInputAccessory: SearchInputAccessory) -> Self {
        var copy = self
        copy.searchInputAccessory = searchInputAccessory
        return copy
    }
    
    /// The colour to use for the background of the whole search results screen - defaults to white if unused
    /// - Parameter searchViewBackgroundColor: a Color
    public func searchViewBackgroundColor(_ searchViewBackgroundColor: Color) -> Self {
        var copy = self
        copy.searchViewBackgroundColor = searchViewBackgroundColor
        return copy
    }
    
    /// The colour to use for the headers of the results sections - defaults to grey if unused
    /// - Parameter resultsHeadersColor: a Color
    public func searchResultsHeadersColor(_ searchResultsHeadersColor: Color) -> Self {
        var copy = self
        copy.searchResultsHeadersColor = searchResultsHeadersColor
        return copy
    }
    
    /// The colour to use for the text of the result items - defaults to Color(.label) if unused
    /// - Parameter searchResultsTextColor: a Color
    public func searchResultsTextColor(_ searchResultsTextColor: Color) -> Self {
        var copy = self
        copy.searchResultsTextColor = searchResultsTextColor
        return copy
    }
    
    /// The colour to use for the Cancel button - defaults to Color(.link) if unused
    /// - Parameter cancelButtonColor: a Color
    public func cancelButtonColor(_ cancelButtonColor: Color) -> Self {
        var copy = self
        copy.cancelButtonColor = cancelButtonColor
        return copy
    }
    
    /// Closure which can be invoked by a search item
    /// - Parameter itemSelected: the closure which will be invoked
    public func itemSelected(_ itemSelected: SearchResultsView<T>.Select) -> Self {
        var copy = self
        copy.itemSelected = itemSelected
        return copy
    }
    
    /// If the viewModel has previous results, show them when the user taps the search field
    public var showLastResultsOnActivate: Self {
        var copy = self
        copy.showsLastResultsOnActivate = true
        return copy
    }
    
    /// Cancel the search when dismissing the keyboard (default behaviour is to leave the results view showing)
    public var cancelSearchOnKeyboardDismiss: Self {
        var copy = self
        copy.cancelsSearchOnKeyboardDismiss = true
        return copy
    }
    
    /// Disable the animations when the search results change
    public var disableResultsChangedAnimations: Self {
        var copy = self
        copy.disablesResultsChangedAnimations = true
        return copy
    }
    
    /// Programmatically bring up the search results, with the search textField active
    /// - Parameter becomeFirstResponder: a published Bool value
    public func becomeFirstResponder(_ becomeFirstResponder: Published<Bool>.Publisher) -> Self {
        var copy = self
        copy.becomeFirstResponder = becomeFirstResponder
        return copy
    }
}
