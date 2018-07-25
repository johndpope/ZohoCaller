//
//  SearchQueryViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 07/02/18.
//

import UIKit
import CoreData

class SearchQueryViewController:ZSViewController {
    
    @IBOutlet weak var searchbar: QueryVCSearchBar!
    var numberOfContactsRequested = 3
    var numberOfHistoryRequested = 3
    var numberOfSavedSearchesRequested = 3
    
    static func vcInstanceFromStoryboard() -> SearchQueryViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SearchQueryViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? SearchQueryViewController
    }
    var isVoiceSearch = false
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //        ServiceView.layoutIfNeeded()
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        SearchResultsViewModel.searchWhenLoaded = false
        //first hide the keyboard
        self.searchbar.resignFirstResponder()
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
    
    var searchResults = SearchResults(query: "")
    var searchTask: URLSessionDataTask?
    var currentUser: Int64 = Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!
    
    var bundle = Bundle(for: ServiceSuggestionCollectionViewCell.self)
    
    //autosuggest
    @IBOutlet weak var suggestionTableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<UserContacts> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<UserContacts> = UserContacts.fetchRequest()
        
        // Configure Fetch Request
        let usageCountAttribute = #keyPath(UserContacts.usage_count)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: usageCountAttribute, ascending: false)]
        
        //set limit
        fetchRequest.fetchLimit = numberOfContactsRequested //+ 1
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    lazy var histFetchedResultsController: NSFetchedResultsController<SearchHistory> = {
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
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    lazy var savedSearchFetchedResultsController: NSFetchedResultsController<SavedSearches> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SavedSearches> = SavedSearches.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SavedSearches.lmtime), ascending: false)]
        
        //set limit
        fetchRequest.fetchLimit = numberOfSavedSearchesRequested //+ 1
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.suggestionTableView.backgroundColor = .clear
        
        //searchbar divider line
        let topview = view.viewWithTag(100)
        topview?.layer.shadowRadius = 0
        topview?.layer.shadowOpacity = 0.5
        topview?.layer.shadowColor = UIColor.gray.cgColor
        
        
        //autosuggest
        suggestionTableView.delegate = self
        suggestionTableView.dataSource = self
        suggestionTableView.tableFooterView = UIView() //to avoid any unwanted lines in case of empty tableview or so.
        suggestionTableView.register(ContactSuggestionTableViewCell.nib, forCellReuseIdentifier: ContactSuggestionTableViewCell.identifier)
        suggestionTableView.register(HistorySuggestionTableViewCell.nib, forCellReuseIdentifier: HistorySuggestionTableViewCell.identifier)
        suggestionTableView.register(SavedSearchSuggestionTableViewCell.nib, forCellReuseIdentifier: SavedSearchSuggestionTableViewCell.identifier)
        suggestionTableView.register(ServiceSuggestionCell.nib, forCellReuseIdentifier: ServiceSuggestionCell.identifier)
        suggestionTableView.register(SuggestionSectionHeaderCellIOS11.nib, forHeaderFooterViewReuseIdentifier: SuggestionSectionHeaderCellIOS11.identifier)
        suggestionTableView.register(SuggestionFooterTableViewCell.nib, forCellReuseIdentifier: SuggestionFooterTableViewCell.identifier)
        
        //tableview style - grouped -> so that unwanted space from the table topview is removed
        //suggestionTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        //if you are using tableview style plain - use below instead of above one
        suggestionTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) //check height for header which is enough to handle unwanted space
        
        suggestionTableView.keyboardDismissMode = .onDrag
        searchbar.delegate = self
        if !isVoiceSearch
        {
            searchbar.becomeFirstResponder()
            isVoiceSearch = false
        }
        searchbar.text = SearchResultsViewModel.ResultVC.searchText
        
        
        // registering Service cell
        if let resourcePath = bundle.path(forResource: "ZohoSearchKit", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        //        ServiceView.register(UINib(nibName: "MVCell", bundle: bundle), forCellWithReuseIdentifier:"ServiceCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: so that we will hide the tab bar or nav bar if any in the parent app
        //when search related view controller are opened. Same should be reverted in the Application's root view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated) //hide navbar
        //self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true //hide tab bar
        
        //this should handle previous selection
        //instead of handling in completion handler we will handle in viewWillAppear
        //with help of some global constants
        if SearchResultsViewModel.ResultVC.isNewSearch == true
        {
            SearchResultsViewModel.ResultVC.isNewSearch = false
            SearchResultsViewModel.QueryVC.suggestionZUID = -1
            SearchResultsViewModel.QueryVC.suggestionPageSearchText = ""
            SearchResultsViewModel.QueryVC.isAtMensionSelected = false
        }
        else
        {
            SearchResultsViewModel.QueryVC.suggestionContactName = SearchResultsViewModel.ResultVC.contactName
            SearchResultsViewModel.QueryVC.isAtMensionSelected = SearchResultsViewModel.ResultVC.isContactSearch
            
        }
        self.searchbar.text = SearchResultsViewModel.QueryVC.suggestionPageSearchText
        self.searchbar.awakeFromNib()
        if SearchResultsViewModel.QueryVC.suggestionPageSearchText == ""
        {
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = true
        }
        else
        {
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = false
        }
        
        
        var selectedServiceIndex = SearchResultsViewModel.selected_service
        if selectedServiceIndex == -1 {
            selectedServiceIndex = 0
        }
        
    }
    
    //called again and again, so  creating problem
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}

// MARK: Search Query view controller should not change the global state.
//Global state like SearchResultsViewModel.searchText and SearchResultsViewModel.ZUID are means to be used
//in the SearchResultsViewController, and callout. When we edit in Median view controller and don't perform
//search, then global state should not be changed. From Median view controller or ZohoSearchBar - global search query
//state should be changed for only one case - when search button is pressed - that is textFieldShouldReturn/

//autosuggest
extension SearchQueryViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SearchResultsViewModel.QueryVC.suggestionPageSearchText = textField.text ?? "" //SearchResultsViewModel.searchText
        //gained focus going to search if there is some text or will list first few
        searchContacts(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
        searchHistory(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
        searchSavedSearches(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        //MARK:- We should call the textdidchanged method to infrom search bar to changed right view type (either :- voice search or clear button)
        searchbar.textDidChanged(newText : newString)
        SearchResultsViewModel.QueryVC.suggestionPageSearchText = newString
        var contactSearchString = newString
        var contactFetchCount = -1
        //if the latest typed chars contains @
        if newString.contains("@") {
            //if the preceding char of @ is a whitespace, than only search for chars after @. As email address can have @
            let idxOfAt = newString.index(of: "@")
            if idxOfAt != newString.startIndex {
                let previousChar = newString[newString.index(idxOfAt!, offsetBy: -1)]
                if previousChar == " " {
                    let nextCharIndex = newString.index(idxOfAt!, offsetBy: 1)
                    contactSearchString = String(newString[nextCharIndex...])
                    contactFetchCount = 10 //TODO: This can be configurable or fixed constants
                }
            }
            else {
                //when @ is used as the first char to select contact
                let nextCharIndex = newString.index(idxOfAt!, offsetBy: 1)
                contactSearchString = String(newString[nextCharIndex...])
                contactFetchCount = 10 //TODO: This can be configurable or fixed constants
            }
        }
        
        searchContacts(searchString: contactSearchString, fetchCount: contactFetchCount)
        searchHistory(searchString: newString)
        searchSavedSearches(searchString: newString)
        if newString != ""
        {
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = false
        }
        else if SearchResultsViewModel.QueryVC.isAtMensionSelected == true
        {
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = false
        }
        else
        {
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = true
        }
        return true
    }
    
    func searchContacts(searchString: String, fetchCount: Int? = -1) {
        let accountZUIDPredicate = #keyPath(UserContacts.account_zuid)
        
        if fetchCount != -1 {
            self.fetchedResultsController.fetchRequest.fetchLimit = fetchCount!
        }
        else {
            self.fetchedResultsController.fetchRequest.fetchLimit = numberOfContactsRequested
        }
        
        if !searchString.isEmpty {
            let firstNameAttribute = #keyPath(UserContacts.first_name)
            let lastNameAttribute = #keyPath(UserContacts.last_name)
            let emailAttribute = #keyPath(UserContacts.email_address)
            var predicate = NSPredicate(format: firstNameAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String + " OR " + lastNameAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String + " OR " + emailAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String, searchString+"*", searchString+"*", "*"+searchString+"*")
            //adding accounts predicate for multi account support
            let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
            predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate, accountPredicate])
            self.fetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try self.fetchedResultsController.performFetch()
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
                
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        else {
            //so that in case of empty text default list is rendered
            do {
                //reset the predicate to accounts only predicate
                //self.histFetchedResultsController.fetchRequest.predicate = nil
                let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
                self.fetchedResultsController.fetchRequest.predicate = accountPredicate
                
                try self.fetchedResultsController.performFetch()
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    func searchHistory(searchString: String) {
        let selectedUserZUID = SearchResultsViewModel.QueryVC.suggestionZUID
        let accountZUIDPredicate = #keyPath(SearchHistory.account_zuid)
        self.histFetchedResultsController.fetchRequest.fetchLimit = numberOfHistoryRequested
        
        if !searchString.isEmpty || selectedUserZUID != -1 {
            let searchQueryAttribute = #keyPath(SearchHistory.search_query)
            let mentionZUIDPredicate = #keyPath(SearchHistory.mention_zuid)
            var zuids = [Int64]()
            zuids.append(-1)
            if (selectedUserZUID != -1) {
                zuids.append(selectedUserZUID!)
            }
            //if some contact is selected then history including the selected user or no user selection recent searches will be suggested in the ui. Other user mentioned
            //search query will not be displayed.
            var predicate: NSPredicate?
            if selectedUserZUID != -1 {
                //predicate = NSPredicate(format: searchQueryAttribute + " LIKE[c] %@ AND ANY " + mentionZUIDPredicate + " IN %@", searchString+"*", zuids)
                //when search query is empty need not have other condition in the predicate
                //MARK: if you have make sure to pass appropriate data as predicate value
                //if not passesd some strange exception might show up like
                //unrecognized selector sent to instance
                if !searchString.isEmpty {
                    predicate = NSPredicate(format: searchQueryAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String + " AND ANY " + mentionZUIDPredicate + " IN " + SearchKitConstants.FormatStringConstants.String, searchString+"*", zuids)
                }
                else {
                    predicate = NSPredicate(format: "ANY " + mentionZUIDPredicate + " IN " + SearchKitConstants.FormatStringConstants.String, zuids)
                }
            }
            else {
                predicate = NSPredicate(format: searchQueryAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String, searchString+"*")
            }
            
            //adding accounts predicate for multi account support
            let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
            predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate!, accountPredicate])
            //above IN query is the same as saying boolean (search_query like %abc% AND (mention_zuid = -1 OR mention_zuid = 23408090))
            self.histFetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try self.histFetchedResultsController.performFetch()
                
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
                
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        else {
            do {
                //reset the predicate to accounts only predicate
                //self.histFetchedResultsController.fetchRequest.predicate = nil
                let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
                self.histFetchedResultsController.fetchRequest.predicate = accountPredicate
                try self.histFetchedResultsController.performFetch()
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    func searchSavedSearches(searchString: String) {
        let accountZUIDPredicate = #keyPath(SavedSearches.account_zuid)
        self.savedSearchFetchedResultsController.fetchRequest.fetchLimit = numberOfSavedSearchesRequested
        if !searchString.isEmpty {
            let savedSearchNameAttribute = #keyPath(SavedSearches.saved_search_name)
            var predicate = NSPredicate(format: savedSearchNameAttribute + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String, searchString+"*")
            //adding accounts predicate for multi account support
            let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
            predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate, accountPredicate])
            self.savedSearchFetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try self.savedSearchFetchedResultsController.performFetch()
                
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
                
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        else {
            do {
                //reset the predicate to accounts only predicate
                //self.savedSearchFetchedResultsController.fetchRequest.predicate = nil
                let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, currentUser)
                self.savedSearchFetchedResultsController.fetchRequest.predicate = accountPredicate
                try self.savedSearchFetchedResultsController.performFetch()
                performUIUpdatesOnMain {
                    self.suggestionTableView.reloadData()
                }
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    //Not used now, as we have out own method called and own button - ZohoSearchBar
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //SearchResultsViewModel.searchText = ""
        searchContacts(searchString: "")
        searchHistory(searchString: "")
        searchSavedSearches(searchString: "")
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //this whole code will be moved to to extension. First remove unwanted spaces from begininng and end
        //and then remove unwanted white spaces from in between

//        let trimmedSearchQuery = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let regex = try? NSRegularExpression(pattern: "  +", options: .caseInsensitive)
//        let trimmedString: String? = regex?.stringByReplacingMatches(in: trimmedSearchQuery, options: [], range: NSRange(location: 0, length: trimmedSearchQuery.count), withTemplate: " ")
//
//        if !(trimmedString?.isEmpty)! || SearchResultsViewModel.QueryVC.isAtMensionSelected {
//
//            //when query state is searchanble, hide the keyboard and search
//            textField.resignFirstResponder()
//            let currentSelected = SearchResultsViewModel.selected_service
//
//            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
//
//            if let nav = ZohoSearchKit.sharedInstance().appViewController?.navigationController {
//                var stack = nav.viewControllers
//                let vc = stack[stack.count - 1] //just before last one
//                //let index = stack.index(of: vc)
//                if vc is SearchResultsViewController {
//                    //stack.remove(at: stack.count - 1)
//                    //stack.remove(at: stack.count - 1) //pop also the last one
//                    ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
//                }
//                //nav.setViewControllers(stack, animated: true)
//            }
//
//            let target = SearchResultsViewController.vcInstanceFromStoryboard()!
//
//            ZohoSearchKit.sharedInstance().searchViewController = target
//            SearchResultsViewModel.selected_service = currentSelected
//            SearchResultsViewModel.ResultVC.contactName = SearchResultsViewModel.QueryVC.suggestionContactName
//            SearchResultsViewModel.ResultVC.isContactSearch = SearchResultsViewModel.QueryVC.isAtMensionSelected
//            SearchResultsViewModel.ResultVC.ZUID = SearchResultsViewModel.QueryVC.suggestionZUID
//            SearchResultsViewModel.ResultVC.isNamelabledisplay = false
//            SearchResultsViewModel.ResultVC.searchText = textField.text!
//            SearchResultsViewModel.ResultVC.trimmedSearchQuery = (trimmedString?.trimmingCharacters(in: .whitespacesAndNewlines))!
//
//            SearchResultsViewModel.searchWhenLoaded = true
//            target.currentIndex =  SearchResultsViewModel.selected_service
//            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(target, animated: false)
//
//            //TODO: This should be done asynch, so that it does not block the search request and delay
//            //only non empty search will be stored.
//            //only @mention will also be not stored. as per below logic
//            if !(trimmedString?.isEmpty)! {
//                let searchType = UserPrefManager.getServiceNameForIndex(index: SearchResultsViewModel.selected_service)
//                var contactName: String?
//
//                //                if (SearchResultsViewModel.ZUID != -1) {
//                if (SearchResultsViewModel.QueryVC.suggestionZUID != -1) {
//                    contactName = SearchResultsViewModel.QueryVC.suggestionContactName
//                }
//                else {
//                    contactName = ""
//                }
//                //                _ = SearchHistory(mentionedZUID: SearchResultsViewModel.ZUID!, contactName: contactName, resultCount: 0, searchQuery: trimmedString!, searchType: searchType, timestamp: Int64(Date().millisecondsSince1970), userAccountZUID: Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
//                _ = SearchHistory(mentionedZUID: SearchResultsViewModel.QueryVC.suggestionZUID!, contactName: contactName, resultCount: 0, searchQuery: trimmedString!, searchType: searchType, timestamp: Int64(Date().millisecondsSince1970), userAccountZUID: Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!, context: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
//
//            }
//
//            //instead we will save periodically or on notification
//            do {
//                try ZohoSearchKit.sharedInstance().coreDataStack?.saveContext()
//            }
//            catch {
//
//            }
//
//            return true
//        }
//        else {
//            //empty search is not allowed. atleast the user has to select some contact to search
//            SnackbarUtils.showMessageWithDismiss(msg: "Search query is empty")
//        }
        
        ZohoSearchKit.sharedInstance().presentResultVC()
        return false
    }
    
}

//autosuggest
extension SearchQueryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) && SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped == true
        {
            return 1
        }
            
        else if (section == 0) && SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped == false
        {
            return 0
        }
            //        else if section == 0 && SearchResultsViewModel.isAtMensionSelected == true
            //        {
            //            return 0
            //        }
            //        else  if (section == 0) && SearchResultsViewModel.searchText == ""
            //        {
            //            return 1
            //        }
            //        else if (section == 0 )
            //        {
            //            return 0
            //        }
            // hiding contact suggestion
        else if section == 1 && SearchResultsViewModel.QueryVC.isAtMensionSelected == true
        {
            return 0
        }
        else if (section == 1) {
            //return (fetchedResultsController.fetchedObjects?.count)!
            guard fetchedResultsController.sections != nil else {
                return 0
            }
            //first time fetch fetchsize + 1
            //            if (fetchedResultsController.fetchedObjects?.count)! > numberOfContactsRequested {
            //                return (fetchedResultsController.fetchedObjects?.count)! - 1
            //            }
            //            else {
            //                return (fetchedResultsController.fetchedObjects?.count)!
            //            }
            return (fetchedResultsController.fetchedObjects?.count)!
        }
        else if (section == 2) {
            guard histFetchedResultsController.sections != nil else {
                return 0
            }
            
            return (histFetchedResultsController.fetchedObjects?.count)!
        }
        else if (section == 3) {
            guard savedSearchFetchedResultsController.sections != nil else {
                return 0
            }
            
            return (savedSearchFetchedResultsController.fetchedObjects?.count)!
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        switch section {
    //        case 0 :
    //            if SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped {
    //                return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.application", defaultValue: "Applications")
    //            }
    //        case 1:
    //            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
    //                return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.contacts", defaultValue: "Contacts")
    //            }
    //        case 2:
    //            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
    //                return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.recentsearches", defaultValue: "Recent Searches")
    //            }
    //        case 3:
    //            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
    //                return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.savedsearches", defaultValue: "Saved Searches")
    //            }
    //
    //        default:
    //            return nil // when return nil no header will be shown
    //        }
    //
    //        return nil
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SuggestionSectionHeaderCellIOS11.identifier) as! SuggestionSectionHeaderCellIOS11
        var title :String = String()
        switch section {
        case 0 :
            if SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped {
                title =  SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.application", defaultValue: "Applications")
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                title = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.contacts", defaultValue: "Contacts")
            }
        case 2:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                title = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.recentsearches", defaultValue: "Recent Searches")
            }
        case 3:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                title = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.suggestion.savedsearches", defaultValue: "Saved Searches")
            }
            
        default:
            title = "" // when return nil no header will be shown
        }
        
        cell.titleLabel.text = title
        cell.titleLabel.font = ThemeService.sharedInstance().theme.headlineFont
        cell.titleLabel.textColor = ThemeService.sharedInstance().theme.headlineColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // CollectionView - service collection view
        if indexPath.section  == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceSuggestionCell.identifier, for: indexPath) as? ServiceSuggestionCell else {
                fatalError("Unexpected Index Path")
            }
            cell.collectionView.scrollToItem(at: IndexPath(row :SearchResultsViewModel.selected_service ,section : 0), at: .init(rawValue: 0), animated: true)
            cell.collectionView.selectItem(at: IndexPath(row :SearchResultsViewModel.selected_service ,section : 0), animated: false, scrollPosition: .init(rawValue: 0))
            cell.selectionStyle = .none
            return cell
        }
        else if (indexPath.section == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactSuggestionTableViewCell.identifier, for: indexPath) as? ContactSuggestionTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            
            let indexPathComputed = IndexPath(row: indexPath.row, section: 0)
            let contact = fetchedResultsController.object(at: indexPathComputed)
            cell.contact = contact
            
            return cell
        }
        else if (indexPath.section == 2) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistorySuggestionTableViewCell.identifier, for: indexPath) as? HistorySuggestionTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            //We can't directly use the IndexPath with multiple fetchedDataController that why we have translate to different indexpath
            let indexPathComputed = IndexPath(row: indexPath.row, section: 0)
            let history = histFetchedResultsController.object(at: indexPathComputed)
            cell.history = history
            cell.delegate = self
            
            return cell
        }
        else if (indexPath.section == 3) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedSearchSuggestionTableViewCell.identifier, for: indexPath) as? SavedSearchSuggestionTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            //We can't directly use the IndexPath with multiple fetchedDataController that why we have translate to different indexpath
            let indexPathComputed = IndexPath(row: indexPath.row, section: 0)
            let savedSearch = savedSearchFetchedResultsController.object(at: indexPathComputed)
            cell.savedSearch = savedSearch
            
            return cell
        }
        return UITableViewCell()
    }
    
    //this way, we can give low height for the show more row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  && SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped == true || (indexPath.section == 0 && SearchResultsViewModel.ResultVC.searchText == "")
        {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
}

extension SearchQueryViewController: SuggestionViewMoreDelegate {
    func viewMoreTapped(header: SuggestionFooterTableViewCell) {
        if header.sectionType == SuggestionSectionTypes.Contacts {
            numberOfContactsRequested = numberOfContactsRequested + 5
            searchContacts(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
        }
        else if header.sectionType == SuggestionSectionTypes.RecentSearches {
            numberOfHistoryRequested = numberOfHistoryRequested + 5
            searchHistory(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
        }
        else if header.sectionType == SuggestionSectionTypes.SavedSearches {
            numberOfSavedSearchesRequested = numberOfSavedSearchesRequested + 5
            searchSavedSearches(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText)
        }
        
        performUIUpdatesOnMain {
            self.suggestionTableView.reloadData()
        }
    }
    
    /*
     func viewMoreTapped(header: SuggestionFooterTableViewCell) {
     do {
     if header.sectionType == SuggestionSectionTypes.Contacts {
     numberOfContactsRequested = numberOfContactsRequested + 5
     searchContacts(searchString: SearchResultsViewModel.suggestionPageSearchText)
     //self.fetchedResultsController.fetchRequest.fetchLimit = numberOfContactsRequested //+ 1 //(fetchedResultsController.fetchedObjects?.count)! + 5
     //try self.fetchedResultsController.performFetch()
     }
     else if header.sectionType == SuggestionSectionTypes.RecentSearches {
     numberOfHistoryRequested = numberOfHistoryRequested + 5
     searchHistory(searchString: SearchResultsViewModel.suggestionPageSearchText)
     //self.histFetchedResultsController.fetchRequest.fetchLimit = numberOfHistoryRequested //(histFetchedResultsController.fetchedObjects?.count)! + 5
     //try self.histFetchedResultsController.performFetch()
     }
     else if header.sectionType == SuggestionSectionTypes.SavedSearches {
     numberOfSavedSearchesRequested = numberOfSavedSearchesRequested + 5
     searchSavedSearches(searchString: SearchResultsViewModel.suggestionPageSearchText)
     //self.savedSearchFetchedResultsController.fetchRequest.fetchLimit = numberOfSavedSearchesRequested //(savedSearchFetchedResultsController.fetchedObjects?.count)! + 5
     //try self.savedSearchFetchedResultsController.performFetch()
     }
     
     performUIUpdatesOnMain {
     self.suggestionTableView.reloadData()
     }
     
     } catch {
     let fetchError = error as NSError
     print("\(fetchError), \(fetchError.localizedDescription)")
     }
     }
     */
}

//autosuggest
extension SearchQueryViewController: UITableViewDelegate {
    
    //remove unanted space from bottom of the tableview or section
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
            if self.tableView(tableView, numberOfRowsInSection: section) >= numberOfContactsRequested {
                //if (fetchedResultsController.fetchedObjects?.count)! > 3 {
                //return UITableViewAutomaticDimension
                return 30
            }
        }
        else if section == 2 {
            if self.tableView(tableView, numberOfRowsInSection: section) >= numberOfHistoryRequested {
                return 30
            }
        }
        else if section == 3 {
            if self.tableView(tableView, numberOfRowsInSection: section) >= numberOfSavedSearchesRequested {
                return 30
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 0.00001
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 50
        }
        return CGFloat.leastNormalMagnitude
    }
    
    //footer view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //first section that is the service section footer view should be empty
        if (section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionFooterTableViewCell.identifier) as? SuggestionFooterTableViewCell
            cell?.sectionType = SuggestionSectionTypes.Contacts
            cell?.delegate = self
            return cell
        }
        else if (section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionFooterTableViewCell.identifier) as? SuggestionFooterTableViewCell
            cell?.sectionType = SuggestionSectionTypes.RecentSearches
            cell?.delegate = self
            return cell
        }
        else if (section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionFooterTableViewCell.identifier) as? SuggestionFooterTableViewCell
            cell?.sectionType = SuggestionSectionTypes.SavedSearches
            cell?.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 1 {
            //self.searchbar.isclearButtonTapped() //creates problem when selecting contact by typing @ in the search query box
            //passing contact icon data
            let cell = tableView.cellForRow(at: indexPath) as! ContactSuggestionTableViewCell
                SearchResultsViewModel.QueryVC.suggestionContactName = cell.contactsName.text!
                SearchResultsViewModel.QueryVC.isAtMensionSelected = true
                SearchResultsViewModel.QueryVC.isNamelabledisplay = false
                SearchResultsViewModel.QueryVC.suggestionZUID = cell.contact?.contact_zuid
                SearchResultsViewModel.QueryVC.suggestionContactName = (cell.contact?.first_name)! + " " + (cell.contact?.last_name)!
                self.searchbar.awakeFromNib() //refreshing searchbar
                
                if let textField = searchbar {
                    //if keyboard is not shown, then show the keyboard after appending the history search query
                    if !textField.isFirstResponder {
                        textField.becomeFirstResponder()
                    }
                }
            let searchText = SearchResultsViewModel.QueryVC.suggestionPageSearchText
            if searchText.range(of:" @") != nil {
                let idxOfAt = searchText.index(of: "@")
                let prevCharIndex = searchText.index(idxOfAt!, offsetBy: -1)
                let previousChar = searchText[prevCharIndex]
                if previousChar == " " {
                    let searchStr = String(searchText[..<prevCharIndex])
                    self.searchbar.text = searchStr + " "
                }
            }
            else {
                self.searchbar.text = ""
            }
            
            SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = false
            textFieldDidBeginEditing(self.searchbar)
            self.suggestionTableView.reloadData()
        }
        else if section == 2 {
            //MARK: very very important - this is the root cause, when this is done it is calling search history
            //again and this is reseting the data receieved from the db as it is searching
            //for empty string, so, if we need to change some data, we should do it here.
            //self.searchbar.isclearButtonTapped()
            var cell = tableView.cellForRow(at: indexPath) as? HistorySuggestionTableViewCell
            //MARK: Important - This cell can be nil when we have user selected for @mention and when we do view more in the history
            //suggestion and select one from the last or so. Reason being those cells can be out of view even though
            //visible, it might not have cleared the older cells.
            
            if cell == nil {
                let indexPathComputed = IndexPath(row: indexPath.row, section: 0)
                cell = tableView.dequeueReusableCell(withIdentifier: HistorySuggestionTableViewCell.identifier, for: indexPath) as? HistorySuggestionTableViewCell
                let history = histFetchedResultsController.object(at: indexPathComputed)
                cell?.history = history
                cell?.delegate = self
            }
            let searchQueryAttribute = #keyPath(SearchHistory.search_query)
            self.searchbar.text = (cell?.history?.value(forKey: searchQueryAttribute))! as? String
            
            SearchResultsViewModel.QueryVC.suggestionPageSearchText = self.searchbar.text!
            
            let mentionZUIDAttribute = #keyPath(SearchHistory.mention_zuid)
            if let zuid = (cell?.history?.value(forKey: mentionZUIDAttribute) as? Int64), zuid != -1 {
                SearchResultsViewModel.QueryVC.suggestionContactName = (cell?.userName.text!)!
                SearchResultsViewModel.QueryVC.isAtMensionSelected = true
                SearchResultsViewModel.QueryVC.isNamelabledisplay = false
                SearchResultsViewModel.QueryVC.suggestionZUID = zuid
                
                //first reload the contact button. as name is displayed only after clicking on it. So, it is better to render contact image and then store other details like
                //contact name
                self.searchbar.awakeFromNib() //refreshing searchbar
                
                self.searchbar.text = (cell?.history?.value(forKey: searchQueryAttribute))! as? String
                let contactNameAttribute = #keyPath(SearchHistory.mention_contact_name)
                SearchResultsViewModel.QueryVC.suggestionContactName = (cell?.history?.value(forKey: contactNameAttribute) as? String)!
                
            }
            else {
                SearchResultsViewModel.QueryVC.isNamelabledisplay = false
                SearchResultsViewModel.QueryVC.isAtMensionSelected = false
                SearchResultsViewModel.QueryVC.suggestionContactName = ""
                SearchResultsViewModel.QueryVC.suggestionZUID = -1
                self.searchbar.awakeFromNib() //refreshing searchbar
            }
            
            if let textField = searchbar, let textFieldDelegate = textField.delegate {
                if textFieldDelegate.textFieldShouldReturn!(textField) {
                    textField.endEditing(true)
                }
            }
        }
        else if section == 3 {
            //TODO: this clear can be an issue, if any state need to be cleared
            //then clear it here. clearing the search box and reseting state
            //is not same as clearing state for selection of suggestion clearing state
            //self.searchbar.isclearButtonTapped()
            var cell = tableView.cellForRow(at: indexPath) as? SavedSearchSuggestionTableViewCell
            //MARK: Important - This cell can be nil when we have user selected for @mention and when we do view more in the history or saved search
            //suggestion and select one from the last or so. Reason being those cells can be out of view even though
            //visible, it might not have cleared the older cells.
            if cell == nil {
                let indexPathComputed = IndexPath(row: indexPath.row, section: 0)
                cell = tableView.dequeueReusableCell(withIdentifier: SavedSearchSuggestionTableViewCell.identifier, for: indexPath) as? SavedSearchSuggestionTableViewCell
                let savedSearch = savedSearchFetchedResultsController.object(at: indexPathComputed)
                cell?.savedSearch = savedSearch
            }
            if let cell = cell
            {
                FilterVCHelper.sharedInstance().ConvertDataAndPresentResultVC(from: cell.savedSearch!)
            }
            //cell will be used when we support saved searches search from suggestion tap
            //SnackbarUtils.showMessageWithDismiss(msg: "Not supported yet!")
        }
        
        //deselect after operation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//Append history to the search box
extension SearchQueryViewController: HistorySuggestionViewCellDelegate {
    func didTapAppendHistory(_ sender: HistorySuggestionTableViewCell) {
        //append extra space at the end of the search query
        let searchQueryAttribute = #keyPath(SearchHistory.search_query)
        let searchQuery = ((sender.history?.value(forKey: searchQueryAttribute))! as? String)! + " "
        self.searchbar.text = searchQuery
        let mentionZUIDAttribute = #keyPath(SearchHistory.mention_zuid)
        if let zuid = (sender.history?.value(forKey: mentionZUIDAttribute) as? Int64), zuid != -1 {
            
            SearchResultsViewModel.QueryVC.suggestionContactName = sender.userName.text!
            SearchResultsViewModel.ResultVC.isContactSearch = true
            SearchResultsViewModel.QueryVC.isAtMensionSelected = true
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            SearchResultsViewModel.QueryVC.suggestionZUID = zuid
            self.searchbar.awakeFromNib() //refreshing searchbar
            
            let contactNameAttribute = #keyPath(SearchHistory.mention_contact_name)
            SearchResultsViewModel.QueryVC.suggestionContactName = (sender.history?.value(forKey: contactNameAttribute) as? String)!
        }
        else {
            if !SearchResultsViewModel.QueryVC.isAtMensionSelected {
                SearchResultsViewModel.QueryVC.suggestionContactName = ""
            }
        }
        
        if let textField = searchbar, let textFieldDelegate = textField.delegate {
            let range: NSRange = NSMakeRange(0, searchQuery.count)
            _ = textFieldDelegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: searchQuery)
            //if keyboard is not shown, then show the keyboard after appending the history search query
            if !textField.isFirstResponder {
                textField.becomeFirstResponder()
            }
        }
    }
}

//autosuggest
extension SearchQueryViewController: NSFetchedResultsControllerDelegate {
    
    /*
     //does not get triggered automatically
     func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     contactsSuggestion.beginUpdates()
     }
     
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     contactsSuggestion.endUpdates()
     }
     
     //might not be needed
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     switch (type) {
     case .insert:
     if let indexPath = newIndexPath {
     contactsSuggestion.insertRows(at: [indexPath], with: .fade)
     }
     break;
     case .delete:
     if let indexPath = indexPath {
     contactsSuggestion.deleteRows(at: [indexPath], with: .fade)
     }
     break;
     case .update:
     if let indexPath = indexPath, let cell = contactsSuggestion.cellForRow(at: indexPath) {
     //configureCell(cell, at: indexPath)
     }
     break;
     case .move:
     if let indexPath = indexPath {
     contactsSuggestion.deleteRows(at: [indexPath], with: .fade)
     }
     
     if let newIndexPath = newIndexPath {
     contactsSuggestion.insertRows(at: [newIndexPath], with: .fade)
     }
     break;
     }
     }
     */
}
