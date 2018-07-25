//
//  UILabel+CircularView.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension UILabel {
    
    func createCircularView() {
        self.backgroundColor = SearchKitConstants.ColorConstants.ResultImageBackgroundColor
        self.layer.borderColor = SearchKitConstants.ColorConstants.ResultImageBorderColor.cgColor
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
