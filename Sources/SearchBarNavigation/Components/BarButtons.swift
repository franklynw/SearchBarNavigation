//
//  BarButtons.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


public struct BarButtons {
    let leading: [BarButton]
    let trailing: [BarButton]
    let color: Color?
    
    public init(leading: [BarButton] = [], trailing: [BarButton] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}


public enum BarButton {
    case button(ImageButtonConfig)
    case menu(BarMenuButton)
}
