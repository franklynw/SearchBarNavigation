//
//  PlainNavigation+Modifiers.swift
//  
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI


extension PlainNavigation {
    
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
    
    /// Buttons for the navigation bar
    /// - Parameter barButtons: a BarButtons instance
    public func barButtons(_ barButtons: BarButtons) -> Self {
        var copy = self
        copy.barButtons = barButtons
        return copy
    }
}
