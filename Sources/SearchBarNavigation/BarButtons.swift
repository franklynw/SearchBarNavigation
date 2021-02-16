//
//  BarButtons.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI
import ButtonConfig


public struct BarButtons {
    let leading: [ButtonConfig]
    let trailing: [ButtonConfig]
    let color: Color?
    
    public init(leading: [ButtonConfig] = [], trailing: [ButtonConfig] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}
