//
//  BarMenuButtons.swift
//  
//
//  Created by Franklyn Weber on 09/03/2021.
//

import SwiftUI
import FWMenu


public struct BarMenuButton: FWMenuPresenting {
    
    /*
     Struct for configuring menu buttons used in the Navigation Bar (ie, if the button should present a menu)
     */
    
    public let menuType: FWMenuType
    public let content: () -> ([FWMenuSection])
    public let contentBackgroundColor: Color?
    public let contentAccentColor: Color?
    public let font: Font?
    
    public let hideMenuOnDeviceRotation = true
    
    let imageSystemName: String?
    let imageName: String?
    
    
    /// Initialiser which takes a SystemImageName parameter for the icon image
    /// - Parameters:
    ///   - menuSections: a closure providing the menu sections
    ///   - imageSystemName: the imageSystemName for the icon image
    ///   - menuType: the type of menu, defaults to .standard
    ///   - contentBackgroundColor: an optional background colour for the menu
    ///   - contentAccentColor: an optional content accent colour for the menu
    ///   - font: an optional font for the menu content
    public init(menuSections: @escaping () -> ([FWMenuSection]), imageSystemName: String, menuType: FWMenuType = .standard, contentBackgroundColor: Color? = nil, contentAccentColor: Color? = nil, font: Font? = nil) {
        content = menuSections
        self.imageSystemName = imageSystemName
        self.menuType = menuType
        self.contentBackgroundColor = contentBackgroundColor
        self.contentAccentColor = contentAccentColor
        self.font = font
        imageName = nil
    }
    
    /// Initialiser which takes a image name parameter for the icon image
    /// - Parameters:
    ///   - menuSections: a closure providing the menu sections
    ///   - imageName: the name for the icon image in the Assets
    ///   - menuType: the type of menu, defaults to .standard
    ///   - contentBackgroundColor: an optional background colour for the menu
    ///   - contentAccentColor: an optional content accent colour for the menu
    ///   - font: an optional font for the menu content
    public init(menuSections: @escaping () -> ([FWMenuSection]), imageName: String, menuType: FWMenuType = .standard, contentBackgroundColor: Color? = nil, contentAccentColor: Color? = nil, font: Font? = nil) {
        content = menuSections
        self.imageName = imageName
        self.menuType = menuType
        self.contentBackgroundColor = contentBackgroundColor
        self.contentAccentColor = contentAccentColor
        self.font = font
        imageSystemName = nil
    }
}
