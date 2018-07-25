//  TabBarViewController.swift
//  ButtonChildViewController
//
//  Created by manikandan bangaru on 25/01/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//

import UIKit
import Foundation


public struct TabBarViewControllerSettings {
    
    public struct Style {
        public var navigationBarBackGroundColor: UIColor = SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color
        public var tabviewBackGroundColor: UIColor = SearchKitConstants.ColorConstants.TabBarView_BackGround_Color
        public var TabBarMinimumInteritemSpacing: CGFloat = 0
        public var tabviewMinimumLineSpacing: CGFloat = 0.0
        public var TabBarLeftContentInset: CGFloat = 0
        public var TabBarRightContentInset: CGFloat = 0
        
        public var selectedBarBackgroundColor:UIColor = SearchKitConstants.ColorConstants.TabBarView_Selection_Indicator_Color
        public var selectedBarHeight: CGFloat = 3
        
        public var tabviewItemBackGroundColor: UIColor = SearchKitConstants.ColorConstants.TabBarView_BackGround_Color
        public var tabviewItemFont = UIFont.systemFont(ofSize: 16)
        public var TabBarItemLeftRightMargin: CGFloat = 8
        public var tabviewItemTitleColor: UIColor = SearchKitConstants.ColorConstants.TabBarView_SelectedCell_Text_Color
        public var TabBarHeight: CGFloat?
    }
    
    public var style = Style()
}

class TabBarViewController: ChildViewController, PagerTabStripDataSource, TabViewProgressDelegate, UICollectionViewDelegate, UICollectionViewDataSource ,ViewmoreDelegate{
    
    @IBOutlet weak var ZSNavigationBar: UIView!
    @IBOutlet weak var moreOptionButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet public weak var tabBarView: TabBarCollectionView!
    
    public var settings = TabBarViewControllerSettings()
    var activityIndicator : ZOSActivityIndicatorView?
    
    private var shouldUpdateTabBarView = true
    private var collectionViewDidLoad = false
    
    //progressbar initialization
    //var progressIndicator = UIActivityIndicatorView()
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    /*
     func initProgressIndicator() {
     
     progressIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
     //to make the progress bar bigger but ir makes the ui look bad.
     progressIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5);
     progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
     progressIndicator.center = self.view.center
     self.view.addSubview(progressIndicator)
     }
     */
    
    public var changeCurrentIndex: ((_ oldCell: TabBarCollectionViewCell?, _ newCell: TabBarCollectionViewCell?, _ animated: Bool) -> Void)?
    public var changeCurrentIndexProgressive: ((_ oldCell: TabBarCollectionViewCell?, _ newCell: TabBarCollectionViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
        }()
    
    //    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //        delegate = self
    //        datasource = self
    //
    //    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        datasource = self
        
    }
    func dynamicwidth(childItemInfo: IndicatorInfo) ->CGFloat
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.settings.style.tabviewItemFont
        label.text = childItemInfo.title
        let labelSize = label.intrinsicContentSize
        return labelSize.width + (self.settings.style.TabBarItemLeftRightMargin ) * 2
    }
    func configureBackButton()
    {
        self.backButton.setImageTintColor(imageName: "searchsdk-back", tintColor: SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color, for: .normal)
        //        let backImage = UIImage(named: "searchsdk-back", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        //        backImage?.withRenderingMode(.alwaysTemplate)
        //        self.backButton.setImage(backImage, for: .normal)
        //        self.backButton.tintColor = SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color
    }
    func configureMoreOptionButton()
    {
        self.moreOptionButton.setImageTintColor(imageName: "searchsdk-more", tintColor: SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color, for: .normal)
        //        let moreImage = UIImage(named: "searchsdk-more", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        //        moreImage?.withRenderingMode(.alwaysTemplate)
        //        self.moreOptionButton.setImage(moreImage, for: .normal)
        //        self.moreOptionButton.tintColor = SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadViewControllers()
        configureMoreOptionButton()
        configureBackButton()
        //(viewControllers[0] as! TableViewController).viewmoredelegate=self
        
        var bundle = Bundle(for: TabBarCollectionViewCell.self)
        if let resourcePath = bundle.path(forResource: "ButtonTabViewController", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        if tabBarView.delegate == nil {
            tabBarView.delegate = self
        }
        if tabBarView.dataSource == nil {
            tabBarView.dataSource = self
        }
        
        
        let flowLayout = tabBarView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = settings.style.TabBarMinimumInteritemSpacing
        flowLayout.minimumLineSpacing = settings.style.tabviewMinimumLineSpacing
        let sectionInset = flowLayout.sectionInset
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top,
                                               left: settings.style.TabBarLeftContentInset ,
                                               bottom: sectionInset.bottom,
                                               right:settings.style.TabBarRightContentInset )
        ZSNavigationBar.backgroundColor = settings.style.navigationBarBackGroundColor
        ZSNavigationBar.layer.zPosition = ZpositionLevel.high.rawValue
        self.view.bringSubview(toFront: ZSNavigationBar)
        tabBarView.scrollsToTop = false
        tabBarView.showsHorizontalScrollIndicator = false
        tabBarView.backgroundColor = settings.style.tabviewBackGroundColor
        tabBarView.selectedBar.backgroundColor = settings.style.selectedBarBackgroundColor
        
        tabBarView.selectedBarHeight = settings.style.selectedBarHeight
        
        tabBarView.register(TabBarCollectionViewCell.nib, forCellWithReuseIdentifier:TabBarCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if SearchResultsViewModel.ResultVC.isFilterEnabled
//        {
//            searchAndLoadData(searchText: SearchResultsViewModel.ResultVC.searchText)
//        }
        currentIndex = SearchResultsViewModel.selected_service
        //        tabBarView.layoutIfNeeded()
        //        containerView.layoutIfNeeded()
        //
        performUIUpdatesOnMain {
            self.tabBarView.scrollToItem(at: IndexPath(row:self.currentIndex,section:0), at: .init(rawValue: 0), animated: false)
        }
        //so that respective tab is selected
        reloadPagerTabStripView()
        
        //so that view more delegate is set for the all service search page
        var index = 0
        for (i , vc ) in SearchResultsViewModel.UserPrefOrder.enumerated() {
            if ( vc.itemInfo.serviceName == "all")
            {
                index = i
            }
        }
        
        if let vc = viewControllers[index] as? TableViewController, vc.viewmoredelegate == nil {
            vc.viewmoredelegate = self
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tabBarView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isViewAppearing || isViewRotating else { return }
        
        cachedCellWidths = calculateWidths()
        tabBarView.collectionViewLayout.invalidateLayout()
        //MARK : Forces tabbar to automatic scrolling
        tabBarView.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .scrollOnlyIfOutOfScreen)
//        tabBarView.updateSelectedBarPosition(false, swipeDirection: .none, pagerScroll: .no)
    }
    
    // MARK: - Public Methods
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
        guard isViewLoaded else { return }
        performUIUpdatesOnMain {
            self.tabBarView.reloadData()
            self.cachedCellWidths = self.calculateWidths()
            self.tabBarView.moveTo(index: self.currentIndex, animated: false, swipeDirection: .none, pagerScroll: .yes)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tabBarView.collectionViewLayout.invalidateLayout()
    }
    
    func calculateStretchedCellWidths(_ minimumCellWidths: [CGFloat], suggestedStretchedCellWidth: CGFloat, previousNumberOfLargeCells: Int) -> CGFloat {
        var numberOfLargeCells = 0
        var totalWidthOfLargeCells: CGFloat = 0
        
        for minimumCellWidthValue in minimumCellWidths where minimumCellWidthValue > suggestedStretchedCellWidth {
            totalWidthOfLargeCells += minimumCellWidthValue
            numberOfLargeCells += 1
        }
        
        guard numberOfLargeCells > previousNumberOfLargeCells else { return suggestedStretchedCellWidth }
        
        let flowLayout = tabBarView.collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewAvailiableWidth = self.view.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let numberOfCells = minimumCellWidths.count
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        
        let numberOfSmallCells = numberOfCells - numberOfLargeCells
        let newSuggestedStretchedCellWidth = (collectionViewAvailiableWidth - totalWidthOfLargeCells - cellSpacingTotal) / CGFloat(numberOfSmallCells)
        
        return calculateStretchedCellWidths(minimumCellWidths, suggestedStretchedCellWidth: newSuggestedStretchedCellWidth, previousNumberOfLargeCells: numberOfLargeCells)
    }
    //notused now we can update childview without swipe
    func updateIndicator(for viewController: ChildViewController, fromIndex: Int, toIndex: Int) {
        guard shouldUpdateTabBarView else { return }
        tabBarView.moveTo(index: toIndex, animated: false, swipeDirection: toIndex < fromIndex ? .right : .left, pagerScroll: .yes)
        
        if let changeCurrentIndex = changeCurrentIndex {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndex(cells.first!, cells.last!, true)
        }
    }
    
    // update content when user swipes screen
    func updateIndicator(for viewController: ChildViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        guard shouldUpdateTabBarView else { return }
        
        
        //childviewsearchbar
        SearchResultsViewModel.selected_service = toIndex
        
//        self.SearchBar.changeServiceImge()
        
        tabBarView.move(fromIndex: fromIndex, toIndex: toIndex, progressPercentage: progressPercentage, pagerScroll: .yes)
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndexProgressive(cells.first!, cells.last!, progressPercentage, indexWasChanged, true)
        }
    }
    
    func cellForItems(at indexPaths: [IndexPath], reloadIfNotVisible reload: Bool = true) -> [TabBarCollectionViewCell?] {
        let cells = indexPaths.map { tabBarView.cellForItem(at: $0) as? TabBarCollectionViewCell }
        
        //MARK:- compact Map is not compatible with web host
        if reload {
            let indexPathsToReload = cells.enumerated()
                .flatMap { (arg) -> IndexPath? in
                    let (index, cell) = arg
                    return cell == nil ? indexPaths[index] : nil
                }
                .flatMap { (indexPath: IndexPath) -> IndexPath? in
                    return (indexPath.item >= 0 && indexPath.item < tabBarView.numberOfItems(inSection: indexPath.section)) ? indexPath : nil
            }
            
            if !indexPathsToReload.isEmpty {
                tabBarView.reloadItems(at: indexPathsToReload)
            }
        }
        return cells
    }
    
    // MARK: - UICollectionViewDelegateFlowLayut
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        cachedCellWidths = calculateWidths()
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width: cellWidthValue, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performUIUpdatesOnMain {
            
            //childviewsearchbar
            SearchResultsViewModel.selected_service = indexPath.row
            //            self.SearchBar.changeServiceImge()
            
            
            // for updating service
            guard indexPath.item != self.currentIndex else { return }
            
            self.tabBarView.moveTo(index: indexPath.item, animated: true, swipeDirection: .none, pagerScroll: .yes)
            self.shouldUpdateTabBarView = false
            
            let oldIndexPath = IndexPath(item: self.currentIndex, section: 0)
            let newIndexPath = IndexPath(item: indexPath.item, section: 0)
            
            let cells = self.cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: self.collectionViewDidLoad)
            
            
            if let changeCurrentIndexProgressive = self.changeCurrentIndexProgressive {
                changeCurrentIndexProgressive(cells.first!, cells.last!, 1, true, true)
            }
            
            // to update scroll view
            self.moveToViewController(at: indexPath.item)
            
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier, for: indexPath) as? TabBarCollectionViewCell else {
            fatalError("UICollectionViewCell should be or extend from TabBarCollectionViewCell")
        }
        
        collectionViewDidLoad = true
        
        let childController = viewControllers[indexPath.item] as! IndicatorInfoProvider // every child should conform to indicatorprovider
        let indicatorInfo = childController.indicatorInfo(for: self)
        
        cell.label.text = indicatorInfo.title
        cell.label.font = settings.style.tabviewItemFont
        cell.label.textColor = settings.style.tabviewItemTitleColor
        cell.contentView.backgroundColor = settings.style.tabviewItemBackGroundColor
        cell.backgroundColor = settings.style.tabviewItemBackGroundColor
        
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            changeCurrentIndexProgressive(currentIndex == indexPath.item ? nil : cell, currentIndex == indexPath.item ? cell : nil, 1, true, false)
        }
        
        return cell
    }
    
    //     MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { //updates collection view cell when scrollview is scroll to next viewcontroller
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        guard scrollView == containerView else { return }
        shouldUpdateTabBarView = true
    }
 
    private func calculateWidths() -> [CGFloat] {
        let flowLayout = tabBarView.collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfCells = viewControllers.count
        
        var minimumCellWidths = [CGFloat]()
        var collectionViewContentWidth: CGFloat = 0
        for viewController in viewControllers {
            let childController = viewController as! IndicatorInfoProvider
            let indicatorInfo = childController.indicatorInfo(for: self) //calling table view controller delegate
            
            let width = dynamicwidth(childItemInfo: indicatorInfo)
            
            minimumCellWidths.append(width) ////for flexible width with cell
            collectionViewContentWidth += width
            
        }
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        collectionViewContentWidth += cellSpacingTotal
        
        let collectionViewAvailableVisibleWidth = view.frame.width//tabBarView.frame.size.width
        //- flowLayout.sectionInset.left - flowLayout.sectionInset.right
        //change the width of cell !settings.style.tabviewItemsShouldFillAvailableWidth
        if  collectionViewAvailableVisibleWidth < collectionViewContentWidth {
            return minimumCellWidths
            
        } else { //to fill the Available tab bar view
            let stretchedCellWidthIfAllEqual = (collectionViewAvailableVisibleWidth - cellSpacingTotal) / CGFloat(numberOfCells)
            let generalMinimumCellWidth = calculateStretchedCellWidths(minimumCellWidths, suggestedStretchedCellWidth: stretchedCellWidthIfAllEqual, previousNumberOfLargeCells: 0)
            var stretchedCellWidths = [CGFloat]()
            
            for minimumCellWidthValue in minimumCellWidths {
                let cellWidth = (minimumCellWidthValue > generalMinimumCellWidth) ? minimumCellWidthValue : generalMinimumCellWidth
                stretchedCellWidths.append(cellWidth)
            }
            return stretchedCellWidths
            
        }
    }
}
extension TabBarViewController
{
    public func viewmoreCliqed(tableview: TableViewController, indexAt: Int) {
        let fromIndex = currentIndex
        let toIndex = indexAt
        containerView.setContentOffset(CGPoint(x: pageOffsetForChild(at: indexAt), y: 0), animated: false)
        
        if let changeCurrentIndex = changeCurrentIndex {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndex(cells.first!, cells.last!, true)
        }
    }
}
extension TabBarViewController
{
    func searchAndLoadData(searchText : String)
    {
        // Removing all previous search results
        SearchResultsViewModel.serviceSections.removeAll()
        performUIUpdatesOnMain {
            self.viewControllers.forEach{
                let vc = $0 as! TableViewController
                vc.tableView.reloadData()
            }
        }
       
        SearchResultsViewModel.ResultVC.searchText = searchText
     
        
        //self.progressIndicator.startAnimating()
        //self.progressIndicator.backgroundColor = UIColor.white
        //        let activityIndicator = ActivityIndicatorUtils()
        //        activityIndicator.showActivityIndicator(uiView: self.view)
        let currenttable = self.viewControllers[self.currentIndex] as! TableViewController
        let backView = UIView(frame: currenttable.tableView.frame)
        backView.backgroundColor = .white
        performUIUpdatesOnMain {
            currenttable.tableView.backgroundView = backView
            self.activityIndicator = ZOSActivityIndicatorView(containerView: currenttable.tableView.backgroundView!)
            self.activityIndicator?.startAnimating()
        }
       
        //        activityIndicator.startAnimating(containerView: self.view)
        var searchFilters : [String:AnyObject]? = nil
        let currentServiceName : String = UserPrefManager.getOrderedServiceListForUser()![self.currentIndex]
        
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
        DispatchQueue.main.async {
            
            //stop and hide the loading view
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    let serviceName = (self.viewControllers[self.currentIndex] as! TableViewController).itemInfo.serviceName
                    let zuid = SearchResultsViewModel.ResultVC.ZUID
                    self.searchTask = ZOSSearchAPIClient.sharedInstance().getSearchResults(searchText, mentionedZUID: zuid, filters: searchFilters, serviceName: serviceName!, oAuthToken: oAuthToken) { (searchResults, error) in
                        self.searchTask = nil
                        if error != nil && error?.code == 1
                        {
                            //Offline Error
                            performUIUpdatesOnMain {
                                self.activityIndicator?.stopAnimating()
                                let currenttable = self.viewControllers[self.currentIndex] as! TableViewController
                                TableViewHelper.SearchResultError(viewController: currenttable, errorType: .noInterNet)
                            }
                            return
                        }
                        else if error != nil
                        {
                            //UnKnown Error
                            performUIUpdatesOnMain {
                                self.activityIndicator?.stopAnimating()
                                let currenttable = self.viewControllers[self.currentIndex] as! TableViewController
                                TableViewHelper.SearchResultError(viewController: currenttable, errorType: .unKnown)
                            }
                            return
                        }
                        if let searchResults = searchResults {
                            self.searchResults = searchResults
                            for (service, results) in self.searchResults.serviceToResultsMap {
                                //has more result should be checked before zero result case, as for exactly 25 results this could return 0 result next time
                                let hasMoreResult = self.serverHasMoreResult(obtainedResultCount: results.count, fetchCount: 25)
                                SearchResultsViewModel.serviceSearchStatus[service] = Date()
                                //if there is zero results for some service, we should not append that section
                                //do we need to add nil check or so.
                                if (results.count > 0) {
                                    if (service == ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
                                        //25 should be configurable
                                        let chatItems = ChatResultsViewModel(searchQuery: searchText, chatResults: results as! [ChatResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = chatItems
                                        
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                                        let chatItems = MailResultsViewModel(searchQuery: searchText, mailResults: results as! [MailResult], hasMoreResults: hasMoreResult, resultMetaData: self.searchResults.serviceToMetaDataMap[service])
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
                                        let connectItems = ConnectResultsViewModel(searchQuery: searchText, connectResults: results as! [ConnectResult], hasMoreResults: hasMoreResult, resultMetaData: self.searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = connectItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Crm) {
                                        let crmItems = CRMResultsViewModel(searchQuery: searchText, crmResults: results as! [CRMResult], hasMoreResults: hasMoreResult, resultMetaData: nil)
                                        SearchResultsViewModel.serviceSections[service] = crmItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Desk) {
                                        let supportItems = DeskResultsViewModel(searchQuery: searchText, supportResults: results as! [SupportResult], hasMoreResults: hasMoreResult, resultMetaData: self.searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = supportItems
                                    }
                                    else if (service == ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
                                        let wikiItems = WikiResultsViewModel(searchQuery: searchText, wikiResults: results as! [WikiResult], hasMoreResults: hasMoreResult, resultMetaData: self.searchResults.serviceToMetaDataMap[service])
                                        SearchResultsViewModel.serviceSections[service] = wikiItems
                                    }
                                }
                            }
                            
                        }
                        
                        //This is must to update the UI, otherwise results will not be shown. And should be updated on main thread
                        performUIUpdatesOnMain
                            {
                                //                                activityIndicator.hideActivityIndicator(uiView: self.view)
                                self.activityIndicator?.stopAnimating()
                                //self.progressIndicator.stopAnimating()
                                //self.progressIndicator.hidesWhenStopped = true
                                let currentTableVC = self.viewControllers[self.currentIndex] as! TableViewController
                                currentTableVC.reload()
                                TableViewHelper.updateTableViewBGStatusAfterSearch(currentTableVC:currentTableVC)
                                //end
                                SearchResultsViewModel.firstTimeSearch = false
                        }
                        
                    }
                    
                }
            })
        }
    }
    
    private func serverHasMoreResult(obtainedResultCount: Int, fetchCount: Int) -> Bool {
        return (obtainedResultCount < fetchCount ? false : true)
    }
    
}


