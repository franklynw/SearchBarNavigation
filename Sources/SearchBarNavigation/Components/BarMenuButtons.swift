//
//  BarMenuButtons.swift
//  
//
//  Created by Franklyn Weber on 09/03/2021.
//

import SwiftUI
import FWMenu


public struct BarMenuButton: FWMenuPresenting {
    let imageSystemName: String?
    let imageName: String?
    public let menuType: FWMenuType
    public let content: () -> ([[FWMenuItem]])
    public let contentBackgroundColor: Color?
    public let contentAccentColor: Color?
    public let font: Font?
    
    public init(menuSections: @escaping () -> ([[FWMenuItem]]), imageSystemName: String, menuType: FWMenuType = .standard, contentBackgroundColor: Color? = nil, contentAccentColor: Color? = nil, font: Font? = nil) {
        content = menuSections
        self.imageSystemName = imageSystemName
        self.menuType = menuType
        self.contentBackgroundColor = contentBackgroundColor
        self.contentAccentColor = contentAccentColor
        self.font = font
        imageName = nil
    }
    
    public init(menuSections: @escaping () -> ([[FWMenuItem]]), imageName: String, menuType: FWMenuType = .standard, contentBackgroundColor: Color? = nil, contentAccentColor: Color? = nil, font: Font? = nil) {
        content = menuSections
        self.imageName = imageName
        self.menuType = menuType
        self.contentBackgroundColor = contentBackgroundColor
        self.contentAccentColor = contentAccentColor
        self.font = font
        imageSystemName = nil
    }
}


public struct BarMenuButtons {
    let leading: [BarMenuButton]
    let trailing: [BarMenuButton]
    let color: Color?
    
    public init(leading: [BarMenuButton] = [], trailing: [BarMenuButton] = [], color: Color? = nil) {
        self.leading = leading
        self.trailing = trailing
        self.color = color
    }
}
