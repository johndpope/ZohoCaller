//
//  OpenServiceWithNativeApp.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/06/18.
//

import Foundation
import UIKit
class OpenServiceWithNativeApp {
    public class func sharedInstance() -> OpenServiceWithNativeApp {
        struct Singleton {
            static var sharedInstance = OpenServiceWithNativeApp()
        }
        return Singleton.sharedInstance
    }
    // Should Set the service name before calling this function
    var selectedResultCellServiceName : String = String()
    
    var selectedServiceResult : SearchResult?
    func MakePhoneCall(to phoneNumber : String)
    {
        IntentActionHandler.makePhoneCall(phoneNumber: phoneNumber)
    }
    
    func SendMail(to email : String)
    {
        IntentActionHandler.sendNewMail(emailID: email)
    }
    
    func ChatWithCliqApp(userZUID : Int,userDisplayName : String)
    {
        ZohoAppsDeepLinkUtil.chatUsingCliq(zuid: userZUID, displayName: userDisplayName)
    }
    @objc func didPressMoreActionsOption(_ sender : Any ,currentViewcontroller : UIViewController )
    {
        //Alert view
        //TODO: get More Options messages form I18N files. All other ui messages as well
        //no message is needed, only title is needed
        let moreOptionsAlert = UIAlertController(title: "More Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //        var item = SearchResultsViewModel.serviceSections[selectedResultCellServiceName]
        
        //        let selectedResult = item?.searchResults[indexPath.row]
        
        switch selectedResultCellServiceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            let cliqResult = selectedServiceResult as! ChatResult
            
            //Call the Cliq DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Cliq App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInChatApp(chatID: (cliqResult.chatID))
            }))
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            let contactResult = selectedServiceResult as! ContactsResult
            
            //Contacts call out
            if let email = contactResult.emailAddress, !email.isEmpty {
                moreOptionsAlert.addAction(UIAlertAction(title: "Send Mail", style: .destructive, handler: { (action: UIAlertAction!) in
                    OpenServiceWithNativeApp.sharedInstance().SendMail(to: email)
                }))
            }
            if let mobile = contactResult.mobileNumber, !mobile.isEmpty {
                moreOptionsAlert.addAction(UIAlertAction(title: "Make Phone Call", style: .destructive, handler: { (action: UIAlertAction!) in
                    
                    OpenServiceWithNativeApp.sharedInstance().MakePhoneCall(to: mobile)
                }))
            }
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            let peopleResult = selectedServiceResult as! PeopleResult
            //Call the People DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with People App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInPeopleApp(emailID: (peopleResult.email)!)
            }))
            if let email = peopleResult.email, !email.isEmpty {
                moreOptionsAlert.addAction(UIAlertAction(title: "Send Mail", style: .destructive, handler: { (action: UIAlertAction!) in
                    OpenServiceWithNativeApp.sharedInstance().SendMail(to: email)
                }))
            }
            if let mobile = peopleResult.mobile, !mobile.isEmpty {
                moreOptionsAlert.addAction(UIAlertAction(title: "Make Phone Call", style: .destructive, handler: { (action: UIAlertAction!) in
                    
                    OpenServiceWithNativeApp.sharedInstance().MakePhoneCall(to: mobile)
                }))
            }
            if let cliq = peopleResult.zuid, cliq != -1 {
                moreOptionsAlert.addAction(UIAlertAction(title: "Chat With Cliq", style: .destructive, handler: { (action: UIAlertAction!) in
                    ZohoAppsDeepLinkUtil.chatUsingCliq(zuid: cliq, displayName: ((peopleResult.firstName ?? "") + " " + (peopleResult.lastName ?? "")))
                }))
            }
            
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            let mailResult = selectedServiceResult as! MailResult
            //Call the Mail DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Mail App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInMailApp(messageID: Int(mailResult.messageID))
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            let connectResult = selectedServiceResult as! ConnectResult
            
            //Call the Connect DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Connect App", style: .destructive, handler: { (action: UIAlertAction!) in
                //var connectFeedUrl = connectResult.postURL
                //connectFeedUrl = connectFeedUrl.replacingOccurrences(of: "https://", with: "", options: .literal, range: nil)
                //ZohoAppsDeepLinkUtil.openInConnectAppWithURL(connectUrl: connectFeedUrl)
                ZohoAppsDeepLinkUtil.openInConnectApp(type: (connectResult.type)!, entityID: connectResult.postID, scopeID: 105000017039001)
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            let docsResult = selectedServiceResult as! DocsResult
            //Call the Docs DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Docs App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInDocsApp(docsFileID: (docsResult.docID))
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            let crmResult = selectedServiceResult as! CRMResult
            //Call the CRM DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with CRM", style: .destructive, handler: { (action: UIAlertAction!) in
                //Only Leads and Contacts module is supported right now
                if (crmResult.moduleName == "Leads" || crmResult.moduleName == "Contacts") {
                    ZohoAppsDeepLinkUtil.openInCRMApp(moduleName: (crmResult.moduleName), recordID: (crmResult.entID), zuid: TableViewController.currentUserZUID)
                }
                else {
                    SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
                }
            }))
            
            
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            //Call the Desk DeepLinking handler if needed
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Desk App", style: .destructive, handler: { (action: UIAlertAction!) in
                let deskResult = self.selectedServiceResult as? SupportResult
                
                if (deskResult?.moduleID == 1 || deskResult?.moduleID == 2 ) {
                    if deskResult?.moduleID == 2
                    {
                        SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
                        return
                    }
                    ZohoAppsDeepLinkUtil.openInDeskApp(moduleName: (deskResult?.getModuleName())!, entityID: (deskResult?.entID)!, portalID: (deskResult?.orgID)!)
                }
                else {
                    SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "contacts and accounts module are not supported!"))
                }
            }))
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            let wikiResult = selectedServiceResult as! WikiResult
            
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Wiki App", style: .destructive, handler: { (action: UIAlertAction!) in
                SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "wiki app  not available!"))
            }))
            
        default:
            //TODO: Use SearchKitLogger for logging
            fatalError("Given service call out option is not supported yet!")
        }
        
        moreOptionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //no closure for cancel
        }))
        //        moreOptionsAlert.accessibilityNavigationStyle = .separate
        //MARK:- for ipad this should be added for alertview Controller
        moreOptionsAlert.modalPresentationStyle = .popover
        let popoverPresentationController: UIPopoverPresentationController? = moreOptionsAlert.popoverPresentationController
        popoverPresentationController?.sourceView = sender as? UIView
        popoverPresentationController?.sourceRect = (sender as! UIView).bounds
        currentViewcontroller.present(moreOptionsAlert, animated: true, completion: nil)
    }
}
