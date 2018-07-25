//
//  PaddingLabel.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 24/04/18.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 3.0
    @IBInspectable var bottomInset: CGFloat = 3.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat){
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        let insets: UIEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.drawText(in: UIEdgeInsetsInsetRect(self.frame, insets))
    }
}
