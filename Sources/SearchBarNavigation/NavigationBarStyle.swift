//
//  NavigationBarStyle.swift
//  
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI


/// Configure the navigation bar's style
public enum NavigationBarStyle {
    
    /// Allows the title and background to be coloured
    case colored(textColor: Color, backgroundColor: Color)
    
    /// Allows the title to be coloured, and a background image set
    case withImage(textColor: Color, image: UIImage)
}

