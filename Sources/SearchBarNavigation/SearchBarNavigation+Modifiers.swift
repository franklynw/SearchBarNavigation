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
    
    /// If you want to use the more customisable FWMenu for the bar buttons, set them up with this function
    /// - Parameter barMenuButtons: a BarMenuButtons instance
    public func barMenuButtons(_ barMenuButtons: BarMenuButtons) -> Self {
        var copy = self
        copy.barMenuButtons = barMenuButtons
        return copy
    }
    
    /// Button for the left of the search text field
    /// - Parameter searchFieldButton: an ImageButtonConfig instance
    public func searchFieldButton(_ searchFieldButton: ImageButtonConfig) -> Self {
        var copy = self
        copy.searchFieldButton = searchFieldButton
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
    
    /// Sets the title of the "Results" section of the results - if not used, will default to "Results"
    /// - Parameter resultsSectionTitle: a String
    public func resultsSectionTitle(_ resultsSectionTitle: String) -> Self {
        var copy = self
        copy.resultsSectionTitle = resultsSectionTitle
        return copy
    }
    
    /// Sets the title of the Other section of the results - if not used, will default to "Recents"
    /// - Parameter otherResultsSectionTitle: a String
    public func otherResultsSectionTitle(_ otherResultsSectionTitle: String) -> Self {
        var copy = self
        copy.otherResultsSectionTitle = otherResultsSectionTitle
        return copy
    }
    
    /// The view to display if the other results are empty
    /// - Parameter otherResultsEmptyView: a view
    public func otherResultsEmptyView<T: View>(@ViewBuilder _ otherResultsEmptyView: @escaping () -> T) -> Self {
        var copy = self
        copy.otherResultsEmptyView = AnyView(otherResultsEmptyView())
        return copy
    }
    
    /// The view to display if the results are empty
    /// - Parameter resultsEmptyView: a view
    public func resultsEmptyView<T: View>(@ViewBuilder _ resultsEmptyView: @escaping () -> T) -> Self {
        var copy = self
        copy.resultsEmptyView = AnyView(resultsEmptyView())
        return copy
    }
    
    /// The colour to use for the Cancel button - defaults to Color(.link) if unused
    /// - Parameter cancelButtonColor: a Color
    public func cancelButtonColor(_ cancelButtonColor: Color) -> Self {
        var copy = self
        copy.cancelButtonColor = cancelButtonColor
        return copy
    }
    
    /// The maximum number of rows to show in the other section - defaults to 3 if unused
    /// - Parameter maxOtherResults: an Int value
    public func maxOtherResults(_ maxOtherResults: Int) -> Self {
        var copy = self
        copy.maxOtherResults = maxOtherResults
        return copy
    }
    
    /// The maximum number of rows to show in the results section - defaults to unlimited if unused
    /// - Parameter maxResults: an Int value
    public func maxResults(_ maxResults: Int) -> Self {
        var copy = self
        copy.maxResults = maxResults
        return copy
    }
    
    /// Closure which can be invoked by a search item
    /// - Parameter itemSelected: the closure which will be invoked
    public func itemSelected(_ itemSelected: @escaping (String) -> ()) -> Self {
        var copy = self
        copy.itemSelected = itemSelected
        return copy
    }
}
