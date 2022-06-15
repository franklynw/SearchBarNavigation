//
//  SwiftUIViewController.swift
//
//  Created by Franklyn Weber on 04/05/2022.
//

import SwiftUI


public struct NavigationConfig {
    
    public enum NavBarState {
        case hidden(backButtonTitle: String?, barButtons: BarButtons?)
        case shown(title: String?, backButtonTitle: String?, barButtons: BarButtons?)
    }
    
    let navBarState: NavBarState
    
    public init(navBarState: NavBarState = .shown(title: nil, backButtonTitle: nil, barButtons: nil)) {
        self.navBarState = navBarState
    }
    
    var navTitle: String? {
        switch navBarState {
        case .hidden:
            return nil
        case .shown(let title, _, _):
            return title
        }
    }
    
    var backButtonTitle: String? {
        switch navBarState {
        case .hidden(let title, _), .shown(_, let title, _):
            return title
        }
    }
    
    var hidesNavBar: Bool {
        switch navBarState {
        case .hidden:
            return true
        case .shown:
            return false
        }
    }
    
    var barButtons: BarButtons? {
        switch navBarState {
        case .hidden(_, let barButtons), .shown(_, _, let barButtons):
            return barButtons
        }
    }
}


class SwiftUIViewController<Content: View>: UIViewController, NavigationStyleProviding, NavigationConfiguring {
    
    var style: NavigationBarStyle? = .useParent
    var hasTranslucentBackground: Bool = false
    
    private var config: NavigationConfig?
    private var content: Content!
    
    
    //------------------------------------------------------------------------------
    // MARK: - Initialisation
    //------------------------------------------------------------------------------
    
    /// Initialises the Screen ViewController
    /// - Parameters:
    ///   - viewModel: ViewModel which describes how the view should operate
    ///   - config: a Config instance for configuring aspects of the viewController
    convenience init(config: NavigationConfig?, hasTranslucentNavBar: Bool, content: Content) {
        self.init(nibName: nil, bundle: nil)
        self.config = config
        self.content = content
        hasTranslucentBackground = hasTranslucentNavBar
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = config?.navTitle
        self.navigationItem.backButtonTitle = ""
        self.loadInto(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBarLeftButton()
        setupBarButtons()
    }
    
    
    private func loadInto(view: UIView) {
        
        let hostingController: UIHostingController = UIHostingController(rootView: content)
        self.addChild(hostingController)
        view.addViewConstrainedToSuperview(view: hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func setupBarButtons() {
        
        guard let barButtons = config?.barButtons else {
            return
        }
        
        setupBarButtons(barButtons, style: nil, for: self)
    }
    
    private func setNavBarLeftButton() {
        navigationItem.leftBarButtonItem = CustomBackButton(target: self, title: config?.backButtonTitle, selector: #selector(self.leftDoneButtonTapped))
    }
    
    @objc
    private func leftDoneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


fileprivate extension UIView {
    
    /// Options to be applied when constraining edges.
    struct EdgeConstraintOptions: OptionSet {

        let rawValue: Int

        @available(iOS 11, *)
        static let constrainTopEdgeToSafeAreaLayoutGuide: EdgeConstraintOptions = .init(rawValue: 1 << 0)
        @available(iOS 11, *)
        static let constrainBottomEdgeToSafeAreaLayoutGuide: EdgeConstraintOptions = .init(rawValue: 1 << 1)
        @available(iOS 11, *)
        static let constrainLeadingEdgeToSafeAreaLayoutGuide: EdgeConstraintOptions = .init(rawValue: 1 << 2)
        @available(iOS 11, *)
        static let constrainTrailingEdgeToSafeAreaLayoutGuide: EdgeConstraintOptions = .init(rawValue: 1 << 3)

        @available(iOS 11, *)
        static let constrainToSafeAreaLayoutGuide: EdgeConstraintOptions = [
            .constrainTopEdgeToSafeAreaLayoutGuide,
            .constrainBottomEdgeToSafeAreaLayoutGuide,
            .constrainLeadingEdgeToSafeAreaLayoutGuide,
            .constrainTrailingEdgeToSafeAreaLayoutGuide
        ]

        @available(iOS 11, *)
        static let constrainAllButBottomEdgeToSafeAreaLayoutGuide: EdgeConstraintOptions = [
            .constrainTopEdgeToSafeAreaLayoutGuide,
            .constrainLeadingEdgeToSafeAreaLayoutGuide,
            .constrainTrailingEdgeToSafeAreaLayoutGuide
        ]

        init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    func addViewConstrainedToSuperview(view: UIView) {
        self.addSubview(view)
        view.constrainEdgesToSuperview()
    }

    func constrainEdgesToSuperview(insets: UIEdgeInsets = .zero, options: EdgeConstraintOptions = []) {
        guard let superview: UIView = self.superview else {
            fatalError("No superview to attach constraints to.")
        }
        self.constrainEdgesToView(superview, insets: insets, options: options)
    }

    func constrainEdgesToView(_ view: UIView, insets: UIEdgeInsets = .zero, options: EdgeConstraintOptions = []) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11, *), options.contains(.constrainTopEdgeToSafeAreaLayoutGuide) {
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }

        if #available(iOS 11, *), options.contains(.constrainBottomEdgeToSafeAreaLayoutGuide) {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
        }

        if #available(iOS 11, *), options.contains(.constrainLeadingEdgeToSafeAreaLayoutGuide) {
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: insets.left).isActive = true
        } else {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        }

        if #available(iOS 11, *), options.contains(.constrainTrailingEdgeToSafeAreaLayoutGuide) {
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: insets.right).isActive = true
        } else {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = true
        }
    }
}


fileprivate class CustomBackButton: UIBarButtonItem {

    convenience init(target: Any, title: String?, selector: Selector) {

        let button = UIButton(frame: .zero)

        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(.label, for: UIControl.State())
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)

        let config = UIImage.SymbolConfiguration(textStyle: .subheadline, scale: .large)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: UIControl.State())

        button.addTarget(target, action: selector, for: .touchUpInside)

        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -18.0, bottom: 0.0, right: 0.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -12.0, bottom: 0.0, right: 0.0)

        self.init(customView: button)
    }
}
