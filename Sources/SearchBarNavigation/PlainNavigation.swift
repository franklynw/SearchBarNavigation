//
//  PlainNavigation.swift
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI
import FWCommonProtocols
import ButtonConfig


public struct PlainNavigation<Content: View>: UIViewControllerRepresentable, NavigationConfiguring {
    
    internal let content: () -> Content
    
    internal var style: NavigationBarStyle?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var placeholder: String?
    internal var barButtons: BarButtons?
    
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        setupStyle(for: navigationController)
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    public func makeCoordinator() -> FWCoordinator<Content> {
        FWCoordinator(self)
    }
    
    
    public class FWCoordinator<Content: View>: NSObject {
        
        let parent: PlainNavigation<Content>
        
        let rootViewController: UIHostingController<Content>
        
        
        init(_ parent: PlainNavigation<Content>) {
            
            self.parent = parent
            
            rootViewController = UIHostingController(rootView: parent.content())
            
            super.init()
            
            if let barButtons = parent.barButtons {
                
                let leadingButtons = barButtons.leading.compactMap { $0.barButtonItem }
                let trailingButtons = barButtons.trailing.compactMap { $0.barButtonItem }
                
                let color: Color? = barButtons.color ?? {
                    
                    switch parent.style {
                    case .colored(let textColor, _), .withImage(let textColor, _):
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
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
    }
}
