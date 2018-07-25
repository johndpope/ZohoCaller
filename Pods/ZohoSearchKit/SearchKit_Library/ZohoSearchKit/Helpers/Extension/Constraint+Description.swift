//
//  Constraint+Description.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 13/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    override open var description: String {
        let id = identifier ?? ""
        return "Constraint id: \(id), Constant value: \(constant)"
    }
}
