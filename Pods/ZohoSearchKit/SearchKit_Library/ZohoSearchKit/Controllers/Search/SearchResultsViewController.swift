//
//  SearchResultsViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 07/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//
import UIKit
import CoreData

protocol SearchViewControllerDelegate {
    func resultPicker(_ resultPicker: SearchResultsViewController, didPickResult results: ChatResult?)
}

///*
// Must follow these guidelines for View Controller Creation:-
// 1. Use the same name(with a prefix SearchKit_) for storyboard file and associated viewController subclass. Otherwise following code is going to crash.
// 2. Stay away from multi view controller in the same stroty board, will be pain when resolving merge conflict. One ViewController = One Storyboard
// 3. If you can't avoid using the same storyboard for multiple view controllers, then you will have to use the instantiateViewController(withIdentifier: _ )
// 4. If you want to access the ViewController by instantiateInitialViewController(), make sure you mark this viewController as initialViewController in Interface Builder.
// 5. If you want to use view controllers from multiple story board to visualize clearly, you can use Storyboard Reference.
// 6. Segue which looks nice in the Storyboard is actually not the best way, better move from one view controller to another programatically.
// */
//
////If the Parent App has to access this Search View Controller then we should mark the class open
////this will make this class visible outside the framework
////open class SearchViewController: UIViewController {

class SearchResultsViewController : TabBarViewController {
    var isReload = false
    //   @IBOutlet weak var shadowView: UIView!
    
    var alertController: UIAlertController?
    
    static func vcInstanceFromStoryboard() -> SearchResultsViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SearchResultsViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? SearchResultsViewController
    }
    @IBOutlet weak var ErrorMessageView: UIView!
    
    @IBOutlet weak var activityLoadingContainerView: UIView!
    @IBOutlet weak var activityLoadingView: ZOSActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden=true
        //  SearchResultsViewModel.serviceSections.removeAll()
//        settings.style.tabviewBackGroundColor = UIColor(red: 2.9/3, green: 2.9/3, blue: 2.9/3, alpha: 1)
//
//        //   settings.style.selectedBarBackgroundColor = UIColor(red: 0.2, green: 0.8, blue: 1, alpha: 1.0) //selected indicator
//        settings.style.tabviewItemBackGroundColor = UIColor(red: 2.8/3, green: 2.8/3, blue: 2.8/3, alpha: 1)
//        settings.style.tabviewItemFont =  UIFont.systemFont(ofSize: 16)
//        settings.style.selectedBarHeight = 3.0
//        settings.style.tabviewMinimumLineSpacing = 0.0
//        settings.style.tabviewItemTitleColor = .black
//
//        settings.style.TabBarLeftContentInset = 10
//        settings.style.TabBarRightContentInset = 10
//
        changeCurrentIndexProgressive = { (oldCell: TabBarCollectionViewCell?, newCell: TabBarCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = SearchKitConstants.ColorConstants.TabBarView_Non_SelectedCell_Text_Color
            newCell?.label.textColor = SearchKitConstants.ColorConstants.TabBarView_SelectedCell_Text_Color
        }
        changeCurrentIndex = {(_ oldCell: TabBarCollectionViewCell?, _ newCell: TabBarCollectionViewCell?, _ animated: Bool) -> Void in
            oldCell?.label.textColor = SearchKitConstants.ColorConstants.TabBarView_Non_SelectedCell_Text_Color
            newCell?.label.textColor = SearchKitConstants.ColorConstants.TabBarView_SelectedCell_Text_Color
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated) //hide navbar
        //self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true //hide tab bar
        SearchResultsViewModel.ResultVC.isNamelabledisplay = false
        self.SearchBar.text = SearchResultsViewModel.ResultVC.searchText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SearchResultsViewModel.searchWhenLoaded {
            self.searchAndLoadData(searchText: SearchResultsViewModel.ResultVC.searchText)      //sending the search Query alone
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: ChildViewController) -> [UITableViewController] {
        
        let viewControllers = SearchResultsViewModel.UserPrefOrder
        var userPrefViewControllerOrder = [TableViewController]()
        if let userPrefOrder =  UserPrefManager.getOrderedServiceListForUser()
        {
            for userService in userPrefOrder
            {
                for availService in viewControllers
                {
                    if availService.itemInfo.serviceName == userService
                    {
                        userPrefViewControllerOrder.append(availService)
                    }
                }
            }
            SearchResultsViewModel.UserPrefOrder = userPrefViewControllerOrder
            return userPrefViewControllerOrder
        }
        else {
            // if no user preferded Order Then use Default order (when app loading first time UserPrefManager.getOrderedServiceListForUser() contains nil )
            return viewControllers
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        //Important: This will recreate the Application View Controller  and present that.
        //If user has done some scrolling and all that will be lost.
        //Also ZohoSearchKit is initialised on App start
        //however search ui is presented from some view controller
        //So, while presenting the Search UI they should pass the story board name and also identifier to the View controller
        //so that we can recreate and present that view controller
        //What if the Developer has created the UI completely in Code not in Storyboard
        
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let target=storyboard.instantiateInitialViewController()
         let transition = CATransition()
         transition.duration = 0.25
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromLeft
         transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
         view.window!.layer.add(transition, forKey: kCATransition)
         
         self.present(target!, animated: true, completion: nil)
         */
        
        //this will pop the current view controller from the view controller stack
        //so it will maintain the App's view controller state, which will be just below this in the view stack
        //self.dismiss(animated: true, completion: nil)
        
        //This will also not work as to go back to the App active view controller.
        /*
         if let appVC = ZohoSearchKit.sharedInstance().appViewController {
         self.present(appVC, animated: true, completion: nil)
         }
         else {
         self.dismiss(animated: true, completion: nil)
         }
         */
        //MARK:- Clearing Search Results When User Press back Button
        SearchResultsViewModel.serviceSections.removeAll()
        viewControllers.forEach{
            let vc = $0 as! TableViewController
            vc.tableView.reloadData()
        }
        //MARK:-  Reset the Selected service to all service when back button is pressed
        SearchResultsViewModel.selected_service = 0
        SearchResultsViewModel.selectedService = ZOSSearchAPIClient.ServiceNameConstants.All
        self.currentIndex = 0
        if let nav = ZohoSearchKit.sharedInstance().appViewController?.navigationController {
            let stack = nav.viewControllers
            var copyStack = [UIViewController]()
            var counter = 0;
            for vc in stack {
                if !(vc is SearchResultsViewController || vc is SearchQueryViewController || vc is ChildViewController) {
                    //stack.remove(at: counter)
                    copyStack.append(vc)
                    //both pop and set nav bar should be there
                    ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
                }
                counter = counter + 1
            }
            nav.setViewControllers(copyStack, animated: true)
        }
        
        //ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func didPressOptionButton(_ sender: UIButton) {
        alertController = UIAlertController(title: nil, message:
            nil, preferredStyle: UIAlertControllerStyle.alert)
        
        // MARK: Saved search action button and action handler
        alertController?.addAction(UIAlertAction(title: "Save Search", style: .default, handler: { action in
            
            let saveSearchAlert = UIAlertController(title: "Save your search", message: nil, preferredStyle: .alert)
            saveSearchAlert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input saved search name here..."
            })
            saveSearchAlert.addAction(UIAlertAction(title: "Don't Save", style: .destructive, handler: nil))
            
            saveSearchAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                
                if let savedSearchName = saveSearchAlert.textFields?.first?.text {
                    //later if needed we can have inline error reporting and recovery
                    
                    let currentZUID = ZohoSearchKit.sharedInstance().getCurrentUser().zuid
                    let managedObjectContext = (ZohoSearchKit.sharedInstance().coreDataStack?.context)!
                    let lists = self.fetchRecordsForEntity("SavedSearches", accountZUID: currentZUID, savedSearchName: savedSearchName, inManagedObjectContext: managedObjectContext )
                    
                    if lists.count > 0 {
                        SnackbarUtils.showMessageWithAction(msg: "Saved search name already exists", actionButtonTitle: "Rename and Save", actionHandler: {() in
                            self.present(saveSearchAlert, animated: true, completion: nil)
                        })
                    }
                    else {
                        let currentVC = self.viewControllers[SearchResultsViewModel.selected_service] as? TableViewController
                        let serviceName = currentVC?.itemInfo.serviceName ?? ZOSSearchAPIClient.ServiceNameConstants.All
                        let jsonString = self.getQueryStateJSON(currentServiceName: serviceName)
                        
                        //create and insert the saved search entity
                        _ = SavedSearches(savedSearchName: savedSearchName, serviceName: serviceName, fullQueryStateJSON: jsonString, lmtime: Int64(Date().millisecondsSince1970), userAccountZUID: Int64(currentZUID)!, context: managedObjectContext)
                        
                        
                        
                        //save the newly saved search
                        do {
                            try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
                            //SnackbarUtils.showMessageWithDismiss(msg: "Successfully saved the search")
                            SnackbarUtils.showMessageWithAction(msg: "Successfully saved the search", actionButtonTitle: "See List", actionHandler: {() in
                                let settingsVC = SavedSearchViewController.vcInstanceFromStoryboard()
                                ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
                            })
                        }
                        catch {
                            //failed to save allow to retry
                            SnackbarUtils.showMessageWithAction(msg: "Failed to save the search", actionButtonTitle: "Retry", actionHandler: {() in
                                self.present(saveSearchAlert, animated: true, completion: nil)
                            })
                        }
                    }
                }
            }))
            
            self.present(saveSearchAlert, animated: true, completion: nil)
        }))
        
        // MARK: Search setting button and completion handler to open Search Settings
        alertController?.addAction(UIAlertAction(title: "Search Settings", style: .default, handler: { action in
            //present modally
            //            let settingsVC = SearchSettingsViewController.vcInstanceFromStoryboard()
            //            self.present(settingsVC!, animated: true, completion: nil)
            
            //push
            //            let searchVCNavController = UINavigationController(rootViewController: self)
            //            let settingsVC = SearchSettingsViewController.vcInstanceFromStoryboard()
            //            searchVCNavController.pushViewController(settingsVC!, animated: true)
            
            let settingsVC = SearchSettingsViewController.vcInstanceFromStoryboard()
            
            //to present modally on current view using the wrapper settings view controller
            //let settingsNavBar = SwipableNavigationController(rootViewController: settingsVC!)
            //ZohoSearchKit.sharedInstance().settingsViewController = settingsVC
            //self.present(settingsNavBar, animated: true, completion: nil)
            
            //for push model, for the settings page itself
            //to push even the search settings view controller so that right pull will uncover the search vc
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
        }))
        
        // MARK: New Search button and completion handler to open median view controller
        alertController?.addAction(UIAlertAction(title: "New Search", style: .default, handler: { action in
            
            let targetVC: SearchQueryViewController = SearchQueryViewController.vcInstanceFromStoryboard()!
            
            //so that previous contact selction state is cleared
//            SearchResultsViewModel.isContactSearch = false
            SearchResultsViewModel.ResultVC.isNewSearch = true
            
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(targetVC, animated: true)
        }))
        
        // MARK: last action to dismiss the alert view
        alertController?.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        
        //self.present(alertController, animated: true, completion: nil)
        
        //add gesture only in completion hander to close the alert when clicked outside
        self.present(alertController!, animated: true, completion: {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeAlertDialog(_:)))
            self.alertController?.view.superview?.addGestureRecognizer(tapGestureRecognizer)
        })
    }
    
    
    /*
     //TODO: This has to be transformed as yesterday will be a different date later on
     "type":"date",
     "value":"last_7_days",
     "fromdate":"5-6-2018",
     "todate":"10-07-2018"
     */
    private func getQueryStateJSON(currentServiceName: String) -> String {
        var queryJSON: [String: Any] = [String: Any]()
        queryJSON["query"] = SearchResultsViewModel.ResultVC.trimmedSearchQuery
        let zuid = SearchResultsViewModel.ResultVC.ZUID ?? -1
        queryJSON["mentioned_zuid"] = zuid
        if (zuid != -1) {
            queryJSON["mentioned_name"] = SearchResultsViewModel.ResultVC.contactName
        }
        
        var filters: [[String: Any]] = [[String: Any]]()
        
        var searchFilters : [String:AnyObject]? = nil
        var dateFilter: FilterModule?
        if currentServiceName != ZOSSearchAPIClient.ServiceNameConstants.All {
            for filter in SearchResultsViewModel.FilterSections
            {
                // If SearchResultviewmodal.filtersection has the filtersearch query then current service has the filters
                if (filter.serviceName == currentServiceName) && (filter.filterSearchQuery != nil)
                {
                    for filterModule in filter.filtersResultArray {
                        if filterModule.filterName == "Date" {
                            dateFilter = filterModule
                        }
                    }
                    searchFilters = filter.filterSearchQuery
                }
            }
        }
        
        //generic code to handle all the filter
        if searchFilters != nil {
            //TODO: Could it be generic for some fields, only for date we add additional data
            var fromDate: String?
            var toDate: String?
            for (key, value) in searchFilters! {
                //only if key is date value will be converted as string
                if (key == "fromdate" || key == "todate") {
                    //only in case of custom_range
                    if (key == "fromdate") {
                        fromDate = value as? String
                    }
                    else {
                        toDate = (value as! String)
                    }
                }
                else {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            
            if (fromDate != nil) {
                var filter: [String: AnyObject] = [String: AnyObject]()
                filter["type"] = "date" as AnyObject
                filter["fromdate"] = fromDate as AnyObject
                filter["todate"] = toDate as AnyObject
                
                //TODO: This has to be changed as currently it is display value
                filter["value"] = dateFilter?.defaultSelectionName as AnyObject
                
                filters.append(filter)
            }
            
        }
        
        /*
        switch currentServiceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            /*
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    if (key == "emailId") {
                        var filter: [String: Any] = [String: Any]()
                        filter["type"] = key
                        filter["value"] = value
                        
                        filters.append(filter)
                    }
                    else if (key == "labelId"){
                        var filter: [String: Any] = [String: Any]()
                        filter["type"] = key
                        filter["value"] = value
                        
                        filters.append(filter)
                    }
                    else if (key == "folderId"){
                        var filter: [String: Any] = [String: Any]()
                        filter["type"] = key
                        filter["value"] = value
                        
                        filters.append(filter)
                    }
                    //add date handling
                }
            }
            */
            break
        
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            /*
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            */
            
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                var fromDate: String?
                var toDate: String?
                for (key, value) in searchFilters! {
                    //only if key is date value will be converted as string
                    if (key == "fromdate" || key == "todate") {
                        //only in case of custom_range
                        if (key == "fromdate") {
                            fromDate = value as! String
                        }
                        else {
                            toDate = value as! String
                        }
                    }
                    else {
                        var filter: [String: Any] = [String: Any]()
                        filter["type"] = key
                        filter["value"] = value
                        
                        filters.append(filter)
                    }
                }
                
                if (fromDate != nil) {
                    var filter: [String: AnyObject] = [String: AnyObject]()
                    filter["type"] = "date" as AnyObject
                    filter["fromdate"] = fromDate as AnyObject
                    filter["todate"] = toDate as AnyObject
                    
                    //TODO: This has to be changed as currently it is display value
                    filter["value"] = dateFilter?.defaultSelectionName as AnyObject
                    
                    filters.append(filter)
                }
                
            }
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            break
        /*
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            if searchFilters != nil {
                //TODO: Could it be generic for some fields, only for date we add additional data
                for (key, value) in searchFilters! {
                    var filter: [String: Any] = [String: Any]()
                    filter["type"] = key
                    filter["value"] = value
                    
                    filters.append(filter)
                }
            }
            break
        */
        default:
            print("Incorrect State")
        }
        */
        
        if filters.count > 0 {
            queryJSON["filters"] = filters
        }
        
        do {
            //let valid = JSONSerialization.isValidJSONObject(queryJSON) // true
            let jsonData = try JSONSerialization.data(withJSONObject: queryJSON, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
            return jsonString
        }
        catch _ {
            print ("JSON Failure")
        }
        
        return ""
    }
    
    @objc func closeAlertDialog(_ sender: Any) {
        alertController?.dismiss(animated: true, completion: nil)
    }
    
    private func fetchRecordsForEntity(_ entity: String, accountZUID: String, savedSearchName: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Create Fetch Request
        let portalPredicate = NSPredicate(format: "account_zuid == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt + " AND saved_search_name ==[c] " + SearchKitConstants.FormatStringConstants.String, accountZUID, savedSearchName )
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.predicate = portalPredicate
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            fatalError("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
}
