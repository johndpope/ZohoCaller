//
//  UIViewController+Show_Hide_ChildViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 20/04/18.
//

import Foundation
import UIKit
extension UIViewController{
    // adding child view
    func add(childViewController: UIViewController) {
        childViewController.beginAppearanceTransition(false, animated: true)
        addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
        childViewController.endAppearanceTransition()
    }
    // removing childview
    func remove(childViewController: UIViewController) {
        childViewController.beginAppearanceTransition(false, animated: true)
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
        childViewController.endAppearanceTransition()
    }
}

