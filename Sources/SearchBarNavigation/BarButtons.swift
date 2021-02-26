//
//  BarButtons.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


public struct BarButtons {
    let leading: [ImageButtonConfig]
    let trailing: [ImageButtonConfig]
    let color: Color?
    
    public init(leading: [ImageButtonConfig] = [], trailing: [ImageButtonConfig] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}
