//
//  SnackbarUtil.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 29/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialSnackbar

//Global status message and button color. Should be confiugarable
let DismissButtonColor = SearchKitConstants.ColorConstants.SnackbarActionButtonColor
let InfoButtonColor = SearchKitConstants.ColorConstants.SnackbarActionButtonColor
let ErrorButtonColor = UIColor.red

/// Helper class to display Snackbar messages
class SnackbarUtils {

    //Show the given message as Snackbar
    static func showMessage(msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
    
    //Show the given message with dismiss button
    static func showMessageWithDismiss(msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        
        let action = MDCSnackbarMessageAction()
        //get from string resources
        action.title = "DISMISS"
        message.action = action
        /*
        var dismissColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList["dismiss"]
        if (dismissColorCode == nil) {
            print(ZohoSearchKit.sharedInstance().frameworkConfigPropertyList)
            dismissColorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList["dismiss"] as! NSString
        }
        message.buttonTextColor = UIColor.hexStringToUIColor(hex: dismissColorCode as! String) //DismissButtonColor
        */
        message.buttonTextColor = ZohoSearchKit.sharedInstance().searchKitConfig?.getSnackbarActionButtonColor()
        //No action handler is needed as if nil it will dismiss the snackbar anyway
        
        MDCSnackbarManager.show(message)
    }
    
    //Show the given message and also assign the action handler which will called post click
    static func showMessageWithAction(msg: String, actionButtonTitle: String, actionHandler: @escaping MDCSnackbarMessageActionHandler) {
        let message = MDCSnackbarMessage()
        message.text = msg
        let action = MDCSnackbarMessageAction()
        action.handler = actionHandler
        action.title = actionButtonTitle
        message.action = action
        message.buttonTextColor = InfoButtonColor
        MDCSnackbarManager.show(message)
    }

}
