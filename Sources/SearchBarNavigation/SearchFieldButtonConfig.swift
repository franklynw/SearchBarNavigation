//
//  SearchFieldButtonConfig.swift
//  
//
//  Created by Franklyn Weber on 02/03/2021.
//

import UIKit


public struct SearchFieldButtonConfig {
    let image: UIImage
    let action: () -> ()
    
    public init(image: UIImage, action: @escaping () -> ()) {
        self.image = image
        self.action = action
    }
}
