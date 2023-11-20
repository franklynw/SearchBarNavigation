//
//  ControlledPopNavigationController.swift
//  
//
//  Created by Franklyn Weber on 30/05/2022.
//

import UIKit


protocol ControlledPopDelegate: AnyObject {
    var shouldPop: ((@escaping (Bool) -> ()) -> ())? { get }
    var hasChanges: Bool { get }
    func navigationController(_ navigationController: UINavigationController, shouldPop viewController: UIViewController?, pop: (() -> ())?) -> Bool
}


public class ControlledPopNavigationController: UINavigationController, UINavigationBarDelegate {
    
    weak var popDelegate: ControlledPopDelegate?
    
    private let navBarTapped: (() -> ())?
    private var hasSwiped = false
    
    
    required init?(coder aDecoder: NSCoder) {
        navBarTapped = nil
        super.init(coder: aDecoder)
    }
    
    public init(rootViewController: UIViewController, navBarTapped: (() -> ())? = nil) {
        self.navBarTapped = navBarTapped
        super.init(rootViewController: rootViewController)
        interactivePopGestureRecognizer?.delegate = self // this is the gesture recognizer which deals with the screen-edge swipes used for popping
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(swipeEnded))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        navigationBar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let popDelegate = self.popDelegate, !hasSwiped else { return nil }
        
        if popDelegate.navigationController(self, shouldPop: self.viewControllers.last, pop: {
            super.popViewController(animated: animated)
        }) == false {
            return nil
        }
        
        return super.popViewController(animated: animated)
    }
    
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let popDelegate = self.popDelegate, !hasSwiped else { return nil }
        
        if popDelegate.navigationController(self, shouldPop: self.viewControllers.last, pop: {
            super.popToViewController(viewController, animated: animated)
        }) == false {
            return nil
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let popDelegate = self.popDelegate, !hasSwiped else { return nil }
        
        if popDelegate.navigationController(self, shouldPop: self.viewControllers.last, pop: {
            super.popToRootViewController(animated: animated)
        }) == false {
            return nil
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if item == self.viewControllers.last?.navigationItem {
            let _ = self.popViewController(animated: true)
            return false
        }
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        hasSwiped = false
    }
    
    @objc
    private func tapped() {
        navBarTapped?()
    }
}


extension ControlledPopNavigationController: UIGestureRecognizerDelegate {
    
    /*
     We intercept the screen-edge swipe gesture & check that it's ok to pop
     If it is, we call 'pop' ourselves so the user's swipe gesture works
     */
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === interactivePopGestureRecognizer else {
            return true
        }
        guard popDelegate?.hasChanges == true else {
            return true
        }
        hasSwiped = true
        
        popDelegate?.shouldPop? { [unowned self] pop in
            self.hasSwiped = false
            if pop {
                _ = self.popViewController(animated: true)
            }
        }
        
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @objc
    private func swipeEnded(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended, .cancelled, .failed:
            hasSwiped = false
        default:
            break
        }
    }
}
