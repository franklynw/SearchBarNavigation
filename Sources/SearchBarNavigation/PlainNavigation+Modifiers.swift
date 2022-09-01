//
//  PlainNavigation+Modifiers.swift
//  
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI


extension PlainNavigation {
    
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
    
    /// Buttons for the navigation bar
    /// - Parameter barButtons: a BarButtons instance
    public func barButtons(_ barButtons: BarButtons) -> Self {
        var copy = self
        copy.barButtons = barButtons
        return copy
    }
    
    /// Set the navigation
    /// - Parameters:
    ///   - navigate: a Publisher which emits a viewModel used to create the destination view
    ///   - destination: closure for building the view from the supplied viewModel
    public func navigate<ViewModel, Destination: View>(_ navigate: Published<ViewModel?>.Publisher, config: NavigationConfig? = nil, @ViewBuilder destination: @escaping (ViewModel) -> Destination) -> Self {
        pushController.navigate(navigate, config: config, destination: destination)
        return self
    }
    
    public func navigate<ViewModel, Destination: View>(on condition: Bool, navigate: Published<ViewModel?>.Publisher, config: NavigationConfig? = nil, @ViewBuilder destination: @escaping (ViewModel) -> Destination) -> Self {
        if condition {
            pushController.navigate(navigate, config: config, destination: destination)
        }
        return self
    }
    
    public func navBarTapped(_ navBarTapped: @escaping () -> ()) -> Self {
        var copy = self
        copy.navBarTapped = navBarTapped
        return copy
    }
    
    public func shouldPop(action: @escaping (@escaping (Bool) -> ()) -> ()) -> Self {
        var copy = self
        copy.shouldPop = action
        return copy
    }
    
    public func backgroundColor(_ backgroundColor: Color) -> Self {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }
    
    public func backgroundView<Content: View>(_ backgroundView: () -> Content) -> Self {
        var copy = self
        let uiView = UIHostingController(rootView: backgroundView()).view
        copy.backgroundView = uiView
        return copy
    }
}
