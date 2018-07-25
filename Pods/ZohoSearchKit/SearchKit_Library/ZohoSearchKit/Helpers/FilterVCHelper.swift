//
//  FilterVCHelper.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 17/07/18.
//

import Foundation
class FilterVCHelper
{
    public class func sharedInstance() -> FilterVCHelper {
        struct Singleton {
            static var sharedInstance = FilterVCHelper()
        }
        return Singleton.sharedInstance
    }
    func resetWIkiPortals(filterModal : FilterResultViewModel, selected_Filter : String)
    {
        for filter in (filterModal.filtersResultArray)
        {
            let portalName = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.Modules.portals, defaultValue: FilterConstants.Module.WikiModules.Portals)
            //MARk:- Dont Use filter Display value for conditional check
            if filter.filterName == portalName
            {
                let wikitypeIndex = Int((filter.filterNameServerValuePairs?[selected_Filter])!)!
                // wikitype index :- 1 = mywiki , 2= subscribed wikis
                let allwikiPortals = ResultVCSearchBar.fetchWikiPortals(wikiType: wikitypeIndex)
                var defaultName = String()
                var defaultValue = String()
                var filterNames = [String]()
                {
                    // assuming :- First value in filternames is default one
                    didSet{
                        
                        if  filterNames.count > 0 && defaultName == String()// to get the first value
                        {
                            defaultName = filterNames.first!
                        }
                    }
                }
                var filterNameServerValuePairs = [String : String]()
                {
                    // assuming :- First value in filternames is default one
                    didSet{
                        if filterNames.count > 0 && defaultValue == String()
                        {
                            defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                        }
                    }
                }
                if let wikiportals = allwikiPortals
                {
                    for portal in wikiportals {
                        filterNames.append(portal.wiki_name!)
                        filterNameServerValuePairs[portal.wiki_name!] =
                            String(portal.wiki_id)
                        
                        if portal.is_default {
                            defaultName = portal.wiki_name!
                            defaultValue = String(portal.wiki_id)
                        }
                    }
                }
                filter.selectedFilterName = defaultName
                filter.selectedFilterServerValue = defaultValue
                if filterNames.count == 0
                {
                    filter.selectedFilterServerValue = ""
                    filter.selectedFilterName = "You have no portals here"
                }
                filter.filtersBackUp = filterNames
                filter.filterNameServerValuePairs = filterNameServerValuePairs
                filter.searchResults = filterNames
            }
        }
    }
    func resetBackToDefaultState(filterResultModal : FilterResultViewModel)
    {
        for filterModule in filterResultModal.filtersResultArray
        {
            if filterModule.filterViewType == .dropDownView && ((filterModule.filtersBackUp?.count)! > 0)
            {
                if filterModule.filterName == FilterConstants.Module.MailModules.ACCOUNT && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail// Mail Account
                {
                    //MARK:- In mail filterkeyvalue pair  account id is value ,account mailid is key ,eg; key is mkd@gmail.com and value is 902151234 ,but in server side key is emailID and Value is mkd@gmail.com .In other service we use 902151234 has server value.account id (902151234) will be required for reseting folders and tags when account was changed.
                    let defaultAccountEmailId :Int64 = Int64(filterModule.filterNameServerValuePairs![filterModule.defaultSelectionName!]!)!
                    if ( filterModule.selectedFilterName != filterModule.defaultSelectionName)
                    {
                        FilterVCHelper.sharedInstance().resetFoldersAndTagsForMail(filterModal: filterResultModal, defaultAccountEmailId: defaultAccountEmailId, selected_Filter: filterModule.defaultSelectionName!)
                    }
                }
                else if filterModule.filterName == FilterConstants.Module.WikiModules.Wiki_Types && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki
                {
                    FilterVCHelper.sharedInstance().resetWIkiPortals(filterModal: filterResultModal, selected_Filter: (filterModule.filtersBackUp?[0])!)
                }
                else if  filterModule.filterName == FilterConstants.Module.DeskModules.PORTAL && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk
                {
                    // getting selected Portal Id
                    let defaultPortalId :Int64  = Int64( filterModule.filterNameServerValuePairs![(filterModule.filtersBackUp?[0])!]!)!
                    FilterVCHelper.sharedInstance().reSetDeskDepartmentAndModules(filterModal: filterResultModal, defaultPortalId: defaultPortalId)
                }
                else if filterModule.filterName == FilterConstants.Module.MailModules.DATE
                {
                    filterModule.selectedFilterServerValue_2 = filterModule.defaultSelectionServerValue_2
                }
                filterModule.selectedFilterName = filterModule.defaultSelectionName
                filterModule.selectedFilterServerValue = filterModule.defaultSelectionServerValue
            }
            else  if filterModule.filterViewType == .segmentedView
            {
                filterModule.sortBYFIlterSelectedIndex = filterModule.sortByFilterDefultIndex
            }
            else if filterModule.filterViewType == .flagView
            {
                filterModule.CheckBoxSelectedStatus = filterModule.CheckBoxDefaultStatus
            }
        }
    }
    func reSetDeskDepartmentAndModules(filterModal : FilterResultViewModel,defaultPortalId :Int64,tableView : UITableView? = nil )
    {
        
        for filter in (filterModal.filtersResultArray)
        {
            if filter.filterName == FilterConstants.Module.DeskModules.DEPARTMENT
            {
                if let deskDepartments = ResultVCSearchBar.fetchDeskDepartmentsForPortal(portalID: defaultPortalId)
                {
                    //MARK:- there is no data in data base for departments .if so ,we have we have to use following line
                    //                               (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Desk.loadPlistfile( withModulei18Nkey: FilterConstants.i18NKeys.desk.department, defaulti18NName: FilterConstants.DisPlayValues.Desk.All_MODULES)
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    for department in deskDepartments {
                        filterNames.append(department.dept_name!)
                        filterNameServerValuePairs[department.dept_name!] =
                            String(department.dept_id)
                    }
                    
                    filter.selectedFilterName = defaultName
                    filter.selectedFilterServerValue = defaultValue
                    filter.searchResults = filterNames
                    filter.filtersBackUp = filter.searchResults
                    filter.filterNameServerValuePairs = filterNameServerValuePairs
                }
                break
            }
        }
        
        //Updating Modules
        for (section,filter) in (filterModal.filtersResultArray.enumerated())
        {
            if filter.filterName == FilterConstants.Module.DeskModules.MODULES
            {
                //this we should have as callback so that we can have some activity indicator and stop when successfully fetched
                //in some cases we have the data in the db itself but then also we can have common call back mechanism
                //TODO: Desk activity indicator is showing wrongly in Portal header itself, it should show in the
                //header of module which we are fetching
                var searchableHeader: FilterVCListViewTitleWithSearchBar?
                var filterHeader: FilterVCListViewTitle?
                if let tableView = tableView
                {
                    if tableView.numberOfRows(inSection: section) > SearchResultsViewModel.ResultVC.searchBarThreshold {
                        searchableHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitleWithSearchBar
                        performUIUpdatesOnMain {
                            searchableHeader?.activityIndicator.isHidden = false
                            searchableHeader?.activityIndicator.startAnimating()
                        }
                    }
                    else {
                        filterHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitle
                        performUIUpdatesOnMain {
                            filterHeader?.activityIndicator.isHidden = false
                            filterHeader?.activityIndicator.startAnimating()
                        }
                    }
                }
                var defaultName = String()
                var defaultValue = String()
                var filterNames = [String]()
                {
                    // assuming :- First value in filternames is default one
                    didSet{
                        
                        if  filterNames.count > 0 && defaultName == String()// to get the first value
                        {
                            defaultName = filterNames.first!
                        }
                    }
                }
                var filterNameServerValuePairs = [String : String]()
                {
                    // assuming :- First value in filternames is default one
                    didSet{
                        if filterNames.count > 0 && defaultValue == String()
                        {
                            defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                        }
                    }
                }
                CoreDataQueryUtil.fetchDeskModulesForPortal(portalID: defaultPortalId) { (deskModuleData, error) in
                    //MARK:- Allfolders in plist file so we are loading it now
                    (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Desk.loadPlistfile( withModulei18Nkey: FilterConstants.i18NKeys.desk.Modules.modules, defaulti18NName: FilterConstants.DisPlayValues.Desk.All_MODULES)
                    //Loading remoaing modules
                    if let deskModules = deskModuleData as? [DeskModules] {
                        for module in deskModules {
                            filterNames.append(module.module_name!)
                            filterNameServerValuePairs[module.module_name!] =
                                String(module.module_id)
                        }
                    }
                    filter.selectedFilterServerValue = defaultValue
                    filter.selectedFilterName = defaultName
                    
                    filter.searchResults = filterNames
                    filter.filtersBackUp = filter.searchResults
                    filter.filterNameServerValuePairs = filterNameServerValuePairs
                    performUIUpdatesOnMain {
                        if let _ = tableView
                        {
                            searchableHeader?.activityIndicator.isHidden = true
                            searchableHeader?.activityIndicator.stopAnimating()
                            filterHeader?.activityIndicator.isHidden = true
                            filterHeader?.activityIndicator.stopAnimating()
                        }
                    }
                }
                break
            }
        }
    }
    func resetFoldersAndTagsForMail(filterModal : FilterResultViewModel,defaultAccountEmailId : Int64,selected_Filter : String,tableView : UITableView? = nil)
    {
        for (section,filter) in ((filterModal.filtersResultArray).enumerated())
        {
            var defaultName = String()
            var defaultValue = String()
            var filterNames = [String]()
            {
                // assuming :- First value in filternames is default one
                didSet{
                    if  filterNames.count > 0 && defaultName == String()// to get the first value
                    {
                        defaultName = filterNames.first!
                    }
                }
            }
            var filterNameServerValuePairs = [String : String]()
            {
                // assuming :- First value in filternames is default one
                didSet{
                    if filterNames.count > 0 && defaultValue == String()
                    {
                        defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                    }
                }
            }
            
            if filter.filterName == FilterConstants.Module.MailModules.FOLDERS
            {
                var searchableHeader: FilterVCListViewTitleWithSearchBar?
                var filterHeader: FilterVCListViewTitle?
                if let tableView = tableView
                {
                    if (tableView.numberOfRows(inSection: section)) > SearchResultsViewModel.ResultVC.searchBarThreshold {
                        searchableHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitleWithSearchBar
                        performUIUpdatesOnMain {
                            searchableHeader?.activityIndicator.isHidden = false
                            searchableHeader?.activityIndicator.startAnimating()
                        }
                    }
                    else {
                        filterHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitle
                        performUIUpdatesOnMain {
                            filterHeader?.activityIndicator.isHidden = false
                            filterHeader?.activityIndicator.startAnimating()
                        }
                    }
                }
                //loading default value allfolder from plist file and other if available
                (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile( withModulei18Nkey: FilterConstants.i18NKeys.mail.Modules.folder, defaulti18NName: FilterConstants.DisPlayValues.Mail.ALL_FOLDERS)
                
                CoreDataQueryUtil.fetchMailFoldersForAccount(mailAccountID: defaultAccountEmailId, emailID: selected_Filter) {(mailFoldersData, error) in
                    if let mailFolders = mailFoldersData as? [MailAcntFolders] {
                        
                        for folder in mailFolders {
                            filterNames.append(folder.folder_name!)
                            filterNameServerValuePairs[folder.folder_name!] =
                                String(folder.folder_id)
                        }
                        filter.selectedFilterServerValue = defaultValue
                        filter.selectedFilterName = defaultName
                        
                        filter.filtersBackUp = filterNames
                        filter.searchResults = filterNames
                        filter.filterNameServerValuePairs = filterNameServerValuePairs
                        performUIUpdatesOnMain {
                            if let _ = tableView
                            {
                                searchableHeader?.activityIndicator.isHidden = true
                                searchableHeader?.activityIndicator.stopAnimating()
                                filterHeader?.activityIndicator.isHidden = true
                                filterHeader?.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
            
            if filter.filterName == FilterConstants.Module.MailModules.TAGS
            {
                var searchableHeader: FilterVCListViewTitleWithSearchBar?
                var filterHeader: FilterVCListViewTitle?
                if let tableView = tableView
                {
                    if tableView.numberOfRows(inSection: section) > SearchResultsViewModel.ResultVC.searchBarThreshold {
                        searchableHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitleWithSearchBar
                        performUIUpdatesOnMain {
                            searchableHeader?.activityIndicator.isHidden = false
                            searchableHeader?.activityIndicator.startAnimating()
                        }
                    }
                    else {
                        filterHeader = tableView.headerView(forSection: section) as? FilterVCListViewTitle
                        performUIUpdatesOnMain {
                            filterHeader?.activityIndicator.isHidden = false
                            filterHeader?.activityIndicator.startAnimating()
                        }
                    }
                }
                
                
                
                //loading default value = alltags from plist file and other values if available
                (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile( withModulei18Nkey:FilterConstants.i18NKeys.mail.Modules.tags , defaulti18NName: FilterConstants.DisPlayValues.Mail.ALL_TAGS)
                
                CoreDataQueryUtil.fetchMailTagsForAccount(mailAccountID: defaultAccountEmailId, emailID: selected_Filter) { (mailTagsData, error) in
                    if let mailTags = mailTagsData as? [MailAcntTags] {
                        
                        for tag in mailTags {
                            filterNames.append(tag.tag_name!)
                            filterNameServerValuePairs[tag.tag_name!] =
                                String(tag.tag_id)
                        }
                        filter.selectedFilterServerValue = defaultValue
                        filter.selectedFilterName = defaultName
                        filter.filtersBackUp = filterNames
                        filter.searchResults = filterNames
                        filter.filterNameServerValuePairs = filterNameServerValuePairs
                        performUIUpdatesOnMain {
                            if let _ = tableView
                            {
                                searchableHeader?.activityIndicator.isHidden = true
                                searchableHeader?.activityIndicator.stopAnimating()
                                filterHeader?.activityIndicator.isHidden = true
                                filterHeader?.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
    }
    func resetService(filterResultModal : FilterResultViewModel)
    {
        for filterModule in (filterResultModal.filtersResultArray) {
            if filterModule.filterViewType == .dropDownView && ((filterModule.filtersBackUp?.count)! > 0)
            {
                if filterModule.filterName == FilterConstants.Module.MailModules.ACCOUNT && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail// Mail Account
                {
                    //MARK:- In mail filterkeyvalue pair  account id is value ,account mailid is key ,eg; key is mkd@gmail.com and value is 902151234 ,but in server side key is emailID and Value is mkd@gmail.com .In other service we use 902151234 has server value.account id (902151234) will be required for reseting folders and tags when account was changed.
                    
                    filterModule.selectedFilterName = filterModule.filtersBackUp?[0]
                    filterModule.defaultSelectionName = filterModule.filtersBackUp?[0]
                    filterModule.defaultSelectionServerValue = filterModule.filtersBackUp?[0]
                    filterModule.selectedFilterServerValue = filterModule.filtersBackUp?[0]
                    
                    //MARK:- resetting mail folders and tags
                    //MARK:- Mail , Desk , WIki has deep Linked Modules ,eg;If mail account changes we have to reset folders and tags module according to the mail account.
                    let defaultAccountEmailId :Int64 = Int64(filterModule.filterNameServerValuePairs![(filterModule.filtersBackUp?[0])!]!)!
                    let selected_Filter = filterModule.filtersBackUp?[0]
                    resetFoldersAndTagsForMail(filterModal: filterResultModal, defaultAccountEmailId: defaultAccountEmailId, selected_Filter: selected_Filter!)
                }
                else
                {
                    filterModule.selectedFilterName = filterModule.filtersBackUp?[0]
                    filterModule.defaultSelectionName = filterModule.filtersBackUp?[0]
                    filterModule.defaultSelectionServerValue = filterModule.filterNameServerValuePairs![(filterModule.filtersBackUp?[0])!]
                    filterModule.selectedFilterServerValue = filterModule.filterNameServerValuePairs![(filterModule.filtersBackUp?[0])!]
                    
                    
                    // MARK:- Desk and Wiki has intraLinked modules ,eg; when desk portal changes department should be reseted based on portal.
                    //Issue:- When we are reloading values in other module the selected state in that modal will be lost , If reloading happpen at beggining we dont have ploblem but filtervalues is in dictionary formate,the order is not defined.
                    if filterModule.filterName == FilterConstants.Module.WikiModules.Wiki_Types && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki
                    {
                        resetWIkiPortals(filterModal: filterResultModal, selected_Filter: (filterModule.filtersBackUp?[0])!)
                    }
                    else if  filterModule.filterName == FilterConstants.Module.DeskModules.PORTAL && filterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk
                    {
                        // getting selected Portal Id
                        
                        let defaultPortalId :Int64  = Int64( filterModule.filterNameServerValuePairs![(filterModule.filtersBackUp?[0])!]!)!
                        reSetDeskDepartmentAndModules(filterModal: filterResultModal, defaultPortalId: defaultPortalId)
                    }
                }
            }
            else if filterModule.filterViewType == .segmentedView
            {
                filterModule.sortByFilterDefultIndex = 0
                filterModule.sortBYFIlterSelectedIndex = 0
            }
            else if filterModule.filterViewType == .flagView
            {
                filterModule.CheckBoxDefaultStatus = false
                filterModule.CheckBoxSelectedStatus = false
            }
        }
    }
    func ConvertDataAndPresentResultVC(from savedSearchObject : SavedSearches  )
    {
        let jsonString = savedSearchObject.query_state_json
        let jsonData = jsonString?.data(using: .utf8)
        let dictionary:[String: AnyObject] = try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [String : AnyObject]
        
        //self.searchbar.text = dictionary["query"] as! String
        let currentServiceName = savedSearchObject.service_name
        let zuid = dictionary["mentioned_zuid"] as! Int64
        if zuid != -1 {
            
            //TODO: When we add fetch logic for more contacts from server and save a search
            //it will not be there in the DB that time how name will be set
            //                do {
            //                    let fetchRequest : NSFetchRequest<UserContacts> = UserContacts.fetchRequest()
            //                    let mentionZUIDAttribute = #keyPath(UserContacts.contact_zuid)
            //                    fetchRequest.predicate = NSPredicate(format: mentionZUIDAttribute + " == " + SearchKitConstants.FormatStringConstants.LongUnsignedInt , zuid)
            //                    let fetchedResults = try (ZohoSearchKit.sharedInstance().coreDataStack?.context)!.fetch(fetchRequest)
            //                    if let aContact = fetchedResults.first {
            //                        SearchResultsViewModel.QueryVC.suggestionContactName = aContact.first_name! + " " + aContact.last_name!
            //                    }
            //                }
            //                catch {
            //                    print ("fetch task failed", error)
            //                }
            
            SearchResultsViewModel.QueryVC.suggestionContactName = dictionary["mentioned_name"] as? String ?? ""
            
            //SearchResultsViewModel.QueryVC.suggestionContactName = "Temp, need to store"
            //TODO: the seach box should use contact zuid to fetch the image
            //This means it will be better to save the contact name itself while saving the search query
            SearchResultsViewModel.QueryVC.isAtMensionSelected = true
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            SearchResultsViewModel.QueryVC.suggestionZUID = zuid
            
            //first reload the contact button. as name is displayed only after clicking on it. So, it is better to render contact image and then store other details like
            //contact name
            //self.searchbar.awakeFromNib() //refreshing searchbar
            
            //self.searchbar.text = dictionary["query"] as? String
        }
        else {
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            SearchResultsViewModel.QueryVC.isAtMensionSelected = false
            SearchResultsViewModel.QueryVC.suggestionContactName = ""
            SearchResultsViewModel.QueryVC.suggestionZUID = -1
            //self.searchbar.awakeFromNib() //refreshing searchbar
        }
        
        //populate filter view model
        var filterViewModelForService: FilterResultViewModel? = nil
        if currentServiceName != ZOSSearchAPIClient.ServiceNameConstants.All {
            
            for filter in SearchResultsViewModel.FilterSections
            {
                //as the filter using iterator is immutable
                //var filter = filter
                
                // If SearchResultviewmodal.filtersection has the filtersearch query then current service has the filters
                if (filter.serviceName == currentServiceName)
                {
                    //filter.filterSearchQuery = searchFilters
                    //TODO: update the current selection for individual selection
                    filterViewModelForService = filter
                }
            }
        }
        
        if (filterViewModelForService == nil) {
            filterViewModelForService = ResultVCSearchBar.createFilterViewModelForCurrentService(service: currentServiceName!)
            SearchResultsViewModel.FilterSections.append(filterViewModelForService!)
        }
        // Reset previous values
        if filterViewModelForService != nil
        {
            resetService(filterResultModal: filterViewModelForService!)
        }
        
        var orderedFilters =  [Int: [String: AnyObject]]()
        if let filters = dictionary["filters"] as? [[String: AnyObject]] {
            var i = 1
            for filter in filters {
                let filterKey = filter["type"] as? String
                if (filterKey == FilterConstants.Keys.MailFilterKeys.EMAIL_ID &&
                    currentServiceName == ZOSSearchAPIClient.ServiceNameConstants.Mail) ||
                    (filterKey == FilterConstants.Keys.DeskFilterKeys.PORTALID &&
                        currentServiceName == ZOSSearchAPIClient.ServiceNameConstants.Desk) ||
                    (filterKey == FilterConstants.Keys.WikiFilterKeys.WIKIID &&
                        currentServiceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki)
                {
                    // MARK:- dictionary will  sort the  data based on key
                    orderedFilters[0] = filter
                }
                else
                {
                    orderedFilters[i] = filter
                    i = i + 1
                }
            }
        }
        //  ascending  order sort by key
        let ascendingSortedFilter = orderedFilters.sorted(by: { $0.key < $1.key })
        if let _ =  dictionary["filters"] as? [[String: AnyObject]]
        {
            //filters is set, set the filter from the saved search object
            var searchFilters: [String:AnyObject] = [String: AnyObject]()
            for ordfilter in ascendingSortedFilter {
                let filter = ordfilter.value
                let filterKey = filter["type"] as! String
                let filterValue = filter["value"]
                
                if (filterKey == "date") {
                    //it should be filter key not dipslay value
                    let value: String = (filterValue as! String)
                    if (value == "Today") {
                        searchFilters["fromdate"] = Date.currentDay as AnyObject
                        searchFilters["todate"] = Date.today as AnyObject
                    }
                    else if (value == "Yesterday"){
                        searchFilters["fromdate"] = Date.yesterday as AnyObject
                        searchFilters["todate"] = Date.yesterday as AnyObject
                    }
                    else
                    {
                        searchFilters["fromdate"] =  filter["fromdate"] as AnyObject
                        searchFilters["todate"] =  filter["todate"] as AnyObject
                    }
                    //TODO: add for other like this month, this year
                    for filterModule in (filterViewModelForService?.filtersResultArray)! {
                        if filterModule.filterName == FilterConstants.Module.MailModules.DATE
                        {
                            if filterModule.filterViewType == .dropDownView
                            {
                                filterModule.defaultSelectionName = value
                                filterModule.selectedFilterName = value
                                filterModule.filterServerKey = FilterConstants.Keys.DateFilterKeys.FROM_DATE
                                filterModule.filterServerKey_2 = FilterConstants.Keys.DateFilterKeys.TO_DATE
                                filterModule.defaultSelectionServerValue = searchFilters["fromdate"] as? String
                                filterModule.defaultSelectionServerValue_2 = searchFilters["todate"] as? String
                                filterModule.selectedFilterServerValue = searchFilters["fromdate"] as? String
                                filterModule.selectedFilterServerValue_2 = searchFilters["todate"] as? String
                            }
                        }
                    }
                }
                else {
                    searchFilters[filterKey] = filterValue as AnyObject
                    for filterModule in (filterViewModelForService?.filtersResultArray)! {
                        if filterModule.filterServerKey == filterKey
                        {
                            if filterModule.filterViewType == .dropDownView
                            {
                                for (filterKeyValuePair) in filterModule.filterNameServerValuePairs!
                                {
                                    if filterKeyValuePair.key == filterValue as? String && filterModule.filterName == FilterConstants.Module.MailModules.ACCOUNT// Mail Account
                                    {
                                        //MARK:- In mail filterkeyvalue pair  account id is value ,account mailid is key ,eg; key is mkd@gmail.com and value is 902151234 ,but in server side key is emailID and Value is mkd@gmail.com .In other service we use 902151234 has server value.account id (902151234) will be required for reseting folders and tags when account was changed.
                                        filterModule.selectedFilterName = filterValue as? String
                                        filterModule.defaultSelectionName = filterValue as? String
                                        filterModule.defaultSelectionServerValue = filterValue as? String
                                        filterModule.selectedFilterServerValue = filterValue as? String
                                        
                                        //MARK:- resetting mail folders and tags
                                        //MARK:- Mail , Desk , WIki has deep Linked Modules ,eg;If mail account changes we have to reset folders and tags module according to the mail account.
                                        let defaultAccountEmailId :Int64 = Int64(filterKeyValuePair.value)!
                                        let selected_Filter = filterValue as! String
                                        resetFoldersAndTagsForMail(filterModal: filterViewModelForService!, defaultAccountEmailId: defaultAccountEmailId, selected_Filter: selected_Filter)
                                    }
                                    else if filterKeyValuePair.value == filterValue as! String
                                    {
                                        filterModule.selectedFilterName = filterKeyValuePair.key
                                        filterModule.defaultSelectionName = filterKeyValuePair.key
                                        filterModule.defaultSelectionServerValue = filterValue as? String
                                        filterModule.selectedFilterServerValue = filterValue as? String
                                        
                                        // MARK:- Desk and Wiki has intraLinked modules ,eg; when desk portal changes department should be reseted based on portal.
                                        //Issue:- When we are reloading values in other module the selected state in that modal will be lost , If reloading happpen at beggining we dont have ploblem but filtervalues is in dictionary formate,the order is not defined.
                                        if filterModule.filterName == FilterConstants.Module.WikiModules.Wiki_Types
                                        {
                                            
                                            resetWIkiPortals(filterModal: filterViewModelForService!, selected_Filter: filterKeyValuePair.key)
                                        }
                                        else if  filterModule.filterName == FilterConstants.Module.DeskModules.PORTAL
                                        {
                                            // getting selected Portal Id
                                            
                                            let defaultPortalId :Int64  = Int64( filterKeyValuePair.value)!
                                            reSetDeskDepartmentAndModules(filterModal: filterViewModelForService!, defaultPortalId: defaultPortalId)
                                        }
                                    }
                                }
                            }
                            else if filterModule.filterViewType == .segmentedView
                            {
                                if (filterValue as! String) == FilterConstants.Values.Sortby.TIME
                                {
                                    filterModule.sortByFilterDefultIndex = 0
                                    filterModule.sortBYFIlterSelectedIndex = 0
                                }
                                else if (filterValue as! String) == FilterConstants.Values.Sortby.RELAVANCE
                                {
                                    filterModule.sortByFilterDefultIndex = 1
                                    filterModule.sortBYFIlterSelectedIndex = 1
                                }
                            }
                            else if filterModule.filterViewType == .flagView
                            {
                                filterModule.CheckBoxDefaultStatus = filterValue as! Bool
                                filterModule.CheckBoxSelectedStatus = filterValue as! Bool
                            }
                        }
                    } // for loop end
                } // else
            } // json for loop end
            filterViewModelForService?.filterSearchQuery = searchFilters
        }
        //TODO:- present result VC
        PresentResultVCAfterDataConvertionFrom(savedSearchObject: savedSearchObject)
    }
    func PresentResultVCAfterDataConvertionFrom(savedSearchObject : SavedSearches)
    {
        let jsonString = savedSearchObject.query_state_json
        let jsonData = jsonString?.data(using: .utf8)
        let dictionary:[String: AnyObject] = try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [String : AnyObject]
        
        let serviceName = savedSearchObject.service_name
        //Important - Make sure this position gets updated with reordering,
        //we must not save the position
        var index = 0
        for vc in SearchResultsViewModel.UserPrefOrder {
            if (vc.itemInfo.serviceName == serviceName) {
                break
            }
            index = index + 1
        }
        
        SearchResultsViewModel.selected_service = index
        SearchResultsViewModel.selectedService = serviceName!
        
        //        if let textField = searchbar, let textFieldDelegate = textField.delegate {
        //            if textFieldDelegate.textFieldShouldReturn!(textField) {
        //                textField.endEditing(true)
        //            }
        //        }
        
        let currentSelected = SearchResultsViewModel.selected_service
        
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
        
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
        SearchResultsViewModel.selected_service = currentSelected
        SearchResultsViewModel.ResultVC.contactName = SearchResultsViewModel.QueryVC.suggestionContactName
        SearchResultsViewModel.ResultVC.isContactSearch = SearchResultsViewModel.QueryVC.isAtMensionSelected
        SearchResultsViewModel.ResultVC.ZUID = SearchResultsViewModel.QueryVC.suggestionZUID
        SearchResultsViewModel.ResultVC.isNamelabledisplay = false
        let searchQuery = dictionary["query"] as! String
        SearchResultsViewModel.ResultVC.searchText = searchQuery
        let trimmedSearchQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        SearchResultsViewModel.ResultVC.trimmedSearchQuery = trimmedSearchQuery
        
        SearchResultsViewModel.searchWhenLoaded = true
        target.currentIndex =  SearchResultsViewModel.selected_service
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(target, animated: false)
    }
    
}
