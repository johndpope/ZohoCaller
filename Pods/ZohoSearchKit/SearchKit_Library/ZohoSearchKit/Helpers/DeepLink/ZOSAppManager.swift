//
//  ZOSAppManager.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 29/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

extension ZohoAppManager {
    
    //App scheme
    struct ZohoAppsSchemeConstants {
        static let ChatAppScheme = "zohochat"
        static let ChatIntentScheme = "zohocliq"
        static let ConnectAppScheme = "zohoconnect"
        static let MailAppScheme = "zohomail"
        static let DocsAppScheme = "zohoDocs"
        static let DeskAppScheme = "zohosupport"
        static let CRMAppScheme = "zohocrm"
        //Make sure for zoho people, it is people1
        static let PeopleAppScheme = "zohopeople1"
    }
    
    //App ID as published in Apple App Store. Must not change
    struct ZohoAppsIDConstants {
        static let ChatAppID = 1056478397
        static let ConnectAppID = 650742465
        static let DocsAppID = 388384804
        static let DeskAppID = 692742510
        static let CRMAppID = 444908810
        static let MailAppID = 909262651
        static let PeopleAppID = 680525956
    }
}

//Min version required installed? do we need to check that as well
//upgrade app?
class ZohoAppManager {
    static func getChatAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.ChatAppScheme)://app"
    }
    
    static func isCliqAppInstalled() -> Bool {
        let appUrl = URL(string: ZohoAppManager.getChatAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL) {
            return true
        }
        return false
    }
    
    //https://intranet.wiki.zoho.com/zohochat/URL-Schemes.html
    static func getChatIntentScheme() -> String  {
        //zohocliq://chat?{chatid}
        //zohocliq://channel?{channelid}
        //zohocliq://contact?{zuid}#{dname}
        //zohocliq://audio?{zuid}
        //zohocliq://video?{zuid}
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.ChatIntentScheme)://chat?"
    }
    
    static func getChatWithUserScheme() -> String {
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.ChatIntentScheme)://contact?"
    }
    
    static func getConnectAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.ConnectAppScheme)://app"
    }
    
    static func getDocsAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.DocsAppScheme)://app"
    }
    
    static func getMailAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.MailAppScheme)://app"
    }
    
    static func getCRMAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.CRMAppScheme)://app"
    }
    
    static func getDeskAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.DeskAppScheme)://app"
    }
    
    static func getPeopleAppScheme() -> String  {
        //zohochat://app
        return "\(ZohoAppManager.ZohoAppsSchemeConstants.PeopleAppScheme)://app"
    }
    
    //opens the app in App store for download
    static func openAppStoreForDownload(appID: Int) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/bars/id" + String(appID)),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }else{
            //move message to string resources
            //SnackbarUtils.showMessageWithDismiss(msg: "Can't open app store!")
        }
    }
}

