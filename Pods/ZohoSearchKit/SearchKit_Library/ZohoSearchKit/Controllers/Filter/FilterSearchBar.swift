//
//  FilterSearchBar.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 15/03/18.
//

import Foundation
import UIKit

class FilterSearchBar : UITextField
{
    var section :Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        clearButtonMode = .always
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ClearImage()
    }
    private func ClearImage() {
        for view in subviews  {
            if view is UIButton {
                let button = view as! UIButton
                clearButtonMode = .always
                let img:UIImage = UIImage(named: "searchsdk-close" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                //normal image
                button.setImage(img, for: .normal)
                button.backgroundColor = SearchKitConstants.ColorConstants.Clear_Button_BGColor
                button.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
                button.layer.cornerRadius = (button.frame.width / 2)
            }
        }
        
        
    }
    
}
