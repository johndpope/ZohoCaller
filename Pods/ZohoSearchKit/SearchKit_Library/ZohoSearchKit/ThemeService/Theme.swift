//
//  Theme.swift
//  SearchApp
//
//  Created by manikandan bangaru on 06/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit
public protocol Theme {
    var isLightStatusbarStyle : Bool {get}//status bar text color
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var navigationBarTintColor: UIColor? { get }
    var navigationBarTranslucent: Bool { get }
    var navigationBarBackGroundColor : UIColor {get set}
    var navigationTitleFont: UIFont { get  }
    var navigationTitleColor: UIColor { get }
    
    var extraLargeHeadLineFont: UIFont { get }
    var extraLargeHeadLineColor: UIColor { get }
    
    var headlineFont: UIFont { get }
    var headlineColor: UIColor { get }
    
    var bodyTextFont: UIFont { get }
    var bodyTextColor: UIColor { get }

}
extension Theme {
    public var isLightStatusbarStyle: Bool  { return true }
    public var backgroundColor: UIColor { return UIColor(rgb: 0xffffff)}
    public var tintColor: UIColor { return UIColor(rgb: 0x007aff)}
    public var navigationBarTintColor: UIColor? { return nil }
    public var navigationBarTranslucent: Bool { return true }
    public var navigationBarBackGroundColor : UIColor {return UIColor(rgb: 0x5DA5F8)}
    public var navigationTitleFont: UIFont { return UIFont.boldSystemFont(ofSize: 17.0) }
    public var navigationTitleColor: UIColor { return UIColor.black }
    
    public var headlineFont: UIFont { return UIFont.boldSystemFont(ofSize: 17.0)  }
    public var headlineColor: UIColor { return UIColor.black }
    
    public var bodyTextFont: UIFont { return UIFont.systemFont(ofSize: 17.0)  }
    public var bodyTextColor: UIColor { return UIColor.darkGray }
    
    public func applyBackgroundColor(views: [UIView]) {
        views.forEach {
            $0.backgroundColor = backgroundColor
        }
    }
    
    public func applyHeadlineStyle(labels: [UILabel]) {
        labels.forEach {
            $0.font = headlineFont
            $0.textColor = headlineColor
        }
    }
    
    public func applyBodyTextStyle(labels: [UILabel]) {
        labels.forEach {
            $0.font = bodyTextFont
            $0.textColor = bodyTextColor
        }
    }
    
}
