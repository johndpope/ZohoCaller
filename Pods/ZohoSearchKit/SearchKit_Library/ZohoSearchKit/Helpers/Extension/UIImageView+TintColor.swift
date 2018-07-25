//
//  UIImage+TintColor.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/06/18.
//

import UIKit

extension UIImageView
{
    func changeTintColor(_ color  : UIColor)
    {
        self.image =   self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
