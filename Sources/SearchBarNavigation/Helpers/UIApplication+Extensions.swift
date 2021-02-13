//
//  UIApplication+Extensions.swift
//
//  Created by Franklyn Weber on 09/02/2021.
//

import UIKit


extension UIApplication {
    
    static var window: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
