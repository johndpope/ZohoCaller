//
//  UINavigationController+PushWithCompletion.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
