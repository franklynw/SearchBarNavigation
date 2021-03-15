//
//  BarButtons.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


public struct BarButtons {
    
    /*
     Struct for configuring the Navigation Bar buttons
     */
    
    let leading: [BarButton]
    let trailing: [BarButton]
    let color: Color?
    
    /// Initialiser which lets you specify leading buttons, trailing buttons & button colour
    /// - Parameters:
    ///   - leading: an array of BarButton
    ///   - trailing: an array of BarButton
    ///   - color: an optional colour for the buttons
    public init(leading: [BarButton] = [], trailing: [BarButton] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}


public enum BarButton {
    
    /// Use this case for a button with an action
    case button(ImageButtonConfig)
    
    /// Use this case for a button which presents a menu
    case menu(BarMenuButton)
}
