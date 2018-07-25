//
//  CoreDataQueryUtil.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/04/18.
//

import Foundation
import CoreData

class CoreDataQueryUtil {
    typealias CoreDataResponseHandler = (_ coreDataResponse: AnyObject?, _ error: NSError?) -> Void
    
    static func fetchDeskModulesForPortal(portalID: Int64, completionHandlerForCoreData: @escaping CoreDataResponseHandler) {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.DeskModulesTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(DeskModules.portal_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, portalID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [DeskModules]
            if let fetchedResults = result, fetchedResults.count == 0 {
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getDeskModules(oAuthToken: oAuthToken, portalID: portalID) { (serviceWidgetData, error) in
                            if let serviceWidgetData = serviceWidgetData as? [String: AnyObject] {
                                //1 = request, 2 = kb or solutions, 3 = contacts and 4 = accounts
                                let supportedModules:[String] = ["1", "2", "3", "4"] //these should be configurable and no code change should be required to support new module
                                var deskModules = [DeskModules]()
                                for (moduleID, moduleName) in serviceWidgetData {
                                    if !(supportedModules.contains(moduleID)) {
                                        continue
                                    }
                                    let deskModule = DeskModules(moduleID: Int16(moduleID)!, moduleName: moduleName as! String, portalID: portalID, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
                                    deskModules.append(deskModule)
                                }
                                
                                completionHandlerForCoreData(deskModules as AnyObject, nil)
                                
                                //save core data
                                do {
                                    try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
                                } catch {
                                    fatalError("Error while saving data")
                                }
                            }
                            else {
                                //invoke completion with Error
                                completionHandlerForCoreData(nil, NSError())
                            }
                        }
                    }
                    else {
                        //invoke completion with Error
                        completionHandlerForCoreData(nil, NSError())
                    }
                })
            }
            else {
                completionHandlerForCoreData(result as AnyObject, nil)
            }
        } catch {
            let fetchError = error as NSError
            completionHandlerForCoreData(nil, fetchError)
        }
    }
    
    static func fetchMailFoldersForAccount(mailAccountID: Int64, emailID: String, completionHandlerForCoreData: @escaping CoreDataResponseHandler) {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsFolderTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntFolders.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntFolders]
            if let fetchedResults = result, fetchedResults.count == 0 {
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getMailFolders(oAuthToken: oAuthToken, emailID: emailID) { (serviceWidgetData, error) in
                            if let serviceWidgetData = serviceWidgetData as? [String] {
                                var mailFolders = [MailAcntFolders]()
                                for folder in serviceWidgetData {
                                    //"1808426000000008013,Inbox/",
                                    let folderIDAndName =  folder.components(separatedBy: ",")
                                    
                                    let mailFolder = MailAcntFolders(folderID: Int64(folderIDAndName[0])!, folderName: folderIDAndName[1], accountID: mailAccountID, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
                                    mailFolders.append(mailFolder)
                                }
                                
                                completionHandlerForCoreData(mailFolders as AnyObject, nil)
                                
                                //save core data
                                do {
                                    try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
                                } catch {
                                    fatalError("Error while saving data")
                                }
                            }
                            else {
                                //invoke completion with Error
                                completionHandlerForCoreData(nil, NSError())
                            }
                        }
                    }
                    else {
                        //invoke completion with Error
                        completionHandlerForCoreData(nil, NSError())
                    }
                })
            }
            else {
                completionHandlerForCoreData(result as AnyObject, nil)
            }
        } catch {
            let fetchError = error as NSError
            completionHandlerForCoreData(nil, fetchError)
        }
    }
    
    static func fetchMailTagsForAccount(mailAccountID: Int64, emailID: String, completionHandlerForCoreData: @escaping CoreDataResponseHandler) {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsTagTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntTags.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntTags]
            if let fetchedResults = result, fetchedResults.count == 0 {
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getMailTags(oAuthToken: oAuthToken, emailID: emailID) { (serviceWidgetData, error) in
                            if let serviceWidgetData = serviceWidgetData as? [[String: String]] {
                                var mailTags = [MailAcntTags]()
                                
                                for tag in serviceWidgetData {
                                    let tagID = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagID]
                                    let tagName = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagName]
                                    let tagColor = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagColor]
                                    
                                    let mailTag = MailAcntTags(tagID: Int64(tagID!)!, tagName: tagName!, accountID: mailAccountID, tagColor: tagColor!, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
                                    mailTags.append(mailTag)
                                }
                                
                                completionHandlerForCoreData(mailTags as AnyObject, nil)
                                
                                //save core data
                                do {
                                    try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
                                } catch {
                                    fatalError("Error while saving data")
                                }
                            }
                            else {
                                //invoke completion with Error
                                completionHandlerForCoreData(nil, NSError())
                            }
                        }
                    }
                    else {
                        //invoke completion with Error
                        completionHandlerForCoreData(nil, NSError())
                    }
                })
            }
            else {
                completionHandlerForCoreData(result as AnyObject, nil)
            }
        } catch {
            let fetchError = error as NSError
            completionHandlerForCoreData(nil, fetchError)
        }
    }
}
