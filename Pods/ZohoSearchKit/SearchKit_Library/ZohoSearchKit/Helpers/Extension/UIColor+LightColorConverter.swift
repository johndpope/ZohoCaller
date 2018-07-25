//
//  UIColor+LightColorConverter.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 10/07/18.
//

import Foundation
import UIKit
extension UIColor {
    
    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.55, resultAlpha: -1)
    }
    
    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha:  alpha == -1 ? a : alpha)
    }
}
