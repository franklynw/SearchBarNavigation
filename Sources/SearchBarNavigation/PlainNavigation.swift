//
//  PlainNavigation.swift
//
//  Created by Franklyn Weber on 04/03/2021.
//

import SwiftUI
import Combine
import FWCommonProtocols
import ButtonConfig
import FWMenu


public struct PlainNavigation<T: NavigationStyleProviding, Content: View>: UIViewControllerRepresentable, NavigationConfiguring {
        
    @ObservedObject internal var viewModel: T
    internal let content: () -> Content
    
    internal var style: NavigationBarStyle?
    internal var prefersLargeTitles = true
    internal var hasTranslucentBackground = false
    internal var backgroundColor: Color = .clear
    internal var backgroundView: UIView?
    internal var placeholder: String?
    internal var barButtons: BarButtons?
    internal var navBarTapped: (() -> ())?
    internal var shouldPop: ((@escaping (Bool) -> ()) -> ())?
    
    @State internal var pushController = PushController<Content>()
    
    
    public init(_ viewModel: T, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }

    public func makeUIViewController(context: Context) -> ControlledPopNavigationController {
        
        let navigationController = ControlledPopNavigationController(rootViewController: context.coordinator.rootViewController, navBarTapped: navBarTapped)
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        setupStyle(for: navigationController, viewModel: viewModel)
        navigationController.popDelegate = context.coordinator
        
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: ControlledPopNavigationController, context: Context) {
        setupStyle(for: uiViewController, viewModel: viewModel)
        context.coordinator.update(content: content())
    }
    
    public func makeCoordinator() -> FWCoordinator<T, Content> {
        FWCoordinator(self)
    }
    
    
    public class FWCoordinator<T: NavigationStyleProviding, Content: View>: NSObject {
        
        private var subscriptions = Set<AnyCancellable>()
        
        let parent: PlainNavigation<T, Content>
        
        let rootViewController: UIHostingController<Content>
        
        
        init(_ parent: PlainNavigation<T, Content>) {
            
            self.parent = parent
            
            rootViewController = UIHostingController(rootView: parent.content())
            rootViewController.view.backgroundColor = UIColor(parent.backgroundColor)
            
            if let backgroundView = parent.backgroundView {
                rootViewController.view.insertSubview(backgroundView, at: 0)
                NSLayoutConstraint.activate([
                    backgroundView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
                    backgroundView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor),
                    backgroundView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
                    backgroundView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor)
                ])
            }
            
            super.init()
            
            parent.pushController.pushedViewControllerPublisher
                .sink { [weak self] viewController in
                    guard let self = self, let viewController = viewController else {
                        self?.rootViewController.navigationController?.popViewController(animated: true)
                        return
                    }
                    self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
                }
                .store(in: &subscriptions)
            
            setupBarButtons()
        }
        
        func update(content: Content) {
            setupBarButtons()
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        private func setupBarButtons() {
            
            guard let barButtons = parent.barButtons else {
                return
            }
            
            let style = parent.style ?? parent.viewModel.navigationBarStyle
            parent.setupBarButtons(barButtons, style: style, for: rootViewController)
        }
    }
}


extension PlainNavigation.FWCoordinator: ControlledPopDelegate {
    
    func navigationController(_ navigationController: UINavigationController, shouldPop viewController: UIViewController?, pop: (() -> ())?) -> Bool {
        
        if let parentShouldPop = parent.shouldPop {
            
            let confirm: (Bool) -> () = { shouldPop in
                if shouldPop {
                    pop?()
                }
            }
            parentShouldPop(confirm)
            
            return false
        }
        
        return true
    }
    
    var shouldPop: ((@escaping (Bool) -> ()) -> ())? {
        parent.shouldPop
    }
}
