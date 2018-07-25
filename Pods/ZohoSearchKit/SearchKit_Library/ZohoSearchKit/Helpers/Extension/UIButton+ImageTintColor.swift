//
//  UIButton+ImageTintColor.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/06/18.
//

import Foundation

extension UIButton
{
    func setImageTintColor(title : String? = nil,image : UIImage? = nil ,imageName : String?,tintColor  : UIColor,for controlState : UIControlState)
    {
        if title != nil
        {
            self.setTitle(title, for: controlState)
        }
        if image != nil
        {
            self.setImage(image, for: controlState)
        }
        if imageName != nil
        {
             self.setImage(UIImage(named: imageName!, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil), for: controlState)
        }
        self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
    }
}
