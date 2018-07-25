//  TableViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 25/01/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//


import Foundation
import UIKit

class TableViewController:UITableViewController, IndicatorInfoProvider{
    
    var viewmoredelegate:ViewmoreDelegate?
    let cellIdentifier = "postCell"
    var loadMoreInProgress = false
    var lastLoadMoreIndex = -1
    
    var itemInfo = IndicatorInfo(title: "temp",serviceName : "temp")
    var style :UITableViewStyle?
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.style=style
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        performUIUpdatesOnMain {
            self.tableView?.reloadData()
        }
    }
    
    //long-press properties
    var hiddenView:UIView = UIView()
    var longPressedSearchResultCell = UIView()
    var buttonview = UIImageView()
    var restoreResultCellRect = CGRect()
    var restoreQuickActionModalViewRect = CGRect()
    var indexPath: IndexPath?
    var longPressGestureDetected: Bool = false
    
    static var currentUserZUID = ""
    
    var searchTask: URLSessionDataTask?
    var pullToRefreshEnabled: Bool? = true
    //    var activityIndicator: ActivityIndicatorUtils?
    var activityIndicator: ZOSActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refresh controll should be setup only once on viewDidAppear
        //setupRefreshControl()
        setupTableView()
        setupLongPressAction()
        
        SearchResultsViewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        let currentUser = ZohoSearchKit.sharedInstance().getCurrentUser()
        TableViewController.currentUserZUID = (currentUser.zuid)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.viewGoingToAppear), name:NSNotification.Name(rawValue: "SettingsVCDismissed"), object: nil)
    }
    
    private func setupTableView() {
        //MARK:- customizing separator line in tableview
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        //MARK:- 60 image view + 5 left margin and 5 right margin of image = separator line left Inset
        self.tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -40, 0);
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionFooterHeight = 0.00001 //this is what worked
        //self.tableView.sectionHeaderHeight = 40
        
        tableView.backgroundColor = UIColor.white
        
        //register new generic cell
        self.tableView?.register(SearchResultCell.nib, forCellReuseIdentifier: SearchResultCell.identifier)
        //used in all service results page
        if #available(iOS 11.0, *) {
            self.tableView?.register(ServiceHeaderCellIOS11.nib, forHeaderFooterViewReuseIdentifier: ServiceHeaderCellIOS11.identifier)
        }
        else {
            self.tableView?.register(ServiceHeaderCellIOS9.nib, forCellReuseIdentifier: ServiceHeaderCellIOS9.identifier)
        }
        //Used in service specific results
        if #available(iOS 11.0, *) {
            self.tableView?.register(StickyServiceHeaderCellIOS11.nib, forHeaderFooterViewReuseIdentifier: StickyServiceHeaderCellIOS11.identifier)
        }
        else {
            self.tableView?.register(StickyServiceHeaderCellIOS9.nib, forCellReuseIdentifier: StickyServiceHeaderCellIOS9.identifier)
        }
        //register end of results and loading more results cell
        self.tableView?.register(LoadingViewTableViewCell.nib, forCellReuseIdentifier: LoadingViewTableViewCell.identifier)
        self.tableView?.register(EndOfResultsTableViewCell.nib, forCellReuseIdentifier: EndOfResultsTableViewCell.identifier)
        
    }
    
    private func setupLongPressAction() {
        //For long-Press
        longPressedSearchResultCell.isHidden=true
        hiddenView.isHidden=true
        buttonview.isHidden=true
        
        //long-press gesture on search result cells
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(TableViewController.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 1.5 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    private func setupRefreshControl() {
        pullToRefreshEnabled = UserPrefManager.isPullToRefreshEnabled()
        
        if pullToRefreshEnabled! {
            //set up the refresh control
            //already declared in TableViewController, so no need to declare in this TableViewController subclass
            refreshControl = UIRefreshControl()
            //get this message from I18N message properties
            refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl?.addTarget(self, action: #selector(refreshSearch(_:)), for: UIControlEvents.valueChanged)
            self.tableView?.addSubview(refreshControl!)
        }
        else {
            refreshControl = nil
        }
    }
    // Hiding tabbarview
    var lastContentOffset: CGFloat = 0
    var didScrollFlag = false
    var lastDirection : SwipeDirection = .none
    var swipeDirection : SwipeDirection
    {
        if self.lastContentOffset < self.tableView.contentOffset.y
        {
            return .top
        }
        else if self.lastContentOffset > self.tableView.contentOffset.y
        {
            return .bottom
        }
        return .none
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let  _ = self.getParentViewController() as? SearchResultsViewController
        {
            if let _ = scrollView as? UITableView
            {
                performUIUpdatesOnMain {
                    self.didScrollFlag = true
                    self.lastDirection = .none
                    self.lastContentOffset = scrollView.contentOffset.y
                }
            }
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let parentVC = self.getParentViewController() as? SearchResultsViewController
        {
            if let _ = scrollView as? UITableView
            {
                
                if isRefreshSearchRequestHappened == true
                {
                    isRefreshSearchRequestHappened = false
                    self.didScrollFlag = false
                    return
                }
                else if lastDirection != swipeDirection && lastDirection != .none
                {
                    self.didScrollFlag = true
                    self.lastDirection = self.swipeDirection
                }
                
                if (self.swipeDirection == .top) && self.didScrollFlag == true
                {
                    // moved to top // hiding tabar
                    
                    self.didScrollFlag = false
                    performUIUpdatesOnMain {
                        parentVC.tabBarView.isHidden = true
                    }
                    // MARK:- Adding animation in tabbar hiding creates problem
                    //                    performUIUpdatesOnMain {
                    //                        UIView.animate(withDuration: 0.3,
                    //                                       animations: {
                    //                                        parentVC.tabBarView.isHidden = true
                    //                        }
                    //                        )
                    //                    }
                    
                }
                else if(self.swipeDirection == .bottom) && self.didScrollFlag == true
                {
                    // moved to bottom showing tabbarView
                    
                    self.didScrollFlag = false
                    performUIUpdatesOnMain {
                        UIView.animate(withDuration: 0.3,
                                       animations: {
                                        parentVC.tabBarView.isHidden = false
                        }
                        )
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ = self.parent {
            //            activityIndicator?.hideActivityIndicator(uiView: parent.view)
            activityIndicator?.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupRefreshControl()
        if SearchResultsViewModel.ResultVC.isFilterEnabled
        {
            performUIUpdatesOnMain {
                SearchResultsViewModel.serviceSections[self.itemInfo.serviceName!] = nil
                self.reload()
                self.searchAndGetData(searchText: SearchResultsViewModel.ResultVC.searchText, isRefreshSearchRequest: false, serviceList: self.itemInfo.serviceName)
                SearchResultsViewModel.ResultVC.isFilterEnabled = false
            }
            return
        }
        //MARK:- To prevent reloaded after callout
        guard SearchResultsViewModel.searchWhenLoaded != false else {
            return
        }
        let serviceName = itemInfo.serviceName
        if !SearchResultsViewModel.firstTimeSearch, !longPressGestureDetected {
            if serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
                var notSearchedServiceList = ""
                if let serviceList = UserPrefManager.getOrderedServiceListForUser() {
                    for service in serviceList {
                        if !(service == ZOSSearchAPIClient.ServiceNameConstants.All) {
                            let serviceResults = SearchResultsViewModel.serviceSections[service]
                            if serviceResults == nil {
                                if !notSearchedServiceList.isEmpty {
                                    notSearchedServiceList = notSearchedServiceList + ","
                                }
                                notSearchedServiceList = notSearchedServiceList + service
                            }
                        }
                    }
                }
                
                if !notSearchedServiceList.isEmpty {
                    searchAndGetData(searchText: SearchResultsViewModel.ResultVC.searchText, isRefreshSearchRequest: false, serviceList: notSearchedServiceList)
                }
            }
            else {
                let serviceResults = SearchResultsViewModel.serviceSections[serviceName!]
                var isCurrentServiceAsFilters = false
                let currentServiceName : String = {
                    return itemInfo.serviceName
                    }()!
                for filter in SearchResultsViewModel.FilterSections
                {
                    // If SearchResultviewmodal.filtersection has the filtersearch query then current service has the filters
                    if (filter.serviceName == currentServiceName) && (filter.filterSearchQuery != nil)
                    {
                        isCurrentServiceAsFilters = true
                    }
                }
                if serviceResults == nil ,!isCurrentServiceAsFilters
                {
                    searchAndGetData(searchText: SearchResultsViewModel.ResultVC.searchText, isRefreshSearchRequest: false, serviceList: serviceName)
                }
            }
        }
        
        //to reset the lastLoadMore index when searched next time
        lastLoadMoreIndex =  -1
        
        //So, that unwated empty space is not shown at the bottom of the table view
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //        if UIDevice.current.orientation.isLandscape {
        //            print("Landscape")
        //        } else {
        //            print("Portrait")
        //        }
        //Reload the table view so that header gets the update size which fits into the new device view port
        reload()
    }
    
    //TODO: this should just refresh the current service search results, if you move to other
    //service it will have old results.
    var isRefreshSearchRequestHappened = false
    @objc private func refreshSearch(_ sender: Any) {
        
        //reset title to searching
        if let refreshCon = self.refreshControl, refreshCon.isRefreshing {
            performUIUpdatesOnMain {
                refreshCon.attributedTitle = NSAttributedString(string: "Searching ...")
            }
        }
        
        //search and fetch new search results
        searchAndGetData(searchText: SearchResultsViewModel.ResultVC.searchText, isRefreshSearchRequest: true, serviceList: nil)
    }
    
    private func searchAndGetData(searchText : String, isRefreshSearchRequest: Bool, serviceList: String?)
    {
        //reset the reload index as pull to refresh is like fresh search for that service
        lastLoadMoreIndex = -1
        
        SearchResultsViewModel.serviceSearchStatus[itemInfo.serviceName!] = nil
        
        self.tableView.backgroundView = nil
        
        let parentVC : SearchResultsViewController = self.getParentViewController() as! SearchResultsViewController
        if !isRefreshSearchRequest {
            performUIUpdatesOnMain {
                //                self.activityIndicator?.showActivityIndicator(uiView: (self.parent?.view)!)
                //                self.activityIndicator?.startAnimating()
                if self.itemInfo.serviceName == ZOSSearchAPIClient.ServiceNameConstants.All
                {
                    parentVC.activityLoadingContainerView.isHidden = false
                    parentVC.containerView.isHidden = true
                    parentVC.activityLoadingView.startAnimating()
                }
                else
                {
                    let backView = UIView(frame: self.tableView.frame)
                    backView.backgroundColor = .white
                    self.tableView.backgroundView = backView
                    //        TableViewHelper.clearBackGroundView(viewController: self)
                    //        self.tableView.bringSubview(toFront: self.tableView.backgroundView! )
                    self.activityIndicator = ZOSActivityIndicatorView(containerView:self.tableView.backgroundView!)
                    self.activityIndicator?.startAnimating()
                    _ = self.getParentViewController()
                    for view in self.tableView.subviews
                    {
                        if view.description == self.tableView.backgroundView?.description
                        {
                            self.tableView.bringSubview(toFront:  self.tableView.backgroundView!)
                            break
                        }
                    }
                }
            }
        }
        var searchFilters : [String:AnyObject]? = nil
        
        
        if itemInfo.serviceName != ZOSSearchAPIClient.ServiceNameConstants.All
        {
            for filter in SearchResultsViewModel.FilterSections
            {
                // If SearchResultviewmodal.filtersection has the filtersearch query then current service has the filters
                if (filter.serviceName == itemInfo.serviceName) && (filter.filterSearchQuery != nil)
                {
                    searchFilters = filter.filterSearchQuery
                }
            }
        }
        
        DispatchQueue.main.async {
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    
                    //in case of individual service tab, respective service will be used.
                    //and in case of all tab, only not searched services will be set and searched.
                    var serviceName = self.itemInfo.serviceName
                    if serviceList != nil {
                        serviceName = serviceList
                    }
                    
                    let zuid = SearchResultsViewModel.ResultVC.ZUID
                    self.searchTask = ZOSSearchAPIClient.sharedInstance().getSearchResults(searchText, mentionedZUID: zuid, filters: searchFilters, serviceName: serviceName!, oAuthToken: oAuthToken) { (searchResults, error) in
                        self.searchTask = nil
                        if error != nil && error?.code == 1
                        {
                            //Offline Error
                            performUIUpdatesOnMain{
                                self.activityIndicator?.stopAnimating()
                                TableViewHelper.SearchResultError(viewController: self, errorType: .noInterNet)
                                
                            }
                            return
                        }
                        else if error != nil
                        {
                            //UnKnown Error
                            performUIUpdatesOnMain{
                                self.activityIndicator?.stopAnimating()
                                TableViewHelper.SearchResultError(viewController: self, errorType: .unKnown)
                                
                            }
                            return
                        }
                        if let searchResults = searchResults {
                            
                            //Also this should be done only when search results is obtained, otherwise it will show empty cells
                            //as when pull to refresh is done and if the user scroll down those cells data will not be returned.
                            //in case of all service search, remove all the results, but results should be cleared only when it is pull to refresh search.
                            if self.itemInfo.serviceName == ZOSSearchAPIClient.ServiceNameConstants.All, isRefreshSearchRequest {
                                SearchResultsViewModel.serviceSections.removeAll()
                            }
                            else {
                                //in case of specific service, we will reset specific service results
                                SearchResultsViewModel.serviceSections[self.itemInfo.serviceName!] = nil
                            }
                            
                            for (service, results) in searchResults.serviceToResultsMap {
                                //has more result should be checked before zero result case, as for exactly 25 results this could return 0 result next time
                                let hasMoreResult = self.serverHasMoreResult(obtainedResultCount: results.count, fetchCount: 25)
                                SearchResultsViewModel.serviceSearchStatus[service] = Date()
                                //if there is zero results for some service, we should not append that section
                                //do we need to add nil check or so.
                                if (results.count > 0) {
                                    if (service == ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
                                        //TODO: 25 number of result requested should be configurable
                                        let chatItems = ChatResultsViewModel(searchQuery: searchText, chatResults: results as! [ChatResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = chatItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                                        let chatItems = MailResultsViewModel(searchQuery: searchText, mailResults: results as! [MailResult], hasMoreResults: hasMoreResult, resultMetaData: searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = chatItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Documents) {
                                        let docItems = DocsResultsViewModel(searchQuery: searchText, docsResults: results as! [DocsResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = docItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.People) {
                                        let peopleItems = PeopleResultsViewModel(searchQuery: searchText, peopleResults: results as! [PeopleResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = peopleItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Contacts) {
                                        let contactsItems = ContactsResultsViewModel(searchQuery: searchText, contactsResults: results as! [ContactsResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = contactsItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Connect) {
                                        let connectItems = ConnectResultsViewModel(searchQuery: searchText, connectResults: results as! [ConnectResult], hasMoreResults: hasMoreResult, resultMetaData: searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = connectItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Crm) {
                                        let crmItems = CRMResultsViewModel(searchQuery: searchText, crmResults: results as! [CRMResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = crmItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Desk) {
                                        let supportItems = DeskResultsViewModel(searchQuery: searchText, supportResults: results as! [SupportResult], hasMoreResults: hasMoreResult, resultMetaData: searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = supportItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
                                        let wikiItems = WikiResultsViewModel(searchQuery: searchText, wikiResults: results as! [WikiResult], hasMoreResults: hasMoreResult, resultMetaData: searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = wikiItems
                                    }
                                }
                            }
                            
                        }
                        
                        performUIUpdatesOnMain {
                            
                            if !isRefreshSearchRequest {
                                if let _ = self.parent {
                                    //                                    self.activityIndicator?.hideActivityIndicator(uiView: parent.view)
                                    
                                    if self.itemInfo.serviceName == ZOSSearchAPIClient.ServiceNameConstants.All
                                    {
                                        parentVC.activityLoadingView.stopAnimating()
                                        parentVC.activityLoadingContainerView.isHidden = true
                                        parentVC.containerView.isHidden = false
                                        
                                    }
                                    else
                                    {
                                        self.activityIndicator?.stopAnimating()
                                    }
                                    self.isRefreshSearchRequestHappened = true
                                }
                            }
                            
                            if let refreshCon = self.refreshControl, refreshCon.isRefreshing {
                                // tell refresh control it can stop showing up now
                                self.refreshControl?.endRefreshing()
                                //reset title to pull to refresh.
                                refreshCon.attributedTitle = NSAttributedString(string: "Pull to refresh")
                            }
                            
                            //commented
                            //let currenttable = viewControllers[currentIndex] as! TableViewController
                            //currenttable.reload()
                            self.reload()
                            self.tableView.setContentOffset(CGPoint.zero, animated: true) //move to the top as it is new search, not append
                            //self.reload()
                            TableViewHelper.updateTableViewBGStatusAfterSearch(currentTableVC: self)
                        }
                        
                    }
                    
                }
            })
        }
    }
    
    private func serverHasMoreResult(obtainedResultCount: Int, fetchCount: Int) -> Bool {
        return (obtainedResultCount < fetchCount ? false : true)
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: ChildViewController) -> IndicatorInfo {
        return itemInfo
    }
}

// MARK: UITableViewDataSource related methods
extension TableViewController {
    func isTabViewViewControllers(containsServiceName : String) -> Bool
    {
        if self.getParentViewController() != nil
        {
            let viewControllers  = SearchResultsViewModel.UserPrefOrder
            let parentVC = self.getParentViewController() as! SearchResultsViewController
            for vc in parentVC.viewControllers
            {
                let tableVC = vc as! TableViewController
                if tableVC.itemInfo.serviceName == containsServiceName
                {
                    return true
                }
            }
        }
        return false
    }
    //number of sections, All service page and individual service page
    override func numberOfSections(in tableView: UITableView) -> Int {
        //if let serviceName = itemInfo.serviceName, SearchResultsViewModel.serviceSections.count > 0 {
        if let serviceName = itemInfo.serviceName {
            if serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
                var sectionCount = 0
                if self.getParentViewController() != nil
                {
                    for (_, item) in SearchResultsViewModel.serviceSections {
                        if item.searchResults.count > 0 && isTabViewViewControllers(containsServiceName: item.serviceName){
                            sectionCount = sectionCount + 1
                        }
                    }
                }
                else
                {
                    for (_, item) in SearchResultsViewModel.serviceSections {
                        if item.searchResults.count > 0 {
                            sectionCount = sectionCount + 1
                        }
                    }
                }
                return  sectionCount
            }
            else {
                //return 1
                if let item = SearchResultsViewModel.serviceSections[itemInfo.serviceName!], item.searchResults.count > 0 {
                    return 1
                }
                else {
                    if let _ = SearchResultsViewModel.serviceSearchStatus[itemInfo.serviceName!] {
                        //MARK:- dont change the background color in this delegate method because it is been called multiple time and that creates's problem in activity indicator
                        //                         TableViewHelper.SearchResultError(viewController: self, errorType: .noResults)
                    }
                    return 0
                }
            }
        }
        else {
            //return 0 //Service should be selected, inconsistent state
            //TableViewHelper.EmptyMessage(message: "You don't have any projects yet.\nYou can create up to 10.", viewController: self)
            return 0
        }
    }
    
    //number of service per section - for all service page and individual service page
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let serviceName = itemInfo.serviceName!
        //All service page
        if serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
            let serName = getServiceNameFromSectionID(section: section)
            if let item = SearchResultsViewModel.serviceSections[serName] {
                if (item.rowCount > 3) {
                    return 3
                }
                else {
                    return item.rowCount
                }
            }
        }
        else {
            if let item = SearchResultsViewModel.serviceSections[serviceName] {
                //old logic with just loading view cell
                //                if (item.hasMoreResults) {
                //                    return item.rowCount + 1
                //                }
                //                else {
                //                    return item.rowCount
                //                }
                return item.rowCount + 1
            }
        }
        
        return 0
    }
    
    func cellFor(service_name:String, indexPath : IndexPath) -> UITableViewCell
    {
        if (SearchResultsViewModel.serviceSections.count > 0) {
            
            if let item = SearchResultsViewModel.serviceSections[service_name] {
                //MARK:- runnnung data construction under background Thread help to achive some Smoothness in tableView Scrolling
                //MARK:- LoadMoreresult() was running in mainthread cause the main thread overloading due to network callback.so,running it in background thread solved scrolling smoothness issue
                runHighPriorityAsyncTask {
                    //var item:ServiceResultViewModel=SearchResultsViewModel.serviceSections[service_name]!
                    var ServiceIndex = 0
                    for (_, service) in SearchResultsViewModel.serviceSections {
                        if service.serviceName == service_name
                        {
                            //ServiceIndex = index
                            ServiceIndex = self.getSectionIDForService(serviceName: service.serviceName)
                            //item=service
                        }
                    }
                    //call load more before reaching end
                    if self.lastLoadMoreIndex != indexPath.row {
                        if item.hasMoreResults, indexPath.row == item.rowCount - 3 {
                            self.lastLoadMoreIndex = indexPath.row
                            self.loadMoreResults(serviceIndex: ServiceIndex)
                        }
                    }
                    
                }
                
                //loading cell is the same in all the services
                if item.rowCount == indexPath.row {
                    if item.hasMoreResults {
                        let cell = tableView.dequeueReusableCell(withIdentifier: LoadingViewTableViewCell.identifier) as? LoadingViewTableViewCell
                        cell?.selectionStyle = .none //selection style is disabled as not needed
                        cell?.activityIndicator.startAnimating()
                        return cell!
                    }
                    else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: EndOfResultsTableViewCell.identifier) as? EndOfResultsTableViewCell
                        cell?.selectionStyle = .none
                        
                        return cell!
                    }
                }
                else {
                    //Generic cell handling, it will handle any new service integration as well, wejust need to create the view model class.
                    if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell {
                        cell.serviceName = item.serviceName
                        cell.searchResultItem = item.searchResults[indexPath.row]
                        //MARK:- Using DataModal Data will be contructed for search result cell
                        //                       let  searchresultsData = SearchResultCellDataModal(serviceName: item.serviceName, searchResultItem: item.searchResults[indexPath.row])
                        //                        cell.searchResultDataModal = searchresultsData
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let servName = itemInfo.serviceName {
            if servName == ZOSSearchAPIClient.ServiceNameConstants.All {
                if SearchResultsViewModel.serviceSections.count > 0 {
                    
                    let serviceName = getServiceNameFromSectionID(section: indexPath.section)
                    let item = SearchResultsViewModel.serviceSections[serviceName]
                    return cellFor(service_name: item!.serviceName, indexPath: indexPath)
                }
            }
            else {
                return cellFor(service_name: itemInfo.serviceName! ,  indexPath: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    //convenience methods
    private func getServiceNameFromSectionID(section: Int) -> String {
        var servicesWithResults = [String]()
        var orderedService = [String]()
        for (service, item) in SearchResultsViewModel.serviceSections {
            if item.searchResults.count > 0 {
                servicesWithResults.append(service)
            }
        }
        if let userOrderedServices = UserPrefManager.getOrderedServiceListForUser() {
            for service in userOrderedServices {
                if servicesWithResults.contains(service) {
                    orderedService.append(service)
                }
            }
        }
        if section < orderedService.count {
            return orderedService[section]
        }
        return ""
    }
    
    private func getSectionIDForService(serviceName: String) -> Int {
        if let userPreferredServiceOrder = UserPrefManager.getOrderedServiceListForUser() {
            if userPreferredServiceOrder.contains(serviceName) {
                //as all is not a section but a tab
                return userPreferredServiceOrder.index(of: serviceName)! + 1
            }
        }
        return 0
    }
    
}


// MARK: UITableViewDelegate
extension TableViewController {
    
    //section header height in case of all service search page
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let selected=itemInfo.serviceName!
        if selected == ZOSSearchAPIClient.ServiceNameConstants.All {
            return 60
            //return UITableViewAutomaticDimension //creates issue
        }
        else {
            switch selected {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                return 36
                
            default:
                return 0.0001
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let selected=itemInfo.serviceName!
        if selected == ZOSSearchAPIClient.ServiceNameConstants.All {
            return 60
            //return UITableViewAutomaticDimension //creates issue
        }
        else {
            switch selected {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                fallthrough
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                return 36
            default:
                return 0.0001
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    //remove unanted space from below
    /*
     override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     
     // remove bottom extra 20px space.
     //return CGFloat.leastNormalMagnitude
     return -20
     }*/
    
    //header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if #available(iOS 11.0, *) {
            let selected=itemInfo.serviceName! //default selection to All(0)
            if selected == ZOSSearchAPIClient.ServiceNameConstants.All {
                if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServiceHeaderCellIOS11.identifier) as? ServiceHeaderCellIOS11 {
                    if SearchResultsViewModel.serviceSections.count > 0 {
                        let serviceName = getServiceNameFromSectionID(section: section)
                        let item = SearchResultsViewModel.serviceSections[serviceName]
                        //headerView.section = section
                        headerView.item = item
                        headerView.delegate = self
                        
                        //iOS 11 - when we do long press in the last service results, result cell is moving up, so updating the frame
                        let oldFrame = headerView.contentView.frame
                        headerView.contentView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: self.tableView.bounds.width, height: 40)
                        
                        return headerView
                    }
                }
            }
            else {
                //we could just check and return using meta data. if there is some meta data then return the header view
                switch selected {
                case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                    if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StickyServiceHeaderCellIOS11.identifier) as? StickyServiceHeaderCellIOS11 {
                        let item = SearchResultsViewModel.serviceSections[selected]
                        headerView.item = item
                        
                        //MARK: if some interaction is needed in the header view, we should remove the below code
                        //headerView.isUserInteractionEnabled = false
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        //tapRecognizer.delegate = self
                        tapRecognizer.numberOfTapsRequired = 1
                        tapRecognizer.numberOfTouchesRequired = 1
                        headerView.addGestureRecognizer(tapRecognizer)
                        
                        let longPressRecornizer = UILongPressGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        longPressRecornizer.minimumPressDuration = 0.5
                        headerView.addGestureRecognizer(longPressRecornizer)
                        headerView.layer.zPosition = ZpositionLevel.maximum.rawValue
                        return headerView
                    }
                    
                default:
                    return UIView()
                }
            }
        }
        else {
            let selected=itemInfo.serviceName! //default selection to All(0)
            if selected == ZOSSearchAPIClient.ServiceNameConstants.All {
                //MARK: Important - reusing header footer view insread of general UITableViewCell creates issue with width in iOS 9
                //if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServiceHeaderCell.identifier) as? ServiceHeaderCell {
                if let headerView = tableView.dequeueReusableCell(withIdentifier: ServiceHeaderCellIOS9.identifier) as? ServiceHeaderCellIOS9 {
                    if SearchResultsViewModel.serviceSections.count > 0 {
                        let serviceName = getServiceNameFromSectionID(section: section)
                        let item = SearchResultsViewModel.serviceSections[serviceName]
                        //headerView.section = section
                        headerView.item = item
                        headerView.delegate = self
                        
                        let oldFrame = headerView.contentView.frame
                        headerView.contentView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: self.tableView.bounds.width, height: 40)
                        
                        //headerView.isUserInteractionEnabled = false
                        //headerView.viewAllButton.isUserInteractionEnabled = true
                        //MARK: to prevent default table did select in iOS 9 when clicked on the header view
                        if let recognizers = headerView.contentView.gestureRecognizers {
                            for recognizer in recognizers {
                                headerView.contentView.removeGestureRecognizer(recognizer)
                            }
                            headerView.awakeFromNib()
                        }
                        
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        //tapRecognizer.delegate = self
                        tapRecognizer.numberOfTapsRequired = 1
                        tapRecognizer.numberOfTouchesRequired = 1
                        headerView.addGestureRecognizer(tapRecognizer)
                        
                        let longPressRecornizer = UILongPressGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        longPressRecornizer.minimumPressDuration = 0.5
                        headerView.addGestureRecognizer(longPressRecornizer)
                        
                        //Important to add as subview, as when long press is invoked and if not added
                        //as subview to another view, the header disappers from the UI
                        let containerView = UIView(frame:headerView.frame)
                        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        containerView.addSubview(headerView)
                        headerView.layer.zPosition = ZpositionLevel.maximum.rawValue
                        return containerView
                    }
                }
            }
            else {
                //we could just check and return using meta data. if there is some meta data then return the header view
                switch selected {
                case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                    fallthrough
                case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                    if let headerView = tableView.dequeueReusableCell(withIdentifier: StickyServiceHeaderCellIOS9.identifier) as? StickyServiceHeaderCellIOS9 {
                        let item = SearchResultsViewModel.serviceSections[selected]
                        headerView.item = item
                        
                        let oldFrame = headerView.contentView.frame
                        headerView.contentView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: self.tableView.bounds.width, height: 36)
                        
                        //MARK: if some interaction is needed in the header view, we should remove the below code
                        //headerView.isUserInteractionEnabled = false
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        //tapRecognizer.delegate = self
                        tapRecognizer.numberOfTapsRequired = 1
                        tapRecognizer.numberOfTouchesRequired = 1
                        headerView.addGestureRecognizer(tapRecognizer)
                        
                        let longPressRecornizer = UILongPressGestureRecognizer(target: self, action: #selector(sectionHeaderDummyHandler))
                        longPressRecornizer.minimumPressDuration = 0.5
                        headerView.addGestureRecognizer(longPressRecornizer)
                        
                        //Important to add as subview, as when long press is invoked and if not added
                        //as subview to another view, the header disappers from the UI
                        let containerView = UIView(frame:headerView.frame)
                        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        containerView.addSubview(headerView)
                        return containerView
                    }
                    
                default:
                    return UIView()
                }
            }
        }
        
        return UIView()
    }
    
    //MARK: This is used to set dummy gesture handler - tap and logn press on table view header in iOS 9
    //as on iOS 9 and iOS 10 section header has issue of selecting or responding to gesture even the gesture
    //happens in the header cell, the first cell is reponds
    @objc private func sectionHeaderDummyHandler(_ sender: Any) {
        return
    }
    
    //Delegate called when header view is about to be displayed. If needed any transformation can be done here.
    //    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        let oldFrame = view.frame
    //        view.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: self.tableView.bounds.width, height: 40)
    //    }
    
    //MARK:- For lower OS version(before iOS 11) tableviewheight is too small to fix that we are overriding height calculation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //estimated height is set for optimisation
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: when result cell is selected or clicked. Depending on the service respective action will be triggered.
extension TableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCell = tableView.cellForRow(at: indexPath)
        //let serviceName = SearchKitUtil.getServiceNameForCell(cell: selectedCell!)
        let selectedCell = tableView.cellForRow(at: indexPath) as? SearchResultCell
        var serviceName = ""
        if let _ = (selectedCell?.serviceName)
        {
            serviceName = (selectedCell?.serviceName)!
        }
        else if let _ = selectedCell?.searchResultDataModal
        {
            serviceName = (selectedCell?.searchResultDataModal?.serviceName)!
        }
        
        
        let item = SearchResultsViewModel.serviceSections[serviceName]
        
        if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
            let chatResult = item?.searchResults[indexPath.row] as? ChatResult
            ZohoAppsDeepLinkUtil.openInChatApp(chatID: (chatResult?.chatID)!)
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect) {
            
            //with https it will not work
            //https:// should be truncated from the result's url
            //openInConnectApp(connectUrl: "https://connect.zoho.com/portal/intranet/stream/105000183773677")
            
            //indexPath.row this will give row id in that section
            //            let connectResult = item?.searchResults[indexPath.row] as? ConnectResult
            //var connectFeedUrl = connectResult?.postURL
            //connectFeedUrl = connectFeedUrl?.replacingOccurrences(of: "https://", with: "", options: .literal, range: nil)
            //openInConnectAppWithURL(connectUrl: "connect.zoho.com/portal/intranet/stream/105000183773677")
            //ZohoAppsDeepLinkUtil.openInConnectAppWithURL(connectUrl: connectFeedUrl!)
            
            //TODO: hardcoded scope for now, will change with the meta data scope id/network id
            //ZohoAppsDeepLinkUtil.openInConnectApp(type: (connectResult?.type)!, entityID: (connectResult?.postID)!, scopeID: 105000017039001)
            
            //            let targetVC: ConnectCalloutViewController = ConnectCalloutViewController.vcInstanceFromStoryboard()!
            //            targetVC.calloutData = connectResult
            //            targetVC.resultMetaData = item?.searchResultsMetaData
            //            let _ = CalloutVCData(indexPath: indexPath, resultMetaData: item?.searchResultsMetaData)
            //            presentCalloutVC(calloutVC: targetVC)
            //Calling  new Callout design
            let targetVC: DetailedCalloutViewController = DetailedCalloutViewController.vcInstanceFromStoryboard()!
            targetVC.calloutVCData = CalloutVCData(indexPath: indexPath, resultMetaData: item?.searchResultsMetaData, servicename: serviceName)
            targetVC.searchResult = item?.searchResults[indexPath.row] as? ConnectResult
            targetVC.serviceName = serviceName
            self.presentCalloutVC(calloutVC: targetVC)
            
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Documents) {
            let docResult = item?.searchResults[indexPath.row] as? DocsResult
            //using web browser based redirection
            //openInDocsApp(docsFileID: "1ss172f2215f5eda14e2588174909cb739b1c")
            ZohoAppsDeepLinkUtil.openInDocsApp(docsFileID: (docResult?.docID)!)
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail) {
            //SnackbarUtils.showMessageWithDismiss(msg: "Mail preview is not supported!")
            //            let mailResult = item?.searchResults[indexPath.row] as? MailResult
            
            // Do any additional setup after loading the view.
            //            let targetVC: MailCalloutViewController = MailCalloutViewController.vcInstanceFromStoryboard()!
            //            targetVC.calloutData = mailResult
            //New generic callout VC calling
            
            let targetVC: DetailedCalloutViewController = DetailedCalloutViewController.vcInstanceFromStoryboard()!
            targetVC.calloutVCData = CalloutVCData(indexPath: indexPath, resultMetaData: item?.searchResultsMetaData, servicename: serviceName)
            targetVC.searchResult = item?.searchResults[indexPath.row] as? MailResult
            targetVC.serviceName = serviceName
            self.presentCalloutVC(calloutVC: targetVC)
            
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk) {
            let deskResult = item?.searchResults[indexPath.row] as? SupportResult
            
            if (deskResult?.moduleID == 1 || deskResult?.moduleID == 2) {
                //                let targetVC: DeskCalloutViewController = DeskCalloutViewController.vcInstanceFromStoryboard()!
                //                targetVC.calloutData = deskResult
                //                targetVC.resultMetaData = item?.searchResultsMetaData
                //
                //                presentCalloutVC(calloutVC: targetVC)
                
                let targetVC: DetailedCalloutViewController = DetailedCalloutViewController.vcInstanceFromStoryboard()!
                targetVC.calloutVCData = CalloutVCData(indexPath: indexPath, resultMetaData: item?.searchResultsMetaData, servicename: serviceName)
                targetVC.searchResult = deskResult
                targetVC.serviceName = serviceName
                self.presentCalloutVC(calloutVC: targetVC)
            }
            else {
                /*
                 //                //3 = contacts and 4 = accounts
                 //                let targetVC: PeopleDetailsViewController = PeopleDetailsViewController.vcInstanceFromStoryboard()!
                 //
                 //                //some duplicate codes, later will make it concise
                 //                if (deskResult?.moduleID == 3) {
                 //                    let contactName = deskResult?.title
                 //                    let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: contactName!)
                 //                    calloutData.imageName = "searchsdk-desk-contacts"
                 //
                 //                    if let email = deskResult?.subtitle1 {
                 //                        let rowData: RowData = RowData(withLabelText: "Email")
                 //                        rowData.rowDataText = email
                 //                        rowData.dataType = RowDataType.Email
                 //                        calloutData.keyValuePairs.append(rowData)
                 //                    }
                 //
                 //                    targetVC.calloutData = calloutData
                 //                }
                 //                else if (deskResult?.moduleID == 4) {
                 //                    let accountName = deskResult?.title
                 //                    let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: accountName!)
                 //                    //only image name differs from the contacts
                 //                    calloutData.imageName = "searchsdk-desk-accounts"
                 //                    if let email = deskResult?.subtitle1, email.isEmpty == false {
                 //                        let rowData: RowData = RowData(withLabelText: "Email")
                 //                        rowData.rowDataText = email
                 //                        rowData.dataType = RowDataType.Email
                 //                        calloutData.keyValuePairs.append(rowData)
                 //                    }
                 //
                 //                    targetVC.calloutData = calloutData
                 //                }
                 //
                 //                presentCalloutVC(calloutVC: targetVC)
                 */
                //3 = contacts and 4 = accounts
                let targetVC = CalloutViewController.vcInstanceFromStoryboard()!
                var resultDataPairs = [DataLabelAndValue]()
                //some duplicate codes, later will make it concise
                if (deskResult?.moduleID == 3) {
                    //
                    //                    let photoURL = DataLabelAndValue(labelText: CallOutFeilds.photoURL.rawValue, valueText: "searchsdk-desk-contacts" )
                    //                    resultDataPairs.append(photoURL)
                    let name = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: (deskResult?.title)! )
                    resultDataPairs.append(name)
                    if let email = deskResult?.subtitle1 ,email.isEmpty == false{
                        let mail = DataLabelAndValue(labelText: CallOutFeilds.email.rawValue, valueText: email )
                        resultDataPairs.append(mail)
                    }
                    // Mobile Number
                    if let phone = deskResult?.subtitle2 ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    else if let phone = deskResult?.phone ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    else if let phone = deskResult?.mobile ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    
                    let calloutResult = CallOutResult(dictionary: resultDataPairs)
                    targetVC.callOutResult = calloutResult
                }
                else if (deskResult?.moduleID == 4) {
                    //                    let photoURL = DataLabelAndValue(labelText: CallOutFeilds.photoURL.rawValue, valueText: "searchsdk-desk-contacts" )
                    //                    resultDataPairs.append(photoURL)
                    let name = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: (deskResult?.title)! )
                    resultDataPairs.append(name)
                    if let email = deskResult?.subtitle1 , email.isEmpty == false {
                        let mail = DataLabelAndValue(labelText: CallOutFeilds.email.rawValue, valueText: email )
                        resultDataPairs.append(mail)
                    }
                    // Mobile Number
                    if let phone = deskResult?.subtitle2 ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    else if let phone = deskResult?.phone ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    else if let phone = deskResult?.mobile ,phone.isEmpty == false{
                        let phone = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: phone )
                        resultDataPairs.append(phone)
                    }
                    let calloutResult = CallOutResult(dictionary: resultDataPairs)
                    targetVC.callOutResult = calloutResult
                }
                targetVC.deskResult = deskResult
                targetVC.searchResult = deskResult
                targetVC.serviceName = serviceName
                presentCalloutVC(calloutVC: targetVC)
            }
            
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Crm) {
            let crmResult = item?.searchResults[indexPath.row] as? CRMResult
            //Only Leads and Contacts module is supported right now
            //            if (crmResult?.moduleName == "Leads" || crmResult?.moduleName == "Contacts") {
            //                ZohoAppsDeepLinkUtil.openInCRMApp(moduleName: (crmResult?.moduleName)!, recordID: (crmResult?.entID)!, zuid: TableViewController.currentUserZUID)
            //            }
            //            else {
            //                SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
            //            }
            //    var CRMCalloutDataTask: URLSessionDataTask?
            
            
            //            let targetVC = CalloutViewController.vcInstanceFromStoryboard()!
            //            //MARK:- After Loading ViewController we can't reloaded MetaData Feils,but we can reload TableView,SO we have to give the meta data before VC loaded
            //            var resultDataPairs = [DataLabelAndValue]()
            //            let currentCell = self.tableView(tableView, cellForRowAt: indexPath) as! CRMResultViewCell
            //            let Title = currentCell.resultTitle.text
            //            let feildData = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: Title! )
            //            resultDataPairs.append(feildData)
            //
            //            let calloutResult = CallOutResult(dictionary: resultDataPairs)
            //            targetVC.callOutResult = calloutResult
            //            targetVC.crmResult = crmResult
            //            self.presentCalloutVC(calloutVC: targetVC)
            //New Crm Callout Design
            let targetVC = CRMCalloutViewController.vcInstanceFromStoryboard()!
            targetVC.crmResult = crmResult
            self.presentCalloutVC(calloutVC: targetVC)
            
        }
            //for now some code has been duplicated, later will try to use the same
            //this callout layout might be used for other as well, that's why rowdata
            //like in CRM, key value we can use the same, desk account details
            //desk contact details
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.People) {
            
            /*
             let targetVC: PeopleDetailsViewController = PeopleDetailsViewController.vcInstanceFromStoryboard()!
             
             let employeeName = (peopleResult?.firstName)! + " " + (peopleResult?.lastName)!
             let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: employeeName)
             calloutData.imageURL = peopleResult?.photoURL
             calloutData.openInAppType = PeopleOpenInAppTypes.People
             calloutData.openInAppData["people_email"] = peopleResult?.email
             calloutData.openInAppSupported = true
             
             if let email = peopleResult?.email {
             //TODO: These fields are used to display label in UI, so fetch from the I18N
             let rowData: RowData = RowData(withLabelText: "Email")
             rowData.rowDataText = email
             rowData.dataType = RowDataType.Email
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let mobile = peopleResult?.mobile {
             let rowData: RowData = RowData(withLabelText: "Mobile")
             rowData.rowDataText = mobile
             rowData.dataType = RowDataType.PhoneNumber
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let designation = peopleResult?.designation {
             let rowData: RowData = RowData(withLabelText: "Designation")
             rowData.rowDataText = designation
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let department = peopleResult?.departmentName {
             let rowData: RowData = RowData(withLabelText: "Department")
             rowData.rowDataText = department
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let empID = peopleResult?.empID {
             let rowData: RowData = RowData(withLabelText: "Employeed ID")
             rowData.rowDataText = empID
             calloutData.keyValuePairs.append(rowData)
             }
             
             //TODO: gender has been removed from the people search results itself
             //we need to delete the property from model as well.
             if let gender = peopleResult?.gender, gender.isEmpty == false {
             let rowData: RowData = RowData(withLabelText: "Gender")
             rowData.rowDataText = gender
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let ext = peopleResult?.extn {
             let rowData: RowData = RowData(withLabelText: "Extension")
             rowData.rowDataText = ext
             calloutData.keyValuePairs.append(rowData)
             }
             
             if let location = peopleResult?.location {
             let rowData: RowData = RowData(withLabelText: "Location")
             rowData.rowDataText = location
             calloutData.keyValuePairs.append(rowData)
             }
             
             targetVC.calloutData = calloutData
             */
            let peopleResult = item?.searchResults[indexPath.row] as? PeopleResult
            
            let targetVC = CalloutViewController.vcInstanceFromStoryboard()!
            var resultDataPairs = [DataLabelAndValue]()
            //MARK:- order should be same as in display
            if let empID = peopleResult?.empID , empID.isEmpty == false
            {
                let empid = DataLabelAndValue(labelText: CallOutFeilds.empID.rawValue, valueText: empID )
                resultDataPairs.append(empid)
            }
            if let mobile = peopleResult?.mobile , mobile.isEmpty == false
            {
                let mobileNumber = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: mobile )
                resultDataPairs.append(mobileNumber )
            }
            if let email = peopleResult?.email , email.isEmpty == false
            {
                let mail = DataLabelAndValue(labelText: CallOutFeilds.email.rawValue, valueText: email )
                resultDataPairs.append(mail)
            }
            if let seatLocation = peopleResult?.location , seatLocation.isEmpty == false
            {
                let location = DataLabelAndValue(labelText: CallOutFeilds.location.rawValue, valueText: seatLocation )
                resultDataPairs.append(location)
            }
            if let extn = peopleResult?.extn , extn.isEmpty == false
            {
                let extention = DataLabelAndValue(labelText: CallOutFeilds.extn.rawValue, valueText: extn )
                resultDataPairs.append(extention)
            }
            
            if let fname = peopleResult?.firstName , let lname = peopleResult?.lastName , fname.isEmpty == false
            {
                let name = fname + " " + lname
                let fullName = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: name )
                resultDataPairs.append(fullName)
            }
            
            if let zuid = peopleResult?.zuid
            {
                let zuID = DataLabelAndValue(labelText: CallOutFeilds.zuid.rawValue, valueText: String(zuid) )
                resultDataPairs.append(zuID)
            }
            if let photoURL = peopleResult?.photoURL
            {
                let photoUrl = DataLabelAndValue(labelText: CallOutFeilds.photoURL.rawValue, valueText: photoURL )
                resultDataPairs.append(photoUrl)
            }
            if let departmentName = peopleResult?.departmentName , departmentName.isEmpty == false
            {
                let depName = DataLabelAndValue(labelText: CallOutFeilds.departmentName.rawValue, valueText: departmentName )
                resultDataPairs.append(depName)
            }
            
            
            if let design = peopleResult?.designation , design.isEmpty == false
            {
                let designation = DataLabelAndValue(labelText: CallOutFeilds.designation.rawValue, valueText: design )
                resultDataPairs.append(designation)
            }
            if let teamMail = peopleResult?.teamMailID , teamMail.isEmpty == false
            {
                let tmail = DataLabelAndValue(labelText: "Team Mail", valueText: teamMail )
                resultDataPairs.append(tmail)
            }
            if let reportingTo = peopleResult?.reportingTo , reportingTo.isEmpty == false
            {
                let reporting = DataLabelAndValue(labelText: "Reporting To", valueText: reportingTo )
                resultDataPairs.append(reporting)
            }
            
            let calloutResult = CallOutResult(dictionary: resultDataPairs)
            targetVC.callOutResult = calloutResult
            targetVC.serviceName = serviceName
            targetVC.searchResult = peopleResult
            self.presentCalloutVC(calloutVC: targetVC)
            
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Contacts) {
            
            //            let targetVC: PeopleDetailsViewController = PeopleDetailsViewController.vcInstanceFromStoryboard()!
            //
            //            let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: (contactResult?.fullName)!)
            //
            //            calloutData.imageURL = contactResult?.photoURL
            //
            //            if let email = contactResult?.emailAddress, !email.isEmpty {
            //                let rowData: RowData = RowData(withLabelText: "Email")
            //                rowData.rowDataText = email
            //                rowData.dataType = RowDataType.Email
            //                calloutData.keyValuePairs.append(rowData)
            //            }
            //
            //            if let mobile = contactResult?.mobileNumber, !mobile.isEmpty {
            //                let rowData: RowData = RowData(withLabelText: "Mobile")
            //                rowData.rowDataText = mobile
            //                rowData.dataType = RowDataType.PhoneNumber
            //                calloutData.keyValuePairs.append(rowData)
            //            }
            //
            //            targetVC.calloutData = calloutData
            //
            //            presentCalloutVC(calloutVC: targetVC)
            
            
            let contactResult = item?.searchResults[indexPath.row] as? ContactsResult
            
            let targetVC = CalloutViewController.vcInstanceFromStoryboard()!
            var resultDataPairs = [DataLabelAndValue]()
            if let  photoURL = contactResult?.photoURL , photoURL.isEmpty == false
            {
                let photoUrl = DataLabelAndValue(labelText: CallOutFeilds.photoURL.rawValue, valueText: photoURL )
                resultDataPairs.append(photoUrl)
                
            }
            if let mail = contactResult?.emailAddress , mail.isEmpty == false
            {
                let email = DataLabelAndValue(labelText: CallOutFeilds.email.rawValue, valueText: mail )
                resultDataPairs.append(email)
            }
            if let name = contactResult?.fullName , name.isEmpty == false
            {
                
                let fullName = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: name )
                resultDataPairs.append(fullName)
            }
            //MARK:-should create an generic callout result type
            let calloutResult = CallOutResult(dictionary: resultDataPairs)
            targetVC.callOutResult = calloutResult
            targetVC.serviceName = serviceName
            targetVC.searchResult = contactResult
            self.presentCalloutVC(calloutVC: targetVC)
            
        }
        else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
            //            let wikiResult = item?.searchResults[indexPath.row] as? WikiResult
            
            // Do any additional setup after loading the view.
            //            let targetVC: WikiCalloutViewController = WikiCalloutViewController.vcInstanceFromStoryboard()!
            //            targetVC.calloutData = wikiResult
            //
            //            presentCalloutVC(calloutVC: targetVC)
            let targetVC: DetailedCalloutViewController = DetailedCalloutViewController.vcInstanceFromStoryboard()!
            targetVC.calloutVCData = CalloutVCData(indexPath: indexPath, resultMetaData: item?.searchResultsMetaData, servicename: serviceName)
            targetVC.searchResult = item?.searchResults[indexPath.row] as? WikiResult
            targetVC.serviceName = serviceName
            self.presentCalloutVC(calloutVC: targetVC)
        }
        
        //deselect at the end, so that it does not remain selected on app switch or callout page
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func presentCalloutVC(calloutVC: UIViewController) {
        //to present as modal
        //ZohoSearchKit.sharedInstance().searchViewController?.present(targetVC, animated: true, completion: nil)
        
        //to open callout by pushing the callout view controller
        //ZohoSearchKit.sharedInstance().searchViewController?.navigationController?.pushViewController(calloutVC, animated: true)
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(calloutVC, animated: true)
    }
}

protocol ViewmoreDelegate: class {
    func viewmoreCliqed(tableview : TableViewController ,indexAt: Int)
}

//TODO: first time when searched, tapping on view all works. Next time when you edit the query and
//tap on view all it does not work. Delegate is set properly, but issue is there in viewmoreCliqed in TabBarViewController method
extension TableViewController: HeaderViewDelegate {
    func toggleSection(header: UIView, serviceName: String) {
        var index = 0
        //let serviceName = getServiceNameFromSectionID(section: section)
        let item=SearchResultsViewModel.serviceSections[serviceName]
        switch item?.type {
        case  .contactsResult?:
            
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
            
            
        case .peopleResult?:
            
            for (i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .mailResult?:
            
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .chatResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .connectResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .docsResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .crmResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .deskResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
        case .wikiResult?:
            for ( i , tableView) in SearchResultsViewModel.UserPrefOrder.enumerated()
            {
                
                if (tableView.itemInfo.serviceName == serviceName)
                {
                    index = i
                }
            }
            
        case .none:
            fatalError("Inconsistent state")
        }
        
        //        MARK:- for scrolling animation we are using didselected method
        performUIUpdatesOnMain {
            let parent = self.getParentViewController() as! SearchResultsViewController
            let fromIndex = parent.currentIndex
            let toIndex = index

            parent.tabBarView.moveTo(index: index, animated: true, swipeDirection: .right , pagerScroll: .yes)

            parent.containerView.setContentOffset(CGPoint(x: parent.pageOffsetForChild(at: index), y: 0), animated: false)
            if let changeCurrentIndex = parent.changeCurrentIndex {
                let oldIndexPath = IndexPath(item: parent.currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
                let newIndexPath = IndexPath(item: parent.currentIndex, section: 0)

                let cells = parent.cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: true)
                changeCurrentIndex(cells.first!, cells.last!, true)
            }
        }
        
        //MARK:- If we dont want animation simply change current index and reload pagerstrapcontroller
        // let parent = self.getParentViewController() as! SearchResultsViewController
        // parent.currentIndex = index
        //  parent.reloadPagerTabStripView()
        
        //MARK:- Viewmore Delegate connection is broken after using navigation controller , So we are not using now
        //            viewmoredelegate?.viewmoreCliqed(tableview : self ,indexAt: index)
    }
    
}

// MARK: load more current service without reloading other child controller
// Append new set of results, without breaking other service tab scroll state or result state
extension TableViewController
{
    func loadMoreResults(serviceIndex: Int) {
        var item = SearchResultsViewModel.serviceSections[itemInfo.serviceName!]
        let loadingCellID = (item?.rowCount)!
        let numOfResultsReq = 25
        var searchFilters : [String:AnyObject]? = nil
        let currentServiceName : String = {
            return UserPrefManager.getOrderedServiceListForUser()![SearchResultsViewModel.selected_service]
        }()
        if currentServiceName != ZOSSearchAPIClient.ServiceNameConstants.All {
            for filter in SearchResultsViewModel.FilterSections
            {
                // If SearchResultviewmodal.filtersection has the filtersearch query then current service has the filters
                if (filter.serviceName == currentServiceName) && (filter.filterSearchQuery != nil)
                {
                    searchFilters = filter.filterSearchQuery
                }
            }
        }
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                let _ = ZOSSearchAPIClient.sharedInstance().loadMoreSearchResultsForService((item?.searchQuery)!, mentionedZUID: SearchResultsViewModel.ResultVC.ZUID, filters: searchFilters, oAuthToken: oAuthToken, serviceName: (item?.serviceName)!, startIndex: (item?.searchResults.count)!, numOfResults: numOfResultsReq) { (searchResults, error) in
                    
                    //error should be nil
                    if error == nil {
                        
                        //count greater than 0 should not be checked as in case of exact result count and next result set an empty set should mark
                        //that service does not have ant result
                        if let searchResults = searchResults {
                            //Add the search results to the section
                            for searchResult in searchResults {
                                item?.searchResults.append(searchResult)
                            }
                            
                            //We should have check whether more results are there in the server before loading
                            //this means server have no more results
                            if (searchResults.count < numOfResultsReq) {
                                //hence set flag to hide load mpre by setting height to 0
                                item?.hasMoreResults = false
                            }
                            
                            var indexPathsToAppend = [IndexPath]()
                            for index in loadingCellID...(item?.rowCount)! {
                                let idxPath = IndexPath(row: index, section: 0)
                                indexPathsToAppend.append(idxPath)
                            }
                            
                            /*
                             //when we don't want extra cell at the end when search result exhausts.
                             //above logic will insert n+1 rows so that there will be end of result cell
                             for index in loadingCellID..<(item?.rowCount)! {
                             let idxPath = IndexPath(row: index, section: 0)
                             indexPathsToAppend.append(idxPath)
                             }
                             
                             //only when there are results in server we will append index path for loading view cell
                             if (item?.hasMoreResults)! {
                             let idxPath = IndexPath(row: (item?.rowCount)!, section: 0)
                             indexPathsToAppend.append(idxPath)
                             }
                             */
                            
                            // Adjust the number of the rows inside the section
                            performUIUpdatesOnMain {
                                
                                let loadingCellIdxPath = IndexPath(row: loadingCellID, section: 0)
                                if let loadingCell = self.tableView.cellForRow(at: loadingCellIdxPath) as? LoadingViewTableViewCell {
                                    loadingCell.activityIndicator.stopAnimating()
                                }
                                
                                //var contentOffset = self.tableView.contentOffset
                                //contentOffset.y = contentOffset.y + self.tableView(self.tableView, heightForRowAt: IndexPath(row: loadingCellIdxPath.row - 1, section: 0))
                                
                                self.tableView?.beginUpdates()
                                self.tableView.deleteRows(at: [loadingCellIdxPath], with: .top)
                                self.tableView.insertRows(at: indexPathsToAppend, with: .bottom)
                                //self.tableView?.reloadSections([0], with: .automatic) //.automatic,.bottom is prefered
                                //self.tableView.layoutIfNeeded()
                                //self.tableView.setContentOffset(contentOffset, animated: false)
                                self.tableView?.endUpdates()
                                //scroll to the first row of the ones which has been added.
                                //this should be called only after ending the table view update
                                self.tableView.scrollToRow(at: loadingCellIdxPath, at: .bottom, animated: false)
                            }
                        }
                    }
                }
            }
        })
    }
}
