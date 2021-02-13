//
//  BarButtons.swift
//  
//
//  Created by Franklyn Weber on 13/02/2021.
//

import SwiftUI


public struct BarButtons {
    let leading: [MenuItem]
    let trailing: [MenuItem]
    let color: Color?
    
    init(leading: [MenuItem] = [], trailing: [MenuItem] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}
