//
//  PlainNavigation.swift
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI
import FWCommonProtocols
import ButtonConfig


public struct PlainNavigation<T: NavigationStyleProviding, Content: View>: UIViewControllerRepresentable, NavigationConfiguring {
    
    @ObservedObject internal var viewModel: T
    internal let content: () -> Content
    
    internal var style: NavigationBarStyle?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var placeholder: String?
    internal var barButtons: BarButtons?
    
    
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
            
            if let barButtons = parent.barButtons {
                
                let leadingButtons = barButtons.leading.compactMap { $0.barButtonItem }
                let trailingButtons = barButtons.trailing.compactMap { $0.barButtonItem }
                
                let color: Color? = barButtons.color ?? {
                    
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
}
