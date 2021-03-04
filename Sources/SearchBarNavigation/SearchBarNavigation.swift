//
//  SearchBarNavigation.swift
//
//  Created by Franklyn Weber on 15/01/2021.
//  With guidance from Yugantar Jain - https://stackoverflow.com/a/63298758/331854
//

import SwiftUI
import FWCommonProtocols
import ButtonConfig


public struct SearchBarNavigation<T: SearchBarShowing, Content: View>: UIViewControllerRepresentable {
    
    internal let viewModel: T
    internal let content: () -> Content
    
    internal var style: Style?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var placeholder: String?
    internal var searchScopeTitles: [String] = []
    internal var barButtons: BarButtons?
    internal var searchFieldButton: ImageButtonConfig?
    internal var otherResultsSectionTitle: String?
    internal var resultsSectionTitle: String?
    internal var resultsTextColor: Color?
    internal var resultsBackgroundColor: Color?
    internal var otherResultsTextColor: Color?
    internal var otherResultsBackgroundColor: Color?
    internal var cancelButtonColor: Color?
    internal var maxOtherResults: Int = .max
    internal var maxResults: Int = .max
    internal var itemSelected: ((String) -> ())?
    
    /// Configure the navigation bar's style
    public enum Style {
        
        /// Allows the title and background to be coloured
        case colored(textColor: Color, backgroundColor: Color)
        
        /// Allows the title to be coloured, and a background image set
        case withImage(textColor: Color, image: UIImage)
    }
    
    
    public init(_ viewModel: T, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        setupStyle(for: navigationController)
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    public func makeCoordinator() -> Coordinator<T, Content> {
        Coordinator(self)
    }
}


// MARK: - Private
extension SearchBarNavigation {
    
    private func setupStyle(for navigationController: UINavigationController) {
        
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
    
    private func setBackgroundImage(_ image: UIImage, for navigationBar: UINavigationBar) {
        
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
