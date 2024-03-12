//
//  PushController.swift
//  
//
//  Created by Franklyn on 15/06/2022.
//

import SwiftUI
import Combine


public protocol PushedViewControllerTitleProviding {
    var navbarTitle: String? { get }
}

public protocol Navigating: AnyObject {
    func navigate<ViewModel, Destination: View>(config: NavigationConfig?, viewModel: ViewModel, @ViewBuilder destination: @escaping (ViewModel, Navigating) -> Destination)
    func pop()
    func updateBarButtons(_ buttons: BarButtons)
}


internal final class PushController<Content: View>: Navigating {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let subject = PassthroughSubject<UIViewController?, Never>()
    lazy var pushedViewControllerPublisher = subject.eraseToAnyPublisher()
    
    var parent: NavigationConfiguring?
    var currentTopViewController: UIViewController?
    
    func navigate<ViewModel, Destination: View>(_ navigate: Published<ViewModel?>.Publisher, config: @escaping (ViewModel) -> (NavigationConfig?), @ViewBuilder destination: @escaping (ViewModel, Navigating) -> Destination) {
        
        navigate
            .sink { [weak self] viewModel in
                guard let self = self, let viewModel = viewModel else {
                    self?.subject.send(nil)
                    return
                }
                
                let title: String?
                if let viewModel = viewModel as? PushedViewControllerTitleProviding {
                    title = viewModel.navbarTitle
                } else {
                    title = nil
                }
                
                let viewController = SwiftUIViewController(config: config(viewModel), title: title, hasTranslucentNavBar: self.parent?.hasTranslucentBackground == true, content: destination(viewModel, self))
                self.currentTopViewController = viewController
                
                self.subject.send(viewController)
            }
            .store(in: &cancellables)
    }
    
    func navigate<ViewModel, Content: View>(config: NavigationConfig?, viewModel: ViewModel, @ViewBuilder destination: @escaping (ViewModel, Navigating) -> Content) {
        
        let title: String?
        if let viewModel = viewModel as? PushedViewControllerTitleProviding {
            title = viewModel.navbarTitle
        } else {
            title = nil
        }
        
        let viewController = SwiftUIViewController(config: config, title: title, hasTranslucentNavBar: self.parent?.hasTranslucentBackground == true, content: destination(viewModel, self))
        self.currentTopViewController = viewController
        
        self.subject.send(viewController)
    }
    
    func pop() {
        subject.send(nil)
    }
    
    func updateBarButtons(_ buttons: BarButtons) {
        
        guard let currentTopViewController = currentTopViewController else {
            return
        }
        guard let navConfigurator = currentTopViewController as? NavigationConfiguring else {
            return
        }
        
        navConfigurator.setupBarButtons(buttons, style: .useParent, for: currentTopViewController)
    }
}
