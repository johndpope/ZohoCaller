//
//  IntentActionHandler.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 21/02/18.
//

import Foundation

class IntentActionHandler {
    
    //send new mail action handler
    static func sendNewMail(emailID: String) {
        //guard for empty email address
        guard emailID.isEmpty == false else {
            print("Email address can't be empty")
            return
        }
        
        if let sendMailIntentURL = URL(string: "mailto://" + emailID) {
            if UIApplication.shared.canOpenURL(sendMailIntentURL) {
                UIApplication.shared.openURL(sendMailIntentURL)
            }
            else {
                SnackbarUtils.showMessageWithDismiss(msg: "Unable to process your request!")
            }
        }
        else {
            SnackbarUtils.showMessageWithDismiss(msg: "Unable to process your request!")
        }
    }
    
    //make a phone call action handler
    static func makePhoneCall(phoneNumber: String) {
        //guard for empty phone number
        guard phoneNumber.isEmpty == false else {
            print("Phone number can't be empty")
            return
        }
        
        //alternatively //tel:// can also be used
        if let makePhoneCallIntentURL = URL(string: "telprompt:\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(makePhoneCallIntentURL) {
                UIApplication.shared.openURL(makePhoneCallIntentURL)
            }
            else {
                SnackbarUtils.showMessageWithDismiss(msg: "Unable to process your request!")
            }
        }
        else {
            SnackbarUtils.showMessageWithDismiss(msg: "Unable to process your request!")
        }
    }
}
