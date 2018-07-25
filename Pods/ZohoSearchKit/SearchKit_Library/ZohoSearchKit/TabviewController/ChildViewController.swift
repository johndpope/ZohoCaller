//  ChildViewController.swift
//  ButtonChildViewController
//
//  Created by manikandan bangaru on 25/01/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//


import UIKit

// MARK: Protocols

protocol IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: ChildViewController) -> IndicatorInfo
    
}

protocol PagerTabStripDelegate: class {
    func updateIndicator(for viewController: ChildViewController, fromIndex: Int, toIndex: Int)
}

protocol TabViewProgressDelegate: PagerTabStripDelegate {
    func updateIndicator(for viewController: ChildViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool)
}

protocol PagerTabStripDataSource: class {
    func viewControllers(for pagerTabStripController: ChildViewController) -> [UITableViewController]
}

// MARK: ChildViewController

class ChildViewController: ZSViewController, UIScrollViewDelegate,UITextFieldDelegate{
    
    //childviewsearchbar
    @IBOutlet  weak var SearchBar: ResultVCSearchBar!
    @IBOutlet weak public var containerView: UIScrollView! // containerview contains all view controller
    
    var searchResults = SearchResults(query: "")
    var searchTask: URLSessionDataTask?
    var ChildViewControllersForScrolling: [UIViewController]?
    private var lastPageNumber = 0
    private var lastContentOffset: CGFloat = 0.0
    private var lastScrollViewYPossition : CGFloat = 0.0
    private var pageBeforeRotate = 0
    private var lastSize = CGSize(width: 0, height: 0)
    internal var isViewRotating = false
    internal var isViewAppearing = false
    
    
    
    weak var delegate: PagerTabStripDelegate?
    weak var datasource: PagerTabStripDataSource?
    
    var viewControllerDictionary = [String: UIViewController]()
    var currentServiceName = SearchResultsViewModel.selectedService
    
    var viewControllers = [UIViewController]()
    var lastcurrentIndex = -1
    var currentIndex = SearchResultsViewModel.selected_service
    {
        didSet{
            if self.SearchBar != nil
            {
                if lastcurrentIndex != currentIndex
                {
                    
                    if let parentVC = self as? SearchResultsViewController
                    {
                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                                    parentVC.tabBarView.isHidden = false
                        },
                                       completion: { (completed) -> Void in
                                        self.SearchBar.changeServiceImge()
                                        self.lastcurrentIndex = self.currentIndex
                        })
                        
                    }
                }
            }
        }
    }
    private(set) var preCurrentIndex = 0 // used *only* to store the index to which move when the pager becomes visible
    
    var pageWidth: CGFloat {
        return containerView.bounds.width
        //   return view.bounds.width
        
    }
    
    var scrollPercentage: CGFloat {
            if swipeDirection != .right {
                let module = fmod(containerView.contentOffset.x, pageWidth)
                return module == 0.0 ? 1.0 : module / pageWidth
            }
            return 1 - fmod(containerView.contentOffset.x >= 0 ? containerView.contentOffset.x : pageWidth + containerView.contentOffset.x, pageWidth) / pageWidth
    }
    
    var swipeDirection: SwipeDirection {
        if containerView.contentOffset.x > lastContentOffset { //containerView.contentOffset.x is how far the view moved in horizodal direction in scrollview, y is for vertical movement
            return .left
        } else if containerView.contentOffset.x < lastContentOffset {
            return .right
        }
        return .none
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        //MARK:- clearing Search Results when User taps Searchbar
        
        SearchResultsViewModel.selected_service = currentIndex
        SearchResultsViewModel.QueryVC.suggestionPageSearchText = SearchResultsViewModel.ResultVC.searchText
        SearchResultsViewModel.QueryVC.suggestionZUID = SearchResultsViewModel.ResultVC.ZUID
        let target: SearchQueryViewController = SearchQueryViewController.vcInstanceFromStoryboard()!
        self.SearchBar.resignFirstResponder() //or this can even be deregistered in vieWillDisappear
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(target, animated: false)
        
        //old way to close the ui
        /*
         self.dismiss(animated: false, completion:nil)
         ZohoSearchKit.sharedInstance().appViewController?.present(target, animated: false, completion:{
         performUIUpdatesOnMain {
         target.ServiceView.scrollToItem(at: IndexPath(item : self.currentIndex,section : 0), at:.right , animated: false)
         target.ServiceView.selectItem(at: IndexPath(item : self.currentIndex,section : 0), animated: false, scrollPosition: .right)
         target.collectionView(target.ServiceView, didSelectItemAt: IndexPath(item : self.currentIndex,section : 0))
         SearchResultsViewModel.isNamelabledisplay = false
         }
         })
         */
        
    }
    
    /*
     public func textFieldDidBeginEditing(_ textField: UITextField) {
     SearchResultsViewModel.selected_service = currentIndex
     let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SearchViewController.self), bundle: ZohoSearchKit.frameworkBundle)
     let target = (storyboard.instantiateInitialViewController() as? MedianViewController)!
     
     self.present(target, animated: false, completion:{
     
     performUIUpdatesOnMain {
     target.ServiceView.scrollToItem(at: IndexPath(item : self.currentIndex,section : 0), at:.right , animated: false)
     target.ServiceView.selectItem(at: IndexPath(item : self.currentIndex,section : 0), animated: false, scrollPosition: .right)
     target.collectionView(target.ServiceView, didSelectItemAt: IndexPath(item : self.currentIndex,section : 0))
     SearchResultsViewModel.isNamelabledisplay = false
     }
     
     })
     }
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SearchBar.delegate=self
        SearchBar.text = SearchResultsViewModel.ResultVC.searchText
        let conteinerViewAux = containerView ?? {
            let containerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return containerView
            }()
        containerView = conteinerViewAux
        if containerView.superview == nil {
            view.addSubview(containerView)
        }
        containerView.bounces = true
        containerView.alwaysBounceHorizontal = true
        containerView.alwaysBounceVertical = false
        containerView.scrollsToTop = false
        containerView.delegate = self
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.isPagingEnabled = true // moves one viewcontroller at a time
        reloadViewControllers() //load the current Child view controller into viewcontrollers(Array)
        
        let childController = viewControllers[currentIndex]
        addChildViewController(childController)
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewAppearing = true
        childViewControllers.forEach { $0.beginAppearanceTransition(true, animated: animated) }
    }
    
    override func viewDidAppear(_ animated: Bool) { //
        super.viewDidAppear(animated)
        lastSize = containerView.bounds.size
        updateIfNeeded()
        let needToUpdateCurrentChild = preCurrentIndex != currentIndex //if preCurrent changed we will to update Current childview
        if needToUpdateCurrentChild {
            moveToViewController(at: preCurrentIndex)
        }
        isViewAppearing = false
        childViewControllers.forEach { $0.endAppearanceTransition() }
    }
    
    override func viewWillDisappear(_ animated: Bool) { //view closing
        super.viewWillDisappear(animated)
        childViewControllers.forEach { $0.beginAppearanceTransition(false, animated: animated) }
    }
    
    override func viewDidDisappear(_ animated: Bool) { //view closed
        super.viewDidDisappear(animated)
        childViewControllers.forEach { $0.endAppearanceTransition() }
    }
    
    override func viewDidLayoutSubviews() { //sub view changing
        super.viewDidLayoutSubviews()
        updateIfNeeded()
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    func moveToViewController(at index: Int, animated: Bool = true) { //move to viewcontroller will handle serive cliq action not for swipe action
        
        guard isViewLoaded && currentIndex != index else {
            preCurrentIndex = index
            return
        }
        
//        if ChildViewControllersForScrolling == nil
//        {
//            fatalError("child is nil for selected service")
//        }
        
        if animated && abs(currentIndex - index) > 1 {
            var tmpViewControllers = viewControllers
            let currentChildVC = viewControllers[currentIndex]
            let fromIndex = currentIndex < index ? index - 1 : index + 1
            let fromChildVC = viewControllers[fromIndex]
            tmpViewControllers[currentIndex] = fromChildVC
            tmpViewControllers[fromIndex] = currentChildVC
            ChildViewControllersForScrolling = tmpViewControllers
            
            containerView.setContentOffset(CGPoint(x: pageOffsetForChild(at: fromIndex), y: 0), animated: false)
            (navigationController?.view ?? view).isUserInteractionEnabled = !animated
            containerView.setContentOffset(CGPoint(x: pageOffsetForChild(at: index), y: 0), animated: true)
        }
        else {
            (navigationController?.view ?? view).isUserInteractionEnabled = !animated
            containerView.setContentOffset(CGPoint(x: pageOffsetForChild(at: index), y: 0), animated: animated)
        }
    }
    
    //    func moveTo(viewController: UIViewController, animated: Bool = true) {
    //        moveToViewController(at: viewControllers.index(of: viewController)!, animated: animated)
    //    }
    
    
    
    // we will override this method  in searchviewcontroller class
    func viewControllers(for pagerTabStripController: ChildViewController) -> [UITableViewController] {
        assertionFailure("Sub-class must implement the PagerTabStripDataSource viewControllers(for:) method")
        return []
    }
    
    func updateIfNeeded() {
        if isViewLoaded && !lastSize.equalTo(containerView.bounds.size) {
            updateContent()
        }
    }
    
    func pageOffsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * containerView.bounds.width
    }
    
    func offsetForChild(at index: Int) -> CGFloat {
        return (CGFloat(index) * containerView.bounds.width) + ((containerView.bounds.width - view.bounds.width) * 0.5)
    }
    
    func offsetForChild(viewController: UIViewController) throws -> CGFloat {
        guard let index = viewControllers.index(of: viewController) else {
            throw ChildViewError.viewControllerOutOfBounds
        }
        return offsetForChild(at: index)
    }
    
    func pageFor(contentOffset: CGFloat) -> Int {
        let result = virtualPageFor(contentOffset: contentOffset)
        return pageFor(virtualPage: result)
    }
    
    func virtualPageFor(contentOffset: CGFloat) -> Int {
        return Int((contentOffset + 1.5 * pageWidth) / pageWidth) - 1
    }
    
    func pageFor(virtualPage: Int) -> Int {
        if virtualPage < 0 {
            return 0
        }
        if virtualPage > viewControllers.count - 1 {
            return viewControllers.count - 1
        }
        return virtualPage
    }
    
    func updateContent() { //updates scrollview
        if lastSize.width != containerView.bounds.size.width {
            lastSize = containerView.bounds.size
            containerView.contentOffset = CGPoint(x: pageOffsetForChild(at: currentIndex), y: 0) //
        }
        lastSize = containerView.bounds.size
        
        let pageViewControllers = ChildViewControllersForScrolling ?? viewControllers
        //set scrollview Content size equal to number service (each service has one separate tableview)
        containerView.contentSize = CGSize(width: containerView.bounds.width * CGFloat(pageViewControllers.count), height: containerView.contentSize.height)
        
        for (index, childController) in pageViewControllers.enumerated()
        {
            let pageOffsetForChild = self.pageOffsetForChild(at: index)
            if fabs(containerView.contentOffset.x - pageOffsetForChild) < containerView.bounds.width
            {
                if childController.parent != nil {
                    childController.view.frame = CGRect(x: offsetForChild(at: index), y: 0, width: view.bounds.width, height: containerView.bounds.height)
                    childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                }
                else {
                    childController.beginAppearanceTransition(true, animated: false)
                    addChildViewController(childController)
                    childController.view.frame = CGRect(x: offsetForChild(at: index), y: 0, width: view.bounds.width, height: containerView.bounds.height)
                    childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    containerView.addSubview(childController.view)
                    childController.didMove(toParentViewController: self)
                    childController.endAppearanceTransition()
                }
            }
            else {
                if childController.parent != nil {
                    childController.beginAppearanceTransition(false, animated: false)
                    childController.willMove(toParentViewController: nil)
                    childController.view.removeFromSuperview()
                    childController.removeFromParentViewController()
                    childController.endAppearanceTransition()
                }
            }
        }
        
        let oldCurrentIndex = currentIndex
        let virtualPage = virtualPageFor(contentOffset: containerView.contentOffset.x)
        let newCurrentIndex = pageFor(virtualPage: virtualPage)
        currentIndex = newCurrentIndex
        preCurrentIndex = currentIndex
        let changeCurrentIndex = newCurrentIndex != oldCurrentIndex
        
        if let progressiveDelegate = self as? TabViewProgressDelegate {
            
            let (fromIndex, toIndex, scrollPercentage) = progressiveIndicatorData(virtualPage)
            progressiveDelegate.updateIndicator(for: self, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: scrollPercentage, indexWasChanged: changeCurrentIndex)
        } else {
            delegate?.updateIndicator(for: self, fromIndex: min(oldCurrentIndex, pageViewControllers.count - 1), toIndex: newCurrentIndex)
        }
    }
    
    func reloadPagerTabStripView() {
        guard isViewLoaded else { return }
        for childController in viewControllers where childController.parent != nil {
            childController.beginAppearanceTransition(false, animated: true)
            childController.willMove(toParentViewController: nil)
            childController.view.removeFromSuperview()
            childController.removeFromParentViewController()
            childController.endAppearanceTransition()
        }
        //MARK:- reloadViewController() should be called Only When viewController Order or number of view Controller varies
        
        // that means use this function only on service reordering ViewContorller ViewdidDisappearing method
        // Or else this will cause unwanted reloading of viewcontrollers ,this will reset the scrolling position after the callout .
        if SearchResultsViewModel.isViewControllersAltered == true
        {
            performUIUpdatesOnMain {
                self.reloadViewControllers()
                SearchResultsViewModel.isViewControllersAltered = false
            }
        }
        containerView.contentSize = CGSize(width: containerView.bounds.width * CGFloat(viewControllers.count), height: containerView.contentSize.height)
        if currentIndex >= viewControllers.count {
            currentIndex = viewControllers.count - 1
        }
        preCurrentIndex = currentIndex
        containerView.contentOffset = CGPoint(x: pageOffsetForChild(at: currentIndex), y: 0)
        performUIUpdatesOnMain {
                self.updateContent()
        }
    }
    
    // - UIScrollDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //updates scrollview content
        if containerView == scrollView {
            updateContent()
            lastContentOffset = scrollView.contentOffset.x //last contentOffset has only horizondal view movement
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if containerView == scrollView  {
            lastPageNumber = pageFor(contentOffset: scrollView.contentOffset.x)
            lastScrollViewYPossition = scrollView.contentOffset.y
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if containerView == scrollView {
            ChildViewControllersForScrolling = nil
            (navigationController?.view ?? view).isUserInteractionEnabled = true
            updateContent() //perfrom updates in scrollview
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isViewRotating = true
        pageBeforeRotate = currentIndex
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let me = self else { return }
            me.isViewRotating = false
            me.currentIndex = me.pageBeforeRotate
            me.preCurrentIndex = me.currentIndex
            me.updateIfNeeded()
        }
    }
    
    private func progressiveIndicatorData(_ virtualPage: Int) -> (Int, Int, CGFloat) {
        let count = viewControllers.count
        var fromIndex = currentIndex
        var toIndex = currentIndex
        let direction = swipeDirection
        
        if direction == .left {
            if virtualPage > count - 1 {
                fromIndex = count - 1
                toIndex = count
            } else {
                if self.scrollPercentage >= 0.5 {
                    fromIndex = max(toIndex - 1, 0)
                } else {
                    toIndex = fromIndex + 1
                }
            }
        } else if direction == .right {
            if virtualPage < 0 {
                fromIndex = 0
                toIndex = -1
            } else {
                if self.scrollPercentage > 0.5 {
                    fromIndex = min(toIndex + 1, count - 1)
                } else {
                    toIndex = fromIndex - 1
                }
            }
        }
        
        return (fromIndex, toIndex, self.scrollPercentage)
    }
    
    func reloadViewControllers() {
        guard let dataSource = datasource else {
            fatalError("dataSource must not be nil")
        }
        viewControllers = dataSource.viewControllers(for: self)
        // viewControllers
        guard !viewControllers.isEmpty else {
            fatalError("viewControllers(for:) should provide at least one child view controller")
        }
        viewControllers.forEach { if !($0 is IndicatorInfoProvider) { fatalError("Every view controller provided by PagerTabStripDataSource's viewControllers(for:) method must conform to  InfoProvider") }}
        
    }
    
}

