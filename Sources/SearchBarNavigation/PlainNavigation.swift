//
//  PlainNavigation.swift
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI
import FWCommonProtocols
import ButtonConfig
import FWMenu


public struct PlainNavigation<T: NavigationStyleProviding, Content: View>: UIViewControllerRepresentable, NavigationConfiguring {
    
    @ObservedObject internal var viewModel: T
    internal let content: () -> Content
    
    internal var style: NavigationBarStyle?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var placeholder: String?
    internal var barButtons: BarButtons?
    internal var barMenuButtons: BarMenuButtons?
    
    
    public init(_ viewModel: T, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        setupStyle(for: navigationController, viewModel: viewModel)
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        setupStyle(for: uiViewController, viewModel: viewModel)
        context.coordinator.update(content: content())
    }
    
    public func makeCoordinator() -> FWCoordinator<T, Content> {
        FWCoordinator(self)
    }
    
    
    public class FWCoordinator<T: NavigationStyleProviding, Content: View>: NSObject {
        
        let parent: PlainNavigation<T, Content>
        
        let rootViewController: UIHostingController<Content>
        
        
        init(_ parent: PlainNavigation<T, Content>) {
            
            self.parent = parent
            
            rootViewController = UIHostingController(rootView: parent.content())
            rootViewController.view.backgroundColor = .clear
            
            super.init()
            
            setupBarButtons()
        }
        
        func update(content: Content) {
            setupBarButtons()
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        private func setupBarButtons() {
            
            var leadingButtons = [UIBarButtonItem]()
            var trailingButtons = [UIBarButtonItem]()
            var buttonsColor: Color? = nil
            
            if let barButtons = parent.barButtons {
                leadingButtons += barButtons.leading.compactMap { $0.barButtonItem }
                trailingButtons += barButtons.trailing.compactMap { $0.barButtonItem }
                buttonsColor = barButtons.color
            }
            
            if let barMenuButtons = parent.barMenuButtons {
                
                leadingButtons += barMenuButtons.leading.enumerated().map { pair in
                    let buttonConfig = pair.element
                    let barButton: UIBarButtonItem
                    if let imageSystemName = buttonConfig.imageSystemName {
                        barButton = UIBarButtonItem.button(with: imageSystemName) {
                            MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: CGFloat(pair.offset + 1) * 0.15)
                        }
                    } else {
                        let imageName = buttonConfig.imageName!
                        let image = UIImage(named: imageName)!
                        barButton = UIBarButtonItem.button(with: image) {
                            MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: CGFloat(pair.offset + 1) * 0.15)
                        }
                    }
                    return barButton
                }
                trailingButtons += barMenuButtons.trailing.enumerated().map { pair in
                    let buttonConfig = pair.element
                    let barButton: UIBarButtonItem
                    if let imageSystemName = buttonConfig.imageSystemName {
                        barButton = UIBarButtonItem.button(with: imageSystemName) {
                            MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: 1 - CGFloat(pair.offset + 1) * 0.15)
                        }
                    } else {
                        let imageName = buttonConfig.imageName!
                        let image = UIImage(named: imageName)!
                        barButton = UIBarButtonItem.button(with: image) {
                            MenuPresenter.presentFromNavBar(parent: buttonConfig, withRelativeX: 1 - CGFloat(pair.offset + 1) * 0.15)
                        }
                    }
                    return barButton
                }
                buttonsColor = barMenuButtons.color
            }
            
            let color: Color? = buttonsColor ?? {
                
                let parentStyle = parent.style
                let viewModelStyle = parent.viewModel.navigationBarStyle
                
                switch parentStyle ?? viewModelStyle {
                case .colored(let textColor, _), .withImage(let textColor, _), .withColorAndImage(let textColor, _, _):
                    return textColor
                case .none:
                    return nil
                }
            }()
            
            if let color = color {
                (leadingButtons + trailingButtons).forEach {
                    $0.tintColor = color.uiColor
                }
            }
            
            rootViewController.navigationItem.leftBarButtonItems = leadingButtons
            rootViewController.navigationItem.rightBarButtonItems = trailingButtons
        }
    }
}
