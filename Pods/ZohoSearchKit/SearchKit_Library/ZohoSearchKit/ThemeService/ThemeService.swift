//
//  ThemeService.swift
//  SearchApp
//
//  Created by manikandan bangaru on 06/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit
//public protocol Themeable: class {
//    func applyTheme(theme: Theme)
//}
extension ThemeService{
    public struct DarkTheme: Theme {
     public var extraLargeHeadLineFont: UIFont { return UIFont.boldSystemFont(ofSize: 23) }
        
        public var extraLargeHeadLineColor: UIColor { return UIColor.black }
        
        public var isLightStatusbarStyle: Bool { return true}
        public var navigationTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0)
        public var headlineFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0)
        public var navigationBarBackGroundColor : UIColor =  {return UIColor.black}()
        public var bodyTextFont: UIFont = UIFont.systemFont(ofSize: 17.0)
        public var backgroundColor: UIColor = UIColor(rgb: 0x303030)
        public var tintColor: UIColor = UIColor(rgb: 0xFFCF00)
        public var navigationBarTintColor: UIColor? = UIColor(rgb: 0x404040)
        public var navigationBarTranslucent: Bool = false
        
        public var navigationTitleColor: UIColor = UIColor.white
        public var headlineColor: UIColor { return UIColor.white }
        public var bodyTextColor: UIColor { return UIColor.white }
    }
    public struct NormalTheme: Theme {
        public var extraLargeHeadLineFont: UIFont {
            return UIFont.boldSystemFont(ofSize: 23) }
        
        public var extraLargeHeadLineColor: UIColor { return UIColor.black }
        
        public var isLightStatusbarStyle: Bool  { return true }
        public var backgroundColor: UIColor { return UIColor(rgb: 0xffffff)}
        public var tintColor: UIColor { return UIColor(rgb: 0x007aff)}
        public var navigationBarTintColor: UIColor? { return UIColor.white }
        public var navigationBarTranslucent: Bool { return true }
        public var navigationBarBackGroundColor : UIColor = { return UIColor(rgb: 0x5DA5F8)}()
        public var navigationTitleFont: UIFont { return UIFont.boldSystemFont(ofSize: 20.0) }
        public var navigationTitleColor: UIColor { return UIColor.white }
        
        public var headlineFont: UIFont { return UIFont.systemFont(ofSize: 20.0) }
        public var headlineColor: UIColor { return UIColor.black }
        
        public var bodyTextFont: UIFont { return UIFont.systemFont(ofSize: 17.0)  }
        public var bodyTextColor: UIColor { return UIColor.darkGray }
    }
    public struct CustomTheme: Theme {
        public var extraLargeHeadLineFont: UIFont { return UIFont.boldSystemFont(ofSize: 23) }
        
        public var extraLargeHeadLineColor: UIColor { return UIColor.black }
        
        public var isLightStatusbarStyle: Bool { return true}
        public var backgroundColor: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        public var tintColor: UIColor { return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)}
        public var navigationBarTintColor: UIColor? { return UIColor(rgb: 0x5DA5F8) }
        public var navigationBarTranslucent: Bool { return false }
        public var navigationBarBackGroundColor : UIColor = {return UIColor(rgb: 0x5DA5F8)}()
        public var navigationTitleFont: UIFont { return UIFont.boldSystemFont(ofSize: 20.0) }
        public var navigationTitleColor: UIColor { return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) }
        
        public var headlineFont: UIFont { return UIFont.boldSystemFont(ofSize: 20.0)  }
        public var headlineColor: UIColor {  return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) }
        
        public var bodyTextFont: UIFont { return UIFont.systemFont(ofSize: 17.0)  }
        public var bodyTextColor: UIColor {  return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) }
    }
}
public class ThemeService {
    static var instanceCount = 0
    //Singletone instance
    public class func sharedInstance() -> ThemeService {
        struct Singleton {
            static var sharedInstance = ThemeService()
        }
        return Singleton.sharedInstance
    }
    public var theme: Theme = NormalTheme() {
        didSet {
            applyTheme()
        }
    }
    
    public func applyTheme() {
        // Update styles via UIAppearance
        UINavigationBar.appearance().isTranslucent = theme.navigationBarTranslucent
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackGroundColor
        UINavigationBar.appearance().backgroundColor = theme.navigationBarBackGroundColor
        UINavigationBar.appearance().tintColor = theme.navigationBarTintColor
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: theme.navigationTitleColor,
            NSAttributedStringKey.font: theme.navigationTitleFont
            ] as [NSAttributedStringKey : Any]
        //Switch background color
        UISwitch.appearance().tintColor = theme.navigationBarBackGroundColor
        
        // The tintColor will trickle down to each view
        UITabBar.appearance().tintColor = theme.navigationBarBackGroundColor
        //        UITabBar.appearance().backgroundColor = theme.navigationBarTintColor
        if let window = UIApplication.shared.windows.first {
            window.tintColor = theme.navigationBarBackGroundColor
        }
        // TO Change Statusbar color
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = theme.navigationBarBackGroundColor
        UIApplication.shared.statusBarStyle = .lightContent
        
        //        UINavigationController.navigationBar.barStyle = UIBarStyle.black
        
    }
    public  func applyBackgroundColor(views: [UIView]) {
        views.forEach {
            $0.backgroundColor = theme.backgroundColor
        }
    }
    
    public func applyHeadlineStyle(labels: [UILabel]) {
        labels.forEach {
            $0.font = theme.headlineFont
            $0.textColor = theme.headlineColor
        }
    }
    
    public func applyBodyTextStyle(labels: [UILabel]) {
        labels.forEach {
            $0.font = theme.bodyTextFont
            $0.textColor = theme.bodyTextColor
        }
    }
}
//    public var listeners = NSHashTable<AnyObject>.weakObjects()

//
//    public func addThemeable(themable: Themeable, applyImmediately: Bool = true) {
//        guard !listeners.contains(themable) else { return }
////        listeners.add(themable)
//
////        if applyImmediately {
////            themable.applyTheme(theme: theme)
////        }
//    }
//    public func removeAllReference()
//    {
//        listeners.removeAllObjects()
//    }
// Update each listener. The type cast is needed because allObjects returns [AnyObject]
//         listeners.allObjects
//            .flatMap { $0 as? Themeable }
//            .forEach { $0.applyTheme(theme: theme) }
//implementation
//class MyViewController: UIViewController,Theame {
//
//    @IBOutlet private var headerLabel: UILabel!
//    @IBOutlet private var bodyTextLabel1: UILabel!
//    @IBOutlet private var bodyTextLabel2: UILabel!
//
//    func viewDidLoad() {
//        super.viewDidLoad()
//
//        ThemeService.shared.addThemable(self)
//    }
//
//    // MARK: - Themable
//
//    func applyTheme(theme: Theme) {
//        theme.applyBackgroundColor([view, collectionView])
//        theme.applyHeadlineStyle([headerLabel])
//        theme.applyBodyTextStyle([bodyTextLabel1, bodyTextLabel2])
//    }
//
//}
//To change the theme, just pass a new theme to the Theme service:
//
//ThemeService.shared.theme = DarkTheme()
