//
//  UITableView+Scroll.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 20/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension UITableView {
    func scrollToTop(animated: Bool) {
        self.setContentOffset(CGPoint.zero, animated: animated);
    }
}

//TODO: similarly add extention to scroll to bottom
