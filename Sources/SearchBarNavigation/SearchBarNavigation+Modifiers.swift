//
//  SearchBarNavigation+Extensions.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


extension SearchBarNavigation {
    
    /// Sets the navigation bar style
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
    /// - Parameter searchFieldButton: an ImageButtonConfig instance
    public func searchFieldButton(_ searchFieldButton: ImageButtonConfig) -> Self {
        var copy = self
        copy.searchFieldButton = searchFieldButton
        return copy
    }
    
    /// Sets the title of the Other section of the results - if not used, will default to "Recents"
    /// - Parameter otherResultsSectionTitle: a String
    public func otherResultsSectionTitle(_ otherResultsSectionTitle: String) -> Self {
        var copy = self
        copy.otherResultsSectionTitle = otherResultsSectionTitle
        return copy
    }
    
    /// Sets the title of the "Results" section of the results - if not used, will default to "Results"
    /// - Parameter resultsSectionTitle: a String
    public func resultsSectionTitle(_ resultsSectionTitle: String) -> Self {
        var copy = self
        copy.resultsSectionTitle = resultsSectionTitle
        return copy
    }
    
    /// The colour to use for the text of the other results items - defaults to Color(.label) if unused
    /// - Parameter recentsTextColor: a Color
    public func otherResultsTextColor(_ otherResultsTextColor: Color) -> Self {
        var copy = self
        copy.otherResultsTextColor = otherResultsTextColor
        return copy
    }
    
    /// The colour to use for the background of the other results area of the results list - defaults to Color(.systemBackground) if unused
    /// - Parameter recentsBackgroundColor: a Color
    public func otherResultsBackgroundColor(_ otherResultsBackgroundColor: Color) -> Self {
        var copy = self
        copy.otherResultsBackgroundColor = otherResultsBackgroundColor
        return copy
    }
    
    /// The colour to use for the text of the result items - defaults to Color(.label) if unused
    /// - Parameter resultsTextColor: a Color
    public func resultsTextColor(_ resultsTextColor: Color) -> Self {
        var copy = self
        copy.resultsTextColor = resultsTextColor
        return copy
    }
    
    /// The colour to use for the background of the results area of the results list - defaults to Color(.systemBackground) if unused
    /// - Parameter resultsBackgroundColor: a Color
    public func resultsBackgroundColor(_ resultsBackgroundColor: Color) -> Self {
        var copy = self
        copy.resultsBackgroundColor = resultsBackgroundColor
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
