//
//  PushController.swift
//  
//
//  Created by Franklyn on 15/06/2022.
//

import SwiftUI
import Combine


internal final class PushController<Content: View> {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let subject = PassthroughSubject<UIViewController?, Never>()
    lazy var pushedViewControllerPublisher = subject.eraseToAnyPublisher()
    
    var parent: NavigationConfiguring?
    
    func navigate<ViewModel, Destination: View>(_ navigate: Published<ViewModel?>.Publisher, config: NavigationConfig?, @ViewBuilder destination: @escaping (ViewModel) -> Destination) {
        
        navigate
            .sink { [weak self] viewModel in
                guard let self = self, let viewModel = viewModel else {
                    self?.subject.send(nil)
                    return
                }
                let viewController = SwiftUIViewController(config: config, hasTranslucentNavBar: self.parent?.hasTranslucentBackground == true, content: destination(viewModel))
                self.subject.send(viewController)
            }
            .store(in: &cancellables)
    }
}

