//
//  SearchBarNavigation+Extensions.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


extension SearchBarNavigation {
    
    /// Sets the navigation bar title
    /// - Parameter title: a Title case
    public func navigationBarTitle(_ title: Title) -> Self {
        var copy = self
        copy.title = title
        return copy
    }
    
    /// Sets the navigation bar title
    /// - Parameter title: a String
    public func navigationBarTitle(_ title: String) -> Self {
        var copy = self
        copy.title = .standard(title)
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
    
    /// Buttons for the navigation bar
    /// - Parameter barButtons: a BarButtons instance
    public func barButtons(_ barButtons: BarButtons) -> Self {
        var copy = self
        copy.barButtons = barButtons
        return copy
    }
    
    /// Sets the title of the "Recents" section of the results - if not used, will default to "Recents"
    /// - Parameter recentsSectionTitle: a String
    public func recentsSectionTitle(_ recentsSectionTitle: String) -> Self {
        var copy = self
        copy.recentsSectionTitle = recentsSectionTitle
        return copy
    }
    
    /// Sets the title of the "Results" section of the results - if not used, will default to "Results"
    /// - Parameter resultsSectionTitle: a String
    public func resultsSectionTitle(_ resultsSectionTitle: String) -> Self {
        var copy = self
        copy.resultsSectionTitle = resultsSectionTitle
        return copy
    }
    
    /// The colour to use for the text of the recent items - defaults to Color(.label) if unused
    /// - Parameter recentsTextColor: a Color
    public func recentsTextColor(_ recentsTextColor: Color) -> Self {
        var copy = self
        copy.recentsTextColor = recentsTextColor
        return copy
    }
    
    /// The colour to use for the background of the recents area of the results list - defaults to Color(.systemBackground) if unused
    /// - Parameter recentsBackgroundColor: a Color
    public func recentsBackgroundColor(_ recentsBackgroundColor: Color) -> Self {
        var copy = self
        copy.recentsBackgroundColor = recentsBackgroundColor
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
    
    /// The maximum number of rows to show in the recents section - defaults to 3 if unused
    /// - Parameter maxRecents: an Int value
    public func maxRecents(_ maxRecents: Int) -> Self {
        var copy = self
        copy.maxRecents = maxRecents
        return copy
    }
    
    /// The maximum number of rows to show in the results section - defaults to unlimited if unused
    /// - Parameter maxResults: an Int value
    public func maxResults(_ maxResults: Int) -> Self {
        var copy = self
        copy.maxResults = maxResults
        return copy
    }
}
