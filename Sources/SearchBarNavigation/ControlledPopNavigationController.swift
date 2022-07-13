//
//  ControlledPopNavigationController.swift
//  
//
//  Created by Franklyn Weber on 30/05/2022.
//

import UIKit


protocol ControlledPopDelegate: AnyObject {
    func navigationController(_ navigationController: UINavigationController, shouldPop viewController: UIViewController?, pop: (() -> ())?) -> Bool
}


public class ControlledPopNavigationController: UINavigationController, UINavigationBarDelegate {

    weak var popDelegate: ControlledPopDelegate?
    
    private let navBarTapped: (() -> ())?
    
    
    required init?(coder aDecoder: NSCoder) {
        navBarTapped = nil
        super.init(coder: aDecoder)
    }
    
    public init(rootViewController: UIViewController, navBarTapped: (() -> ())? = nil) {
        self.navBarTapped = navBarTapped
        super.init(rootViewController: rootViewController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        navigationBar.addGestureRecognizer(tapGestureRecognizer)
        navigationBar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let popDelegate = self.popDelegate else { return nil }
        
        if popDelegate.navigationController(self, shouldPop: self.viewControllers.last, pop: {
            super.popViewController(animated: animated)
        }) == false {
            return nil
        }
        
        return super.popViewController(animated: animated)
    }
    
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let popDelegate = self.popDelegate else { return nil }
        
        if popDelegate.navigationController(self, shouldPop: self.viewControllers.last, pop: {
            super.popToViewController(viewController, animated: animated)
        }) == false {
            return nil
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let popDelegate = self.popDelegate else { return nil }
        
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
    
    @objc
    private func tapped() {
        navBarTapped?()
    }
}
