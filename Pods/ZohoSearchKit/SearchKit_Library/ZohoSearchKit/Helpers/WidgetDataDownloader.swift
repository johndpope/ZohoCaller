//
//  WidgetDataDownloader.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import CoreData

class WidgetDataDownloader {
    private var personalContantsFetchCompleted: Bool = false
    private var orgContactsFetchCompleted: Bool = false
    private var serverHasMoreContacts:Bool = true
    private let contactsCacheSize:Int32 = 5000 //export to strings.xml
    private var usageCount:Int32 = 10000
    private var totalContactsInDB:Int32 = 0
    private var pageIndex:Int16 = 1
    private let fetchSize:Int16 = 250
    private var contactStart: Int16 = 0
    private var userZohoOrgID: Int64 = -1
    private var contactsType: ContactsType  = ContactsType.PERSONAL;
    
    private enum ContactsType {
        case PERSONAL
        case ORGANIZATION
    }
    
    var widgetDataTask: URLSessionDataTask?
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    
    func fetchWidgetData() {
        //we should also check failed widget sync and clean corrupted entries and fresh fetch and sync data
        if (UserPrefManager.lastWidgetDataSyncTime() == 0 && !UserPrefManager.isWidgetDataSyncInProgress()) {
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    //set in progress
                    UserPrefManager.setWidgetDataSyncInProgress()
                    
                    self.widgetDataTask = ZOSSearchAPIClient.sharedInstance().getWidgetData(oAuthToken: oAuthToken) { (widgetDataResp, error) in
                        self.widgetDataTask = nil
                        if let widgetDataResp = widgetDataResp {
                            
                            var userAccountZUID: Int64 = -1
                            var userAccountZOID: Int64 = -1
                            
                            if let currentUserInfo = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.UserInfo] as? [String: AnyObject] {
                                var userZUID: Int64 = -1
                                var email: String = ""
                                var userZOID: Int64 = -1
                                var displayName: String = ""
                                var firstName: String = ""
                                var lastName: String = ""
                                var countryCode: String = ""
                                var languageCode: String = ""
                                var timezoneCode: String = ""
                                var genderCode = "F"
                                
                                if let zuid = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.AccountZUID] {
                                    userZUID = zuid as! Int64
                                    userAccountZUID = userZUID
                                }
                                
                                if let emailAdress = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.Email] {
                                    email = emailAdress as! String
                                }
                                
                                if let zoid = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.AccountZOID] {
                                    userZOID = zoid as! Int64
                                    userAccountZOID = userZOID
                                }
                                
                                if let dName = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.DisplayName] {
                                    displayName = dName as! String
                                }
                                
                                if let fName = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.FirstName] {
                                    firstName = fName as! String
                                }
                                
                                if let lName = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.LastName] {
                                    lastName = lName as! String
                                }
                                
                                if let gender = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.Gender] {
                                    genderCode = gender as! String
                                }
                                
                                if let country = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.CountryCode] {
                                    countryCode = country as! String
                                }
                                
                                if let language = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.Language] {
                                    languageCode = language as! String
                                }
                                
                                if let timezone = currentUserInfo[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CurrentUserInfo.Timezone] {
                                    timezoneCode = timezone as! String
                                }
                                
                                //Create and insert the entity in the DB
                                _ = UserAccounts(zuid: userZUID, email: email, zoid: userZOID, displayName: displayName, firstName: firstName, lastName: lastName, gender: genderCode, country: countryCode, timezone: timezoneCode, language: languageCode, context: (self.coreDataStack?.context)!)
                                
                            }
                            
                            //once user accounts is populated, start populating user contacts
                            self.fetchUserContacts(userZUID: userAccountZUID, start: 0)
                            
                            var supportedServices = [String]()
                            if let userServices = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.ServiceList] as? [String] {
                                let unsupportedServices = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.UnsupportedServicesKey] as? [String]
                                for service in userServices {
                                    let isEnabled: Bool = true
                                    var isSupported: Bool = false
                                    
                                    if (!(unsupportedServices?.contains(service))!) {
                                        isSupported = true
                                        supportedServices.append(service)
                                    }
                                    
                                    _ = UserApps(serviceName: service, displayName: service, isSupported: isSupported, isEnabled: isEnabled, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                }
                            }
                            
                            //also cache the user services in the UserPref
                            if supportedServices.count > 0 {
                                if let defaultServiceOrder = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DefaultServiceOrder] as? [String] {
                                    var supportedDefaultServiceOrder = [String]()
                                    supportedDefaultServiceOrder.append(ZOSSearchAPIClient.ServiceNameConstants.All)
                                    for service in defaultServiceOrder {
                                        if supportedServices.contains(service) {
                                            supportedDefaultServiceOrder.append(service)
                                        }
                                    }
                                    UserPrefManager.setOrderedServiceListForUser(services: supportedDefaultServiceOrder)
                                }
                            }
                            
                            //TODO: Make sure only supported modules are inserted, or have some flag in the db for marking supported and not supported.
                            //parse and store CRM widget data - modules
                            if let crmModules = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CRMWidgetData.WidgetData] as? [[String: AnyObject]] {
                                for crmModule in crmModules {
                                    var moduleID: Int64 = -1
                                    var moduleDisplayName: String = ""
                                    var moduleName: String = ""
                                    var moduleQueryName: String = ""
                                    
                                    if let id = crmModule[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CRMWidgetData.ModuleID] {
                                        moduleID = id as! Int64
                                    }
                                    
                                    if let name = crmModule[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CRMWidgetData.ModuleName] {
                                        moduleName = name as! String
                                    }
                                    
                                    if let dName = crmModule[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CRMWidgetData.ModuleDisplayName] {
                                        moduleDisplayName = dName as! String
                                    }
                                    
                                    if let queryName = crmModule[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.CRMWidgetData.ModuleQueryName] {
                                        moduleQueryName = queryName as! String
                                    }
                                    
                                    _ = CRMModules(moduleID: moduleID, moduleName: moduleName, moduleQueryName: moduleQueryName, moduleDisplayName: moduleDisplayName, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                    
                                }
                            }
                            
                            //parse and store Connect widget data - portals
                            if let connectPortals = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.ConnectWidgetData.WidgetData] as? [[String: AnyObject]] {
                                for connectPortal in connectPortals {
                                    var portalSOID: Int64 = -1
                                    var portalName: String = ""
                                    var isDefault: Bool = false
                                    
                                    if let id = (connectPortal[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.ConnectWidgetData.PortalSOID] as? NSString)?.longLongValue {
                                        portalSOID = id
                                    }
                                    
                                    if let name = connectPortal[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.ConnectWidgetData.PortalName] {
                                        portalName = name as! String
                                    }
                                    
                                    if let isDef = (connectPortal[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.ConnectWidgetData.IsDefault] as? NSString)?.boolValue {
                                        isDefault = isDef
                                    }
                                    
                                    _ = ConnectPortals(portalID: portalSOID, portalName: portalName, isDefault: isDefault, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                    
                                }
                            }
                            
                            //parse and store mail widget data - mail accounts and mail account folder
                            if let mailAccounts = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.WidgetData] as? [[String: AnyObject]] {
                                for mailAccount in mailAccounts {
                                    var accountID: Int64 = -1
                                    var emailAddress: String = ""
                                    var dispplayName: String = ""
                                    var accountType: Int32 = 0
                                    var isDefault: Bool = false
                                    
                                    if let id = (mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.AccountID] as? NSString)?.longLongValue {
                                        accountID = id
                                    }
                                    
                                    if let email = mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.Email] {
                                        emailAddress = email as! String
                                    }
                                    
                                    if let name = mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.DisplayName] {
                                        dispplayName = name as! String
                                    }
                                    
                                    if let type = (mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.AccountType] as? NSString)?.intValue {
                                        accountType = type
                                    }
                                    
                                    if let isDef = mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.IsDefault] as? Bool {
                                        isDefault = isDef
                                    }
                                    
                                    _ = MailAccounts(accountID: accountID, accountType: accountType, displayName: dispplayName, emailAddress: emailAddress, isDefault: isDefault, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                    
                                    
                                    if let folders = mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.Folders] {
                                        let folderArray = folders as! [String]
                                        
                                        for folder in folderArray {
                                            //"1808426000000008013,Inbox/",
                                            let folderIDAndName =  folder.components(separatedBy: ",")
                                            
                                            _ = MailAcntFolders(folderID: Int64(folderIDAndName[0])!, folderName: folderIDAndName[1], accountID: accountID, context: (self.coreDataStack?.context)!)
                                        }
                                    }
                                    
                                    if let tags = mailAccount[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.Tags] {
                                        let tagArray = tags as! [[String: String]]
                                        
                                        for tag in tagArray {
                                            let tagID = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagID]
                                            let tagName = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagName]
                                            let tagColor = tag[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.MailWidgetData.TagColor]
                                            
                                            _ = MailAcntTags(tagID: Int64(tagID!)!, tagName: tagName!, accountID: accountID, tagColor: tagColor!, context: (self.coreDataStack?.context)!)
                                        }
                                    }
                                    
                                }
                            }
                            
                            //parse and store desk portals, desk departments, desk modules.
                            if let supportWidgetData = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.WidgetData] as? [[String: AnyObject]] {
                                var defaultPortalID: Int64 = -1
                                var defaultDepartmentID: Int64 = -1
                                
                                if let defaultData = supportWidgetData[3][ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.DefaultData] as? [String: AnyObject] {
                                    if let defPortalID = (defaultData[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.DefaultPortalID] as? NSString)?.longLongValue {
                                        defaultPortalID = defPortalID
                                    }
                                    
                                    if let defDeptID = (defaultData[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.DefaultDepartmentID] as? NSString)?.longLongValue {
                                        defaultDepartmentID = defDeptID
                                    }
                                }
                                
                                if let portalData = supportWidgetData[0][ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.ListData] as? [String: AnyObject] {
                                    for (portalID, portalName) in portalData {
                                        let porID = Int64(portalID)
                                        let porName: String = portalName as! String
                                        var isDef: Bool = false
                                        if (porID == defaultPortalID) {
                                            isDef = true
                                        }
                                        
                                        //create and persist Desk portal entity
                                        _ = DeskPortals(portalID: porID!, portalName: porName, isDefault: isDef, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                        
                                        if let deptData = supportWidgetData[1][ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.PermData] as? [String: AnyObject] {
                                            if let departments = deptData[portalID] as? [[String: AnyObject]] {
                                                for department in departments {
                                                    //for (deptID, deptName) in department {
                                                    var departmentID: Int64 = -1
                                                    var departmentName: String = ""
                                                    var isDefDept: Bool = false
                                                    
                                                    if let depID = (department[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.DepartmentID] as? NSString)?.longLongValue {
                                                        departmentID = depID
                                                    }
                                                    
                                                    if let depName = (department[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.DepartmentName] as? NSString) {
                                                        departmentName = depName as String
                                                    }
                                                    
                                                    if (departmentID == defaultDepartmentID) {
                                                        isDefDept = true
                                                    }
                                                    
                                                    //create and persist desk portal department entity
                                                    _ = DeskDepartments(deptID: departmentID, deptName: departmentName, isDefault: isDefDept, portalID: porID!, context: (self.coreDataStack?.context)!)
                                                }
                                            }
                                        }
                                        
                                        //only first four modules are supported like - Request, KB, Contacts, and Accounts
                                        if let moduleData = supportWidgetData[2][ZOSSearchAPIClient.WidgetDataResponseJSONKeys.DeskWidgetData.ModuleData] as? [String: AnyObject] {
                                            if let modules = moduleData[portalID] as? [String: AnyObject] {
                                                let supportedDeskModules = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.SupportedDeskModulesKey] as? [String]
                                                for (moduleID, moduleName) in modules {
                                                    if (supportedDeskModules?.contains(moduleID))! {
                                                        let modID =  Int16(moduleID)
                                                        let modName: String = moduleName as! String
                                                        
                                                        _ = DeskModules(moduleID: modID!, moduleName: modName, portalID: porID!, context: (self.coreDataStack?.context)!)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //create and store wiki widget data
                            if let wikis = widgetDataResp[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.WidgetData] as? [[String: AnyObject]] {
                                for wiki in wikis {
                                    var wikiID: Int64 = -1
                                    var wikiName: String = ""
                                    var isDefault: Bool = false
                                    
                                    if let myWikis = wiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.PersonalWiki] as? [[String: AnyObject]] {
                                        for myWiki in myWikis {
                                            if let id = (myWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.WikiID] as? NSString)?.longLongValue  {
                                                wikiID = id
                                            }
                                            
                                            if let name = myWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.WikiName] as? String {
                                                wikiName = name
                                            }
                                            
                                            if let isDef = (myWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.IsDefault] as? NSString)?.boolValue{
                                                isDefault = isDef
                                            }
                                            
                                            if wikiID != -1 {
                                                _ = UserWikis(wikiID: wikiID, wikiType: 0, wikiName: wikiName, isDefault: isDefault, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                            }
                                        }
                                    }
                                    
                                    //redundant code optimize and reuse
                                    if let subscribedWikis = wiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.SubscribedWiki] as? [[String: AnyObject]] {
                                        for subWiki in subscribedWikis {
                                            if let id = (subWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.WikiID] as? NSString)?.longLongValue  {
                                                wikiID = id
                                            }
                                            
                                            if let name = subWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.WikiName] as? String {
                                                wikiName = name
                                            }
                                            
                                            if let isDef = (subWiki[ZOSSearchAPIClient.WidgetDataResponseJSONKeys.WikiWidgetData.IsDefault] as? NSString)?.boolValue{
                                                isDefault = isDef
                                            }
                                            
                                            if wikiID != -1 {
                                                _ = UserWikis(wikiID: wikiID, wikiType: 1, wikiName: wikiName, isDefault: isDefault, userAccountZUID: userAccountZUID, context: (self.coreDataStack?.context)!)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            //temp code, either will be saved at the end or will be saved when app goes to bg
                            do {
                                try self.coreDataStack?.saveContext()
                            }
                            catch {
                                
                            }
                            //save last widget data sync time and finished status
                            UserPrefManager.setWidgetDataSyncFinished()
                            UserPrefManager.setLastWidgetDataSyncTime(syncTime: Int(Date().millisecondsSince1970))
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "widgetdatadownloadcomplete"), object: nil)
                        }
                    }
                }
            })
        }
        else {
            //temp code, will be replaced with code with support iOS 9.0 and above
            print("Widget data already downloaded!")
        }
    }
    
    func fetchUserContacts(userZUID: Int64, start: Int16) {
        if (serverHasMoreContacts && totalContactsInDB < contactsCacheSize) {
            
            var type = "fetchPersonalContacts"
            if (personalContantsFetchCompleted) {
                type = "fetchOrgContacts"
            }
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    self.widgetDataTask = ZOSSearchAPIClient.sharedInstance().getUserContacts(type: type, oAuthToken: oAuthToken, start: start, fetchSize: self.fetchSize) { (contacts, error) in
                        self.widgetDataTask = nil
                        
                        if let contacts = contacts {
                            if let contactList = contacts[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactsList] as? [[String: AnyObject]] {
                                
                                var counter: Int32 = 0
                                for contact in contactList {
                                    
                                    var contactZUID: Int64 = -1
                                    var emailAddress: String = ""
                                    var firstName: String = ""
                                    var lastName: String = ""
                                    var nickName: String = ""
                                    var isCurrentUser: Bool = false
                                    var contactStatus: Int8 = 1
                                    var conType = "1"
                                    
                                    if let zuid = (contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactZUID] as? NSString)?.longLongValue {
                                        contactZUID = zuid
                                        //if contact's zuid -1, then there is no use of that code in auto suggest as will not be able to search for that.
                                        if contactZUID == -1 {
                                            continue
                                        }
                                        else {
                                            if contactZUID == userZUID {
                                                isCurrentUser = true
                                            }
                                        }
                                    }
                                    
                                    if let status = (contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactStatus] as? NSString)?.intValue {
                                        contactStatus = Int8(status)
                                    }
                                    
                                    if let type = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactType] {
                                        conType = type as! String
                                    }
                                    
                                    if ((self.contactsType == ContactsType.PERSONAL && (isCurrentUser || contactStatus >= 0 || contactStatus == -1 || contactStatus == -3)) || (self.contactsType == ContactsType.ORGANIZATION && conType == "1")) {
                                        //only when above conditions are met, persist the contact in the Database
                                        counter = counter + 1
                                        
                                        if let fName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.FirstName] {
                                            firstName = fName as! String
                                        }
                                        
                                        if let lName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.LastName] {
                                            lastName = lName as! String
                                        }
                                        
                                        if let nName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.NickName] {
                                            nickName = nName as! String
                                        }
                                        
                                        if let email = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.EmailID] {
                                            emailAddress = email as! String
                                        }
                                        
                                        if (!self.isExist(contactZUID: contactZUID, accountZUID: userZUID)) {
                                            _ = UserContacts(contactZUID: contactZUID, emailAddress: emailAddress, firstName: firstName, lastName: lastName, nickName: nickName, usageCount: self.usageCount, userAccountZUID: userZUID, context: (self.coreDataStack?.context)!)
                                            
                                            //decrease the usage count by 1
                                            self.usageCount = self.usageCount - 1
                                        }
                                    }
                                    
                                }
                                
                                self.totalContactsInDB = self.totalContactsInDB + counter
                                self.pageIndex = self.pageIndex + 1
                                if (contactList.count < self.fetchSize && !self.personalContantsFetchCompleted) {
                                    self.personalContantsFetchCompleted = true;
                                    self.pageIndex = 0;
                                    self.contactsType = ContactsType.ORGANIZATION;
                                    //fetchAndStoreContactsData(zuid);
                                }
                                else if (contactList.count < self.fetchSize && !self.orgContactsFetchCompleted) {
                                    self.serverHasMoreContacts = false;
                                    self.orgContactsFetchCompleted = true;
                                }
                                
                                //flush the fetched contacts to Disk
                                do {
                                    try self.coreDataStack?.saveContext()
                                }
                                catch {
                                    
                                }
                                
                                //Recursive call to fetch more contacts
                                self.fetchUserContacts(userZUID: userZUID, start: self.pageIndex * self.fetchSize);
                            }
                        }
                    }
                }
            })
        }
        else {
            print("Done with the contact downloading")
        }
    }
    
    //Important:- Core data does not have internal handling for duplicate handling
    //that is on conflict there is no notion for REPLACE, IGNORE, ABORT as in SQLite
    //that is why when we know there are chances of duplicates, we should check first
    //otherwise contact saving will fail
    //check contact if already exists using contact zuid
    func isExist(contactZUID: Int64, accountZUID: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserContacts")
        let predicate1 = NSPredicate(format: "contact_zuid == \(contactZUID)")
        let predicate2 = NSPredicate(format: "account_zuid == \(accountZUID)")
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        fetchRequest.predicate = predicateCompound
        
        let res = try! (self.coreDataStack?.context)!.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    /*
    func fetchUserContacts(userZUID: Int64, userZOID: Int64) {
        if (!serverHasMoreContacts || totalContactsInDB >= contactsCacheSize) {
            print("Contact downloading completed")
            return;
        }
        else {
            var pathExtn = ""
            if (!personalContantsFetchCompleted) {
                pathExtn = String(userZUID)
            }
            else {
                if (userZOID != -1) {
                    print("Going to download user org contacts..")
                    pathExtn = String(userZOID)
                }
                else {
                    print("User is not part of any org ...")
                    return;
                }
            }
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    self.widgetDataTask = ZOSSearchAPIClient.sharedInstance().getUserContacts(pathExtn: pathExtn, oAuthToken: oAuthToken, pageIndex: self.pageIndex, fetchSize: self.fetchSize) { (contacts, error) in
                        self.widgetDataTask = nil
                        
                        if let contacts = contacts {
                            if let contactList = contacts[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactsList] as? [[String: AnyObject]] {
                                
                                var counter: Int32 = 0
                                for contact in contactList {
                                    
                                    var contactID: Int64 = -1
                                    var contactZUID: Int64 = -1
                                    var emailAddress: String = ""
                                    var firstName: String = ""
                                    var lastName: String = ""
                                    var nickName: String = ""
                                    var phoneNumber: String = ""
                                    var photoURL:String = ""
                                    var isCurrentUser: Bool = false
                                    var contactStatus: Int8 = 1
                                    var conType = "1"
                                    
                                    if let id = (contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactID] as? NSString)?.longLongValue {
                                        contactID = id
                                    }
                                    
                                    if let zuid = (contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactZUID] as? NSString)?.longLongValue {
                                        contactZUID = zuid
                                        //if contact's zuid -1, then there is no use of that code in auto suggest as will not be able to search for that.
                                        if contactZUID == -1 {
                                            continue
                                        }
                                        else {
                                            if contactZUID == userZUID {
                                                isCurrentUser = true
                                            }
                                        }
                                    }
                                    
                                    if let status = (contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactStatus] as? NSString)?.intValue {
                                        contactStatus = Int8(status)
                                    }
                                    
                                    if let type = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.ContactType] {
                                        conType = type as! String
                                    }
                                    
                                    if ((self.contactsType == ContactsType.PERSONAL && (isCurrentUser || contactStatus >= 0 || contactStatus == -1 || contactStatus == -3)) || (self.contactsType == ContactsType.ORGANIZATION && conType == "1")) {
                                        //only when above conditions are met, persist the contact in the Database
                                        counter = counter + 1
                                        
                                        if let fName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.FirstName] {
                                            firstName = fName as! String
                                        }
                                        
                                        if let lName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.LastName] {
                                            lastName = lName as! String
                                        }
                                        
                                        if let nName = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.NickName] {
                                            nickName = nName as! String
                                        }
                                        
                                        if let pURL = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.PhotoURL] {
                                            photoURL = pURL as! String
                                        }
                                        
                                        if let emails = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.EmailAddresses] as? [[String: AnyObject]], emails.count > 0 {
                                            //by default first email will be set if none of the email address has been marked as Primary
                                            if let emailAdr = emails[0][ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.EmailID] {
                                                emailAddress = emailAdr as! String
                                            }
                                            
                                            for email in emails {
                                                if let primary = (email[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.IsPrimaryEmail] as? NSString)?.boolValue, primary {
                                                    if let emailAdr = email[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.EmailID] {
                                                        emailAddress = emailAdr as! String
                                                    }
                                                    break
                                                }
                                            }
                                        }
                                        
                                        if let phones = contact[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.PhoneNumbers] as? [[String: AnyObject]], phones.count > 0 {
                                            //by default first email will be set if none of the email address has been marked as Primary
                                            if let phone = phones[0][ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.PhoneNumber] {
                                                phoneNumber = phone as! String
                                            }
                                            
                                            for phone in phones {
                                                if let type = (phone[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.PhoneNumberType] as? String), type == "mobile" {
                                                    if let number = phone[ZOSSearchAPIClient.ContactsResponseJSONKeys.ContactInfo.PhoneNumber] {
                                                        phoneNumber = number as! String
                                                    }
                                                    break
                                                }
                                            }
                                        }
                                        
                                        _ = UserContacts(contactID: contactID, contactZUID: contactZUID, emailAddress: emailAddress, firstName: firstName, lastName: lastName, nickName: nickName, phoneNumber: phoneNumber, photoURL: photoURL, usageCount: self.usageCount, userAccountZUID: userZUID, context: (self.coreDataStack?.context)!)
                                        
                                        //decrease the usage count by 1
                                        self.usageCount = self.usageCount - 1
                                    }
                                    
                                }
                                
                                self.totalContactsInDB = self.totalContactsInDB + counter
                                self.pageIndex = self.pageIndex + 1
                                if (contactList.count < self.fetchSize && !self.personalContantsFetchCompleted) {
                                    self.personalContantsFetchCompleted = true;
                                    self.pageIndex = 1;
                                    self.contactsType = ContactsType.ORGANIZATION;
                                    //fetchAndStoreContactsData(zuid);
                                }
                                else if (contactList.count < self.fetchSize && !self.orgContactsFetchCompleted) {
                                    self.serverHasMoreContacts = false;
                                    self.orgContactsFetchCompleted = true;
                                }
                                
                                //incrementally flush the fetched contacts to Disk
                                do {
                                    try self.coreDataStack?.saveContext()
                                }
                                catch {
                                    
                                }
                                
                                //Recursive call to fetch more contacts
                                self.fetchUserContacts(userZUID: userZUID, userZOID: userZOID);
                            }
                        }
                    }
                }
            })
        }
    }
    */
    
}
