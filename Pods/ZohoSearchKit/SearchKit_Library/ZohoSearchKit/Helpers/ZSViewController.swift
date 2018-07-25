//
//  DesignableViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 09/07/18.
//

import UIKit
@IBDesignable
open class ZSViewController: UIViewController {

    @IBInspectable open let isLightStatusBar: Bool = {
    return ThemeService.sharedInstance().theme.isLightStatusbarStyle
    }()
    
    //MARK:- following code will work only for view controller without navigationbar
    override  open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if isLightStatusBar {
                return UIStatusBarStyle.lightContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- Folowing code Works only for view controller with navigationbar
        if let _ = navigationController
        {
            if self.isLightStatusBar {
                navigationController?.navigationBar.barStyle = UIBarStyle.black
            } else {
                navigationController?.navigationBar.barStyle = UIBarStyle.default
            }
        }
    }
}
