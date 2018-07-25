//
//  UIColor+Hex.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//Extension to convert hexadecimal color representation to UIColor
//Usage-
//let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
//let anotherColor = UIColor(rgb: 0xFFFFFF)
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    //above is used right now, alternatively we can use this to translate hexadecimal representation of color to UI
    //usage - UIColor.hexStringToUIColor(hex: "#f9f9f9")
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func uiColorToHexString(from color: UIColor) -> String {
        let colorSpace: CGColorSpaceModel = (color.cgColor.colorSpace?.model)!
        let components = color.cgColor.components
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        //var a: CGFloat = 0
        if colorSpace == .monochrome {
            r = components![0]
            g = components![0]
            b = components![0]
            //a = components![1]
        }
        else if colorSpace == .rgb {
            r = components![0]
            g = components![1]
            b = components![2]
            //a = components![3]
        }
        
        //return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)), lroundf(Float(a * 255)))
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}
