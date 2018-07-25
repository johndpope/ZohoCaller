//
//  ZohoSearchKit.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import CoreData

//Info.plist can not be merged. So, we have to manually put in that App.
//TODO: any solution so that we can put that schemes that need to be queries by the SDK to open in App.

/**
 `ZohoSearchKit` class to initialize and invoke different SDK functionalities.
 
 ### Functionalities like: ###
 - initialize: Initializes the SDK
 - open search UI: Opens the Search UI
 */
public class ZohoSearchKit : NSObject , NSFetchedResultsControllerDelegate {
    //not used right now, but can be used later
    typealias ZSearchKitOAuthTokenHandler = (_ token: String?, _ error: Error?) -> Void
    
    //Framework bundle instance needed while loading resources(storyboard, images, nib) from the framework module
    static let frameworkBundle = Bundle(for: ZohoSearchKit.self)
    var searchKitConfig: SearchKitConfig? = nil
    var appInfoPropertyList: [String : AnyObject] = [:]
    var frameworkConfigPropertyList: [String : AnyObject] = [:]
    var printDebugLog = false
    var resultsHighlightingEnabled = true
    
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    var widgetDataTask: URLSessionDataTask?
    var activityIndicator: ActivityIndicatorUtils?
    
    var searchViewController: SearchResultsViewController?
    //later this is used to present the SearchViewController when the user hits the search button
    //in the MedianViewController.
    var appViewController: UIViewController?
    var appViewControllerInfo: AppViewControllerInfo?
    var settingsViewController: SearchSettingsViewController?
    var cachedCurrentUser: ZOSCurrentUser?
    
    //Singletone instance
    @objc public class func sharedInstance() -> ZohoSearchKit {
        struct Singleton {
            static var sharedInstance = ZohoSearchKit()
        }
        return Singleton.sharedInstance
    }
    //static public let sharedInstance = ZohoSearchKit()
    
    /**
     Call this function to initialize the `ZohoSearchKit` with instance of `SearchKitConfig`
     
     - Parameter searchKitConfig: Instance of SearchKitConfig
     - Parameter debugMode: The last part of the fullname.
     - Returns: Void
     
     - Note:
     This method must be called only from your `AppDelegate`
     
     ### Usage Example: ###
     ````
     let authImplObject = ZohoSearchKitAuthImpl()
     let searchKitConfig = SearchKitConfig()
     searchKitConfig.setAuthAdapter(authImplObject)
     searchKitConfig.setPListFileNameForSearchKit("SearchKitCustomization.plist")
     ZohoSearchKit.sharedInstance().initialize(withConfig: searchKitConfig, debugMode: .AutoDebug)
     ````
     */
    @objc public func initialize(withConfig searchKitConfig: SearchKitConfig, debugMode: SearchKitBuildType) -> Void {
        self.searchKitConfig = searchKitConfig
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationWillEnterBackground(_:)),
                                               name:NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationWillTerminate(_:)),
                                               name:NSNotification.Name.UIApplicationWillTerminate,
                                               object: nil)
        
        switch debugMode {
        case .AutoDebug:
            #if DEBUG
                printDebugLog = true
            #endif
            break
        case .Debug:
            printDebugLog = true
            break
        case .Release:
            printDebugLog = false
            break
        }
        
        //register the interceptor protocol to intercept and load images in the callout
        URLProtocol.registerClass(CalloutURLProtocol.self)
        
        initSDKCustomizationOptions()
        
    }
    
    @objc public func deinitSearchKit() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getToken(_ tokenCallback: @escaping (_ token: String?, _ error: Error?) -> Void) {
        self.searchKitConfig?.getAuthAdapter()?.getOAuthToken(tokenCallback)
    }
    
    //SSOkit decodes the image, and this call impacts the UI a bit.
    //that's why we have added some caching logic
    func getCurrentUser() -> ZOSCurrentUser {
        if cachedCurrentUser == nil {
            cachedCurrentUser = (self.searchKitConfig?.getAuthAdapter()?.getCurrentUser())!
        }
        return cachedCurrentUser!
    }
    
    func getCurrentUserZUID() -> String {
        if cachedCurrentUser == nil {
            cachedCurrentUser = (self.searchKitConfig?.getAuthAdapter()?.getCurrentUser())!
        }
        return (cachedCurrentUser?.zuid)!
    }
    
    func getTransformedURL(_ url: String) -> String {
        return (self.searchKitConfig?.getAuthAdapter()?.getTransformedURL(url))!
    }

    @objc public func get(numberOfSavedSearchesRequested : Int ) -> NSFetchedResultsController<SavedSearches>
    {
        let accountZUIDPredicate = #keyPath(SavedSearches.account_zuid)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SavedSearches> = SavedSearches.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SavedSearches.lmtime), ascending: false)]
        
        //set limit
        fetchRequest.fetchLimit = numberOfSavedSearchesRequested //+ 1
        
        //set account predicate
        let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
        fetchRequest.predicate = accountPredicate
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }
    public func openVoiceSearchUI(appViewController : UIViewController, appVCInfo: AppViewControllerInfo)
    {
        
        self.appViewController = appViewController
        self.appViewControllerInfo = appVCInfo
        
        //check if results highlighting is enabled and saved in user preferences
        //Every time search ui is opened, whether highlighting is enabled or not will
        //be fetched from user pref so that same can be applied
        resultsHighlightingEnabled = UserPrefManager.isResultHighlightingEnabled()
        
        if UserPrefManager.isWidgetDataSyncInProgress() {
            //adding notification observer
            NotificationCenter.default.addObserver(self,
                                                   selector:#selector(widgetDataDownloaded(_:)),
                                                   name:NSNotification.Name(rawValue: SearchKitConstants.CustomNotificationNames.WidgetDataDownloadComplete),
                                                   object: nil)
            
            activityIndicator = ActivityIndicatorUtils()
            activityIndicator?.showActivityIndicator(uiView: appViewController.view)
        }
        else {
            let targetVC: SearchQueryViewController = SearchQueryViewController.vcInstanceFromStoryboard()!
            //MARK:- we have to set isvoice search to dimiss keyboard
            targetVC.isVoiceSearch = true
            SearchResultsViewModel.ResultVC.isNewSearch = true
            SearchResultsViewModel.ResultVC.isContactSearch = false
            SearchResultsViewModel.ResultVC.ZUID = -1
            SearchResultsViewModel.ResultVC.searchText = ""
            SearchResultsViewModel.ResultVC.trimmedSearchQuery = ""
            
            let defaultService = UserPrefManager.getDefaultServiceForUser()
            SearchResultsViewModel.selectedService = defaultService
            var counter = -1
            if let preferredServiceOrder = UserPrefManager.getOrderedServiceListForUser() {
                for service in preferredServiceOrder {
                    counter = counter + 1
                    if service == defaultService {
                        break
                    }
                }
            }
            // MARK : if  you download and click search button immediatly counter is not setted
            if counter == -1
            {
                SearchResultsViewModel.selected_service = 0
            }
            else
            {
                SearchResultsViewModel.selected_service = counter
            }
            SearchResultsViewModel.serviceSections.removeAll()
            
            //otherwise can embed the Application's view controller inside navigation view controller
            //that will be kind of dummy like given below
            //let navController = UINavigationController(rootViewController: targetVC)
            // MARK: The application who want's to use SearchKit must have navigation controller
            //even if they don't want, they have to have it it is ok to have hidden but navigation controller is must
            appViewController.navigationController?.pushViewController(targetVC, animated: true)
        }
        
        //MARK:- get current top viewcontroller from uiapplication i.e queryviewcontroller
        let queryVC =  appViewController.navigationController?.viewControllers.last as? SearchQueryViewController
        //MARK:- When query vc
        if #available(iOS 10.0, *) {
            let voiceSearchVC = ZOSVoiceSearchVC.vcInstanceFromStoryboard()
            let voiceVC_Y = UIScreen.main.bounds.height / 2 + 50
            let voiceVC_height = (UIScreen.main.bounds.height - UIScreen.main.bounds.height / 2 + 50)
            voiceSearchVC?.view.frame = CGRect(x: 0, y: voiceVC_Y , width: UIScreen.main.bounds.width, height: voiceVC_height)
            queryVC?.add(childViewController: voiceSearchVC!)
        } else {
            // Fallback on earlier versions
        }
      
        
    }
    @objc public func get(numberOfHistoryRequested : Int ) -> NSFetchedResultsController<SearchHistory>
    {
        let accountZUIDPredicate = #keyPath(SearchHistory.account_zuid)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.propertiesToFetch = [#keyPath(SearchHistory.search_query), #keyPath(SearchHistory.mention_zuid), #keyPath(SearchHistory.mention_contact_name)]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SearchHistory.timestamp), ascending: false)]
        //so that the latest search query comes on top of the suggestion. As per core data, all the column included in selection should be in group by list
        fetchRequest.propertiesToGroupBy = [#keyPath(SearchHistory.search_query), #keyPath(SearchHistory.mention_zuid), #keyPath(SearchHistory.mention_contact_name)]
        
        //set limit
        fetchRequest.fetchLimit = numberOfHistoryRequested //+ 1
        
        //set account predicate
        let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
        fetchRequest.predicate = accountPredicate
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }
    
    //delete data
    @objc public func clearCurrentUserSearchKitData(shouldDeleteUserPrefs: Bool) {
        //later we will optimize with relations and cascade delete
        
        if shouldDeleteUserPrefs {
            UserPrefManager.clearAllUserPreferences()
        }
        else {
            UserPrefManager.clearDataSyncStatus()
        }
        
        let currentUserZUID = Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!
        
        //delete accounts table
        //accounts table should be deleted only after deleting all data
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.UserAccountsTable, pkIDField: #keyPath(UserAccounts.zuid), pkIDValue: currentUserZUID)
        //delete user apps
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.UserAppsTable, pkIDField: #keyPath(UserApps.account_zuid), pkIDValue: currentUserZUID)
        //delete user contacts
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.UserContactsTable, pkIDField: #keyPath(UserContacts.account_zuid), pkIDValue: currentUserZUID)
        //delete saved searches
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.SavedSearchesTable, pkIDField: #keyPath(SavedSearches.account_zuid), pkIDValue: currentUserZUID)
        //delete user search history
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.SearchHistoryTable, pkIDField: #keyPath(SearchHistory.account_zuid), pkIDValue: currentUserZUID)
        //delete connect portals
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.ConnectPortalsTable, pkIDField: #keyPath(ConnectPortals.account_zuid), pkIDValue: currentUserZUID)
        //delete crm modules
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.CRMModulesTable, pkIDField: #keyPath(CRMModules.account_zuid), pkIDValue: currentUserZUID)
        //delete user wikis
        deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.UserWikisTable, pkIDField: #keyPath(UserWikis.account_zuid), pkIDValue: currentUserZUID)
        //delete desk portals
        let portalsDeleted = deleteRecordsAndGetIDs(from: SearchKitConstants.CoreDataStackConstants.DeskPortalsTable, accountIDField: #keyPath(DeskPortals.account_zuid))
        
        //delete child tables like desk departments and desk modules
        for portalID in portalsDeleted {
            //delete desk departments
            deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.DeskDepartmentsTable, pkIDField: #keyPath(DeskDepartments.portal_id), pkIDValue: portalID)
            
            //delete desk modules
            deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.DeskModulesTable, pkIDField: #keyPath(DeskModules.portal_id), pkIDValue: portalID)
        }
        
        //delete Mail accounts table
        let mailAccountsDeleted = deleteRecordsAndGetIDs(from: SearchKitConstants.CoreDataStackConstants.MailAccountsTable, accountIDField: #keyPath(MailAccounts.account_zuid))
        
        //delete child tables like desk departments and desk modules
        for mailAccountID in mailAccountsDeleted {
            //delete mail account folders
            deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.MailAccountsFolderTable, pkIDField: #keyPath(MailAcntFolders.account_id), pkIDValue: mailAccountID)
            //delete mail account tags
            deleteCachedRecords(from: SearchKitConstants.CoreDataStackConstants.MailAccountsTagTable, pkIDField: #keyPath(MailAcntTags.account_id), pkIDValue: mailAccountID)
        }
        
        
        //finally flush the deleted record to delete from disk
        do {
            try coreDataStack?.saveContext()
        }
        catch {
            
        }
        
    }
    
    //find and delete records for the current user for the given entity
    private func deleteCachedRecords(from entityName: String, pkIDField: String, pkIDValue: Int64) {
        //let currentUserZUID = Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!
        
        let accountPredicate = NSPredicate(format: pkIDField + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, pkIDValue)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        fetchRequest.predicate = accountPredicate
        
        do {
            //Fetch the records to be deleted with matching predicate
            let records = try coreDataStack?.context.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                for record in records {
                    coreDataStack?.context.delete(record)
                }
            }
        } catch {
            SearchKitLogger.errorLog(message: "Unable to delete records from "+entityName, filePath: #file, lineNumber: #line, funcName: #function)
        }
    }
    
    private func deleteRecordsAndGetIDs(from entityName: String, accountIDField: String) -> [Int64] {
        let currentUserZUID = Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!
        
        var accountsDeleted = [Int64]()
        let accountPredicate = NSPredicate(format: accountIDField + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUserZUID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        fetchRequest.predicate = accountPredicate
        
        do {
            // Execute Fetch Request
            let records = try coreDataStack?.context.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                for object in records {
                    if entityName == SearchKitConstants.CoreDataStackConstants.DeskPortalsTable {
                        let deskPortal = object as! DeskPortals
                        accountsDeleted.append(deskPortal.portal_id)
                    }
                    else if entityName == SearchKitConstants.CoreDataStackConstants.MailAccountsTable {
                        let mailAccount = object as! MailAccounts
                        accountsDeleted.append(mailAccount.account_id)
                    }
                    coreDataStack?.context.delete(object)
                }
            }
            
        } catch {
            SearchKitLogger.errorLog(message: "Unable to delete connect portals", filePath: #file, lineNumber: #line, funcName: #function)
        }
        
        return accountsDeleted
    }
    
    @objc public func openSearchSettings(appVC: UIViewController, appVCInfo: AppViewControllerInfo)
    {
        self.appViewController = appVC
        self.appViewControllerInfo = appVCInfo
        if  let settingsVC = SearchSettingsViewController.vcInstanceFromStoryboard()
        {
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    @objc public func openResultVCUIfor(savedSearch : SavedSearches ,appVC: UIViewController, appVCInfo: AppViewControllerInfo ,contactImage : UIImage?) {
        self.appViewController = appVC
        self.appViewControllerInfo = appVCInfo
       FilterVCHelper.sharedInstance().ConvertDataAndPresentResultVC(from: savedSearch)
    }
    
    @objc public func openResultVCUIfor(history : SearchHistory ,appVC: UIViewController, appVCInfo: AppViewControllerInfo ,contactImage : UIImage?)
    {
      self.appViewController = appVC
      self.appViewControllerInfo = appVCInfo
        SearchResultsViewModel.serviceSections.removeAll()
        let searchQueryAttribute = #keyPath(SearchHistory.search_query)
       SearchResultsViewModel.QueryVC.suggestionPageSearchText = ((history.value(forKey: searchQueryAttribute))! as? String)!
        let mentionZUIDAttribute = #keyPath(SearchHistory.mention_zuid)
        if let zuid = (history.value(forKey: mentionZUIDAttribute) as? Int64), zuid != -1 {

            SearchResultsViewModel.QueryVC.isAtMensionSelected = true
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            SearchResultsViewModel.QueryVC.suggestionZUID = zuid
            SearchResultsViewModel.QueryVC.suggestionPageSearchText  = ((history.value(forKey: searchQueryAttribute))! as? String)!
            let contactNameAttribute = #keyPath(SearchHistory.mention_contact_name)
            SearchResultsViewModel.QueryVC.suggestionContactName = (history.value(forKey: contactNameAttribute) as? String)!
        }
        else {
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            SearchResultsViewModel.QueryVC.isAtMensionSelected = false
            SearchResultsViewModel.QueryVC.suggestionContactName = ""
            SearchResultsViewModel.QueryVC.suggestionZUID = -1
        }
        presentResultVC()
    }
 
    func presentResultVC()
    {
        let trimmedSearchQuery =   SearchResultsViewModel.QueryVC.suggestionPageSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = try? NSRegularExpression(pattern: "  +", options: .caseInsensitive)
        let trimmedString: String? = regex?.stringByReplacingMatches(in: trimmedSearchQuery, options: [], range: NSRange(location: 0, length: trimmedSearchQuery.count), withTemplate: " ")
        
        if !(trimmedString?.isEmpty)! || SearchResultsViewModel.QueryVC.isAtMensionSelected {
            
            //when query state is searchanble, hide the keyboard and search
            
            let currentSelected = SearchResultsViewModel.selected_service
            
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
//
            if let nav = ZohoSearchKit.sharedInstance().appViewController?.navigationController {
                var stack = nav.viewControllers
                let vc = stack[stack.count - 1] //just before last one
                //let index = stack.index(of: vc)
                if vc is SearchResultsViewController {
                    //stack.remove(at: stack.count - 1)
                    //stack.remove(at: stack.count - 1) //pop also the last one
                    ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
                }
                //nav.setViewControllers(stack, animated: true)
            }
            
            let target = SearchResultsViewController.vcInstanceFromStoryboard()!
            
            ZohoSearchKit.sharedInstance().searchViewController = target
            SearchResultsViewModel.firstTimeSearch = true
            SearchResultsViewModel.selected_service = currentSelected
            SearchResultsViewModel.ResultVC.contactName = SearchResultsViewModel.QueryVC.suggestionContactName
            SearchResultsViewModel.ResultVC.isContactSearch = SearchResultsViewModel.QueryVC.isAtMensionSelected
            SearchResultsViewModel.ResultVC.ZUID = SearchResultsViewModel.QueryVC.suggestionZUID
            SearchResultsViewModel.ResultVC.isNamelabledisplay = false
            SearchResultsViewModel.ResultVC.searchText =   SearchResultsViewModel.QueryVC.suggestionPageSearchText
            SearchResultsViewModel.ResultVC.trimmedSearchQuery = SearchResultsViewModel.QueryVC.suggestionPageSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            SearchResultsViewModel.searchWhenLoaded = true
            target.currentIndex =  SearchResultsViewModel.selected_service
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(target, animated: false)
            
            //TODO: This should be done asynch, so that it does not block the search request and delay
            //only non empty search will be stored.
            //only @mention will also be not stored. as per below logic
            if !(trimmedString?.isEmpty)! {
                let searchType = UserPrefManager.getServiceNameForIndex(index: SearchResultsViewModel.selected_service)
                var contactName: String?
                if (SearchResultsViewModel.QueryVC.suggestionZUID != -1) {
                    contactName = SearchResultsViewModel.QueryVC.suggestionContactName
                }
                else {
                    contactName = ""
                }
                //                _ = SearchHistory(mentionedZUID: SearchResultsViewModel.ZUID!, contactName: contactName, resultCount: 0, searchQuery: trimmedString!, searchType: searchType, timestamp: Int64(Date().millisecondsSince1970), userAccountZUID: Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
                _ = SearchHistory(mentionedZUID: SearchResultsViewModel.QueryVC.suggestionZUID!, contactName: contactName, resultCount: 0, searchQuery: trimmedString!, searchType: searchType, timestamp: Int64(Date().millisecondsSince1970), userAccountZUID: Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
                
            }
            
            //instead we will save periodically or on notification
            do {
                try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
            }
            catch {
                
            }

        }
        else {
            //empty search is not allowed. atleast the user has to select some contact to search
            SnackbarUtils.showMessageWithDismiss(msg: "Search query is empty")
        }
        
    }
    @objc public func  getImagefor(zuid : Int64 , completionHandler : @escaping (_ contactImage: UIImage?, _ error: Error?) -> Void)
    {
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            //ZSSOKit.getOAuth2Token({ (token, error) in
            if let oAuthToken = token {
                let _ = ZOSSearchAPIClient.sharedInstance().getContactImage(zuid, oAuthToken: oAuthToken, completionHandlerForImage: { (userImage, error) in
                    if userImage == nil {
                        performUIUpdatesOnMain {
                            let NoUserImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                           completionHandler(NoUserImage,error)
                        }
                    }
                    else {
                        performUIUpdatesOnMain {
                            //stop the loading image animation
                           
                            //set new downloaded image to the image view withing above created border
                            completionHandler(userImage ,error)
                        }
                    }
                })
            }
        })
    }
    @objc public func openSearchUI(appViewController: UIViewController, appVCInfo: AppViewControllerInfo) {
        self.appViewController = appViewController
        self.appViewControllerInfo = appVCInfo
        
        //check if results highlighting is enabled and saved in user preferences
        //Every time search ui is opened, whether highlighting is enabled or not will
        //be fetched from user pref so that same can be applied
        resultsHighlightingEnabled = UserPrefManager.isResultHighlightingEnabled()
        
        if UserPrefManager.isWidgetDataSyncInProgress() {
            //adding notification observer
            NotificationCenter.default.addObserver(self,
                                                   selector:#selector(widgetDataDownloaded(_:)),
                                                   name:NSNotification.Name(rawValue: SearchKitConstants.CustomNotificationNames.WidgetDataDownloadComplete),
                                                   object: nil)
            
            activityIndicator = ActivityIndicatorUtils()
            activityIndicator?.showActivityIndicator(uiView: appViewController.view)
        }
        else {
            presentSearchQueryVC()
        }
    }
    
    private func presentSearchQueryVC() {
        let targetVC: SearchQueryViewController = SearchQueryViewController.vcInstanceFromStoryboard()!
        
        SearchResultsViewModel.ResultVC.isNewSearch = true
        SearchResultsViewModel.ResultVC.isContactSearch = false
        SearchResultsViewModel.ResultVC.ZUID = -1
        SearchResultsViewModel.ResultVC.searchText = ""
        SearchResultsViewModel.ResultVC.trimmedSearchQuery = ""
        
        let defaultService = UserPrefManager.getDefaultServiceForUser()
        SearchResultsViewModel.selectedService = defaultService
        var counter = -1
        if let preferredServiceOrder = UserPrefManager.getOrderedServiceListForUser() {
            for service in preferredServiceOrder {
                counter = counter + 1
                if service == defaultService {
                    break
                }
            }
        }
        // MARK : if  you download and click search button immediatly counter is not setted
        if counter == -1
        {
            SearchResultsViewModel.selected_service = 0
        }
        else
        {
            SearchResultsViewModel.selected_service = counter
        }
        SearchResultsViewModel.serviceSections.removeAll()
        
        //otherwise can embed the Application's view controller inside navigation view controller
        //that will be kind of dummy like given below
        //let navController = UINavigationController(rootViewController: targetVC)
        // MARK: The application who want's to use SearchKit must have navigation controller
        //even if they don't want, they have to have it it is ok to have hidden but navigation controller is must
        appViewController?.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    @objc public func prefetchSearchWidgetData() -> Void {
        let widgetdataDownloader: WidgetDataDownloader = WidgetDataDownloader()
        widgetdataDownloader.fetchWidgetData()
    }
    
    @objc func widgetDataDownloaded(_ notification: NSNotification) {
        //once widget data completed we can remove the notification oberver or listener
        activityIndicator?.hideActivityIndicator(uiView: (appViewController?.view)!)
        
        presentSearchQueryVC()
    }
    
    @objc func applicationWillTerminate(_ notification: NSNotification) {
        print("Application going to terminate")
        do {
            try self.coreDataStack?.saveContext()
        }
        catch {
            
        }
    }
    
    @objc func applicationWillEnterBackground(_ notification: NSNotification) {
        
        print("Application going to background")
        do {
            try self.coreDataStack?.saveContext()
        }
        catch {
            
        }
    }
    
    private func initSDKCustomizationOptions() {
        //read App Info.plist and ZohoSearchKitConfig.plist on background thread, not on main thread. And populate config attributes
        //DispatchQueue.global().async {
        //we need high priority queue as this is needed for Search UI to function as expected.
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.appInfoPropertyList = Bundle.contentsOfFile(plistName: (self.searchKitConfig?.getPListFileNameForSearchKit())!)
            self.frameworkConfigPropertyList = Bundle.contentsOfFile(plistName: SearchKitConfigKeys.FrameworkPropertyListFileName, bundle: ZohoSearchKit.frameworkBundle)
            
            var dismissColorCode = self.appInfoPropertyList[SearchKitConfigKeys.StatusBarDismissButtonColorKey]
            if (dismissColorCode == nil) {
                if let dismissButtonColorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.StatusBarDismissButtonColorKey] {
                    dismissColorCode = dismissButtonColorCode as! NSString
                }
            }
            if let dismissColorCode = dismissColorCode {
                self.searchKitConfig?.setSnackbarActionButtonColor(color: UIColor.hexStringToUIColor(hex: dismissColorCode as! String))
            }
            
            let searchKitURLConfig = SearchKitURLConfig()
            SearchKitConfigUtil.populateURLConfigs(searchKitURLConfig: searchKitURLConfig)
            self.searchKitConfig?.searchKitURLConfig = searchKitURLConfig
            
            let searchKitResUIConfig = SearchKitResultUIConfig()
            SearchKitConfigUtil.populateConnectUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateContactsUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateChatUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            
            SearchKitConfigUtil.populateCRMUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateDeskUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateDocsUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateMailUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populatePeopleUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            SearchKitConfigUtil.populateWikiUIProperties(searchKitResUIConfig: searchKitResUIConfig)
            
            self.searchKitConfig?.searchResultUIConfig = searchKitResUIConfig
            
        }
    }
}
