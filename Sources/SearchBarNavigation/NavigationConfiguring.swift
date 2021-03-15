//
//  NavigationConfiguring.swift
//  
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI
import FWMenu


protocol NavigationConfiguring {
    var style: NavigationBarStyle? { get }
    var hasTranslucentBackground: Bool { get }
    func setupStyle<T: NavigationStyleProviding>(for navigationController: UINavigationController, viewModel: T)
    func setBackgroundImage(_ image: UIImage, for navigationBar: UINavigationBar)
}

public extension NavigationStyleProviding {
    var navigationBarStyle: NavigationBarStyle? {
        return nil
    }
}


extension NavigationConfiguring {
    
    func setupStyle<T: NavigationStyleProviding>(for navigationController: UINavigationController, viewModel: T) {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        switch style ?? viewModel.navigationBarStyle {
        case .colored(let titleColor, let backgroundColor):
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.backgroundColor = backgroundColor.uiColor
            navigationController.navigationBar.backgroundColor = backgroundColor.uiColor // this is needed as well as the appearance to work when it has a transparent background
            
        case .withImage(let titleColor, let image):
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]
            
            setBackgroundImage(image, for: navigationController.navigationBar)
            
        case .withColorAndImage(let titleColor, let backgroundColor, let image):
            
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]
            navBarAppearance.backgroundColor = backgroundColor.uiColor
            navigationController.navigationBar.backgroundColor = backgroundColor.uiColor // this is needed as well as the appearance to work when it has a transparent background
        
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
                
                if let _ = backgroundView.subviews.first(where: { $0.tag == 9999 }) {
                    return
                }
                
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.alpha = 0
                imageView.tag = 9999
                
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
    
    func setupBarButtons(_ barButtons: BarButtons, style: NavigationBarStyle?, for viewController: UIViewController) {
        
        func makeMenuButton(_ buttonConfig: BarMenuButton, relativeX: CGFloat) -> UIBarButtonItem {
            
            let barButton: UIBarButtonItem
            if let imageSystemName = buttonConfig.imageSystemName {
                barButton = UIBarButtonItem.button(with: imageSystemName) {
                    MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: relativeX)
                }
            } else {
                let imageName = buttonConfig.imageName!
                let image = UIImage(named: imageName)!
                barButton = UIBarButtonItem.button(with: image) {
                    MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: relativeX)
                }
            }
            return barButton
        }
        
        let leadingButtons: [UIBarButtonItem] = barButtons.leading.enumerated().map { pair in
            switch pair.element {
            case .button(let buttonConfig):
                return buttonConfig.barButtonItem
            case .menu(let buttonConfig):
                return makeMenuButton(buttonConfig, relativeX: CGFloat(pair.offset + 1) * 0.15)
            }
        }
        let trailingButtons: [UIBarButtonItem] = barButtons.trailing.enumerated().map { pair in
            switch pair.element {
            case .button(let buttonConfig):
                return buttonConfig.barButtonItem
            case .menu(let buttonConfig):
                return makeMenuButton(buttonConfig, relativeX: 1 - CGFloat(pair.offset + 1) * 0.15)
            }
        }
        
        let color: Color? = barButtons.color ?? {
            
            switch style {
            case .colored(let textColor, _), .withImage(let textColor, _), .withColorAndImage(let textColor, _, _):
                return textColor
            case .none:
                return nil
            }
        }()
        
        (leadingButtons + trailingButtons).forEach {
            $0.width = 44 // there seems to be an issue where buttons have a very small tap area, this seems to improve it
            if let color = color {
                $0.tintColor = color.uiColor
            }
        }
        
        viewController.navigationItem.leftBarButtonItems = leadingButtons
        viewController.navigationItem.rightBarButtonItems = trailingButtons
    }
}
