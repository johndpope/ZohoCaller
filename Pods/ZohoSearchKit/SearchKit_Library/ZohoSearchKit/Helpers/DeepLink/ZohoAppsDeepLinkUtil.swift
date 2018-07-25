//
//  ZohoAppsDeepLinkUtil.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 12/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class ZohoAppsDeepLinkUtil {
    
    //for now some duplicate codes, later we will handle
    static func openInChatApp(chatID: String) {
        let appUrl = URL(string: ZohoAppManager.getChatAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let chatURL = URL(string: "\(ZohoAppManager.getChatIntentScheme())\(chatID)")
            //open is available only after iOS 10.
            //UIApplication.shared.open(chatURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(chatURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            //move messages to string resources
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.ChatAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    static func chatUsingCliq(zuid: Int, displayName: String) {
        // zohocliq://contact?{zuid}#{dname} -> dname is not optional
        //this will be problem while dispalying the name in chat app.
        //so better send the first word in case of multi word name separated by white space.
        //let encodedDisplayName = displayName.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        let nameParts = displayName.components(separatedBy: " ")
        let chatWithUserURL = URL(string: "\(ZohoAppManager.getChatWithUserScheme())\(zuid)#\(nameParts[0])")
        if let chatURL = chatWithUserURL {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(chatURL)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            SnackbarUtils.showMessageWithDismiss(msg: "Couldn't chat with the user!")
        }
    }
    
    static func openInMailApp(messageID: Int) {
        let appUrl = URL(string: ZohoAppManager.getMailAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
        }
        else {
            //move messages to string resources
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.MailAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Mail), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    //using url
    static func openInConnectAppWithURL(connectUrl: String) {
        let appUrl = URL(string: ZohoAppManager.getConnectAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let feedURL = URL(string: "zohoconnect://\(connectUrl)")
            //UIApplication.shared.open(feedURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(feedURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.ConnectAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Connect), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    //using custom scheme
    static func openInConnectApp(type: ConnectResult.ResultType, entityID: Int64, scopeID: Int64) {
        let appUrl = URL(string: ZohoAppManager.getConnectAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let feedURL = URL(string: "zohoconnect://\(type.rawValue)/\(entityID)/\(scopeID)")
            //UIApplication.shared.open(feedURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(feedURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.ConnectAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Connect), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    static func openInPeopleApp(emailID: String) {
        let appUrl = URL(string: ZohoAppManager.getPeopleAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let employeeDetailsURL = URL(string: "zohopeople1://user/details?email=\(emailID)")
            //UIApplication.shared.open(employeeDetailsURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(employeeDetailsURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.PeopleAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.People), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    //HTTP Url based intent support
    static func openInDocsApp(docsFileID: String) {
        let appUrl = URL(string: ZohoAppManager.getDocsAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            //let documentURL = URL(string: "https://docs.zoho.com/file/\(docsFileID)")
            
            let transformedURL = ZohoSearchKit.sharedInstance().getTransformedURL((ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.docsServerHost)!)
            let documentURL = URL(string: "\(transformedURL)\(ZOSSearchAPIClient.DocsResourceAPI.ApiPath)/\(docsFileID)")
            //UIApplication.shared.open(feedURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(documentURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.DocsAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Documents), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    //as if now two modules are supported - tickets and contacts
    //zohosupport://tickets?entity=196749000000099001&portalId=6485053035
    //zohosupport://contacts?entity=196749000000099001&portalId=6485053035
    static func openInDeskApp(moduleName: String, entityID: Int64, portalID: Int64) {
        let appUrl = URL(string: ZohoAppManager.getDeskAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let entityURL = URL(string: "zohosupport://\(moduleName)?entity=\(entityID)&portalId=\(portalID)")
            //UIApplication.shared.open(entityURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(entityURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.DeskAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Desk), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    //zohocrm://?module=Leads&record_id=799079000000143011&zuid=23408090&operation=view
    static func openInCRMApp(moduleName: String, recordID: Int, zuid: String) {
        let appUrl = URL(string: ZohoAppManager.getCRMAppScheme())
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            let entityURL = URL(string: "zohocrm://?module=\(moduleName)&record_id=\(recordID)&zuid=\(zuid)&operation=view")
            //UIApplication.shared.open(entityURL!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(entityURL!)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            let actionHandler = {() in
                ZohoAppManager.openAppStoreForDownload(appID: ZohoAppManager.ZohoAppsIDConstants.CRMAppID)
            }
            SnackbarUtils.showMessageWithAction(msg: generateNotInstalledMessage(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Crm), actionButtonTitle: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.installbutton", defaultValue: "INSTALL"), actionHandler: actionHandler)
        }
    }
    
    static func generateNotInstalledMessage(serviceName: String) -> String {
        var serviceNameMsg = ""
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.cliq", defaultValue: "Cliq")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.mail", defaultValue: "Mail")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.connect", defaultValue: "Connect")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.contacts", defaultValue: "Contacts")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.people", defaultValue: "People")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.docs", defaultValue: "Docs")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.desk", defaultValue: "Desk")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.crm", defaultValue: "CRM")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            serviceNameMsg = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.wiki", defaultValue: "Wiki")
            break
        default:
            serviceNameMsg = ""
        }
        
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.zoho", defaultValue: "Zoho") + " " + serviceNameMsg + " " + SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.appnotinstalled", defaultValue: "app is not installed!")
    }
}

