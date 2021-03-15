//
//  SearchInputAccessoryView.swift
//  
//
//  Created by Franklyn Weber on 13/03/2021.
//

import SwiftUI
import Combine
import FWMenu
import ButtonConfig


public enum SearchInputAccessory {
    
    /*
     Enum for configuring an inputAccessoryView to use with the search bar
     */
    
    /// Configures the bar with an array of leading and/or trailing buttons, with optional parameters for the keyboard dismiss button and the bar background colour
    case buttons(leading: [ImageButtonConfig] = [], trailing: [ImageButtonConfig] = [], keyboardDismissButtonConfig: ImageButtonConfig? = nil, backgroundColor: Color? = nil)
    
    /// Configures the bar with a title, with optional parameters for the keyboard dismiss button and the bar background colour
    case title(FWMenuItem.Title, keyboardDismissButton: ImageButtonConfig? = nil, backgroundColor: Color? = nil)
    
    /// Configures the bar with a description and a button, with optional parameters for the keyboard dismiss button and the bar background colour
    case textWithButton(text: Published<String>.Publisher, buttonConfig: ImageButtonConfig, keyboardDismissButtonConfig: ImageButtonConfig? = nil, backgroundColor: Color? = nil)
}


// MARK: - Internal
extension SearchInputAccessory {
    
    func view(buttonColor: UIColor?, dismissKeyboard: @escaping () -> ()) -> SearchInputAccessoryView {
        return SearchInputAccessoryView.withAccessory(self, buttonColor: buttonColor, dismissKeyboard: dismissKeyboard)
    }
}
