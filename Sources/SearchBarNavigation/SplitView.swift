//
//  SplitView.swift
//  SearchBarNavigation
//
//  Created by Franklyn on 17/06/2022.
//

import SwiftUI
import Combine


public protocol SplitViewDetailsContaining: NavigationStyleProviding {
    associatedtype DetailsViewModel: ObservableObject
    var detailsViewModel: DetailsViewModel? { get }
}


public struct SplitView<T: ObservableObject & SplitViewDetailsContaining, MasterContent: View, DetailContent: View>: UIViewControllerRepresentable, NavigationConfiguring {
    
    @ObservedObject internal var viewModel: T
    
    public var style: NavigationBarStyle?
    public var hasTranslucentBackground = false
    internal var barButtons: BarButtons?
    
    internal let masterContent: (T) -> MasterContent
    internal let detailContent: (T.DetailsViewModel?) -> DetailContent
    
    
    public init(_ viewModel: T, @ViewBuilder masterContent: @escaping (T) -> MasterContent, @ViewBuilder detailContent: @escaping (T.DetailsViewModel?) -> DetailContent) {
        self.viewModel = viewModel
        self.masterContent = masterContent
        self.detailContent = detailContent
    }
    
    public func makeUIViewController(context: Context) -> UISplitViewController {
        
        let splitViewController = UISplitViewController(style: .doubleColumn)
        
        let masterViewController = context.coordinator.masterViewController
        let detailViewController = context.coordinator.detailViewController
        let navigationController = UINavigationController(rootViewController: detailViewController)
        
        setupStyle(for: navigationController, viewModel: viewModel)
        
        splitViewController.setViewController(masterViewController, for: .primary)
        splitViewController.setViewController(navigationController, for: .secondary)
        splitViewController.setViewController(masterViewController, for: .compact)
        
        splitViewController.delegate = context.coordinator
        
        return splitViewController
    }
    
    public func updateUIViewController(_ uiViewController: UISplitViewController, context: Context) {
        context.coordinator.update(content: self)
    }
    
    public func makeCoordinator() -> SplitViewCoordinator<T, MasterContent, DetailContent> {
        SplitViewCoordinator(self)
    }
}


public class SplitViewCoordinator<T: ObservableObject & SplitViewDetailsContaining, MasterContent: View, DetailContent: View>: NSObject, UISplitViewControllerDelegate {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var barButtons: (leadingButtons: [UIBarButtonItem], trailingButtons: [UIBarButtonItem])?
    
    private let parent: SplitView<T, MasterContent, DetailContent>
    
    internal let masterViewController: UIHostingController<MasterContent>
    internal let detailViewController: UIHostingController<DetailContent>
    
    
    internal init(_ parent: SplitView<T, MasterContent, DetailContent>) {
        
        self.parent = parent
        
        masterViewController = UIHostingController(rootView: parent.masterContent(parent.viewModel))
        detailViewController = UIHostingController(rootView: parent.detailContent(parent.viewModel.detailsViewModel))
        
        super.init()
        
        setupBarButtons()
    }
    
    internal func update(content: SplitView<T, MasterContent, DetailContent>) {
        
        setupBarButtons()
        
        masterViewController.rootView = content.masterContent(parent.viewModel)
        masterViewController.view.setNeedsDisplay()
        detailViewController.rootView = content.detailContent(parent.viewModel.detailsViewModel)
        detailViewController.view.setNeedsDisplay()
    }
    
    private func setupBarButtons() {
        
        guard let barButtons = parent.barButtons else {
            return
        }
        
        let style = parent.style ?? parent.viewModel.navigationBarStyle
        self.barButtons = parent.setupBarButtons(barButtons, style: style, for: detailViewController)
    }
}


extension SplitView {
    
    public func detailBarButtons(_ barButtons: BarButtons) -> Self {
        var copy = self
        copy.barButtons = barButtons
        return copy
    }
}
