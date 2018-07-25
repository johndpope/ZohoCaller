//
//  UIView+GetParentViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 13/03/18.
//

import UIKit
import Foundation
//Swift 3
extension UIResponder {
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}
