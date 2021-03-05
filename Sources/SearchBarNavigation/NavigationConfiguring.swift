//
//  NavigationConfiguring.swift
//  
//
//  Created by Franklyn Weber on 04/03/2021.
//

import UIKit


protocol NavigationConfiguring {
    var style: NavigationBarStyle? { get }
    var hasTranslucentBackground: Bool { get }
    func setupStyle(for navigationController: UINavigationController)
    func setBackgroundImage(_ image: UIImage, for navigationBar: UINavigationBar)
}


extension NavigationConfiguring {
    
    func setupStyle(for navigationController: UINavigationController) {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        switch style {
        case .colored(let titleColor, let backgroundColor):
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.backgroundColor = backgroundColor.uiColor
            navigationController.navigationBar.backgroundColor = backgroundColor.uiColor // this is needed as well as the appearance to work when it has a transparent background
        
        case .withImage(let titleColor, let image):
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]
            
            setBackgroundImage(image, for: navigationController.navigationBar)
            
        case .none:
            break
        }
        
        if hasTranslucentBackground {
            navBarAppearance.configureWithTransparentBackground()
        }
        
        navigationController.navigationBar.standardAppearance = navBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    func setBackgroundImage(_ image: UIImage, for navigationBar: UINavigationBar) {
        
        // The problem with the normal approach is that the image squashes & stretches -
        // we want it to scroll up beyond the top of the screen, & only stretch when pulled down
        // navBarAppearance.backgroundImage = image
        
        // This feels like a pretty hacky solution, though it works... (anyone who can think of a better way please let me know!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if let backgroundView = navigationBar.subviews.first {
                
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.alpha = 0
                
                backgroundView.insertSubview(imageView, at: 0)
                
                let offset: CGFloat
                
                if let window = UIApplication.window, let statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height {
                    offset = -statusBarHeight
                } else {
                    offset = 0
                }

                imageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
                imageView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor).isActive = true
                imageView.topAnchor.constraint(lessThanOrEqualTo: navigationBar.topAnchor, constant: offset).isActive = true
                imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
                
                UIView.animate(withDuration: 0.3) {
                    imageView.alpha = 1
                }
            }
        }
    }
}
