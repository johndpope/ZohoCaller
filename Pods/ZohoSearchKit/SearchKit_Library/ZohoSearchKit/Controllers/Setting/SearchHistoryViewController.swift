//
//  SearchHistoryViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 31/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit
import CoreData

//TODO: Incremental loading
//Will be opened from SearchSettingsViewController and this will just allow the user to check the search history
class SearchHistoryViewController: ZSViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    //var hasMoreHistory: Bool = true
    //var fetchedCount: Int = 0
    //let fetchCount: Int = 50
    
    lazy var fetchedResultsController: NSFetchedResultsController<SearchHistory> = {
        let accountZUIDPredicate = #keyPath(SearchHistory.account_zuid)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SearchHistory.timestamp), ascending: false)]
        //fetchRequest.fetchBatchSize = 20
        
        //set limit
        fetchRequest.fetchLimit = 200
        fetchRequest.fetchOffset = 0
        //for now anytime, first 200 will be fetched, if the user wants more he/she has to search for some keyword.
        //no infinite scrolling supported now.
        
        //set account predicate
        let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = %d", Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
        fetchRequest.predicate = accountPredicate
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    static func vcInstanceFromStoryboard() -> SearchHistoryViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SearchHistoryViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? SearchHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.hidesNavigationBarDuringPresentation = false //this will make search bar present at the same place. It will not move to the nav bar
        
        self.definesPresentationContext = true
        //definesPresentationContext = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barStyle = .default
        //searchController.searchBar.backgroundImage = nil
        searchController.searchBar.barTintColor = SearchKitConstants.ColorConstants.SettingsSearchBarTintColor
        searchController.searchBar.layer.borderWidth = 1;
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        searchController.searchBar.autoresizingMask = .flexibleTopMargin
        tableView.tableHeaderView = searchController.searchBar
        tableView.keyboardDismissMode = .onDrag
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(HistoryItemTableViewCell.nib, forCellReuseIdentifier: HistoryItemTableViewCell.identifier)
        
        do {
            try self.fetchedResultsController.performFetch()
            
            //incremental loading
            //            if (fetchedResultsController.fetchedObjects?.count)! < fetchCount {
            //                hasMoreHistory = false
            //            }
            //            else {
            //                hasMoreHistory = true
            //            }
            
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let count = fetchedResultsController.fetchedObjects?.count, count > 0 {
            let firstRowIndexPath = IndexPath(row: 0, section: 0)
            performUIUpdatesOnMain {
                self.tableView.scrollToRow(at: firstRowIndexPath, at: UITableViewScrollPosition.top, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        searchController.isActive = false
        //self.dismiss(animated: false, completion: nil)
        
        //push model using settings vc wrapped into navigation view controller
        //ZohoSearchKit.sharedInstance().settingsViewController?.navigationController?.popViewController(animated: true)
        
        //push model using the application view controller
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SearchHistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let accountZUIDPredicate = #keyPath(SearchHistory.account_zuid)
        if searchController.searchBar.text! == "" {
            do {
                //reset the predicate
                //self.fetchedResultsController.fetchRequest.predicate = nil
                //set account predicate
                let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = %d", Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
                self.fetchedResultsController.fetchRequest.predicate = accountPredicate
                
                //incremental
                //                self.fetchedResultsController.fetchRequest.fetchOffset = 0
                //                self.fetchedResultsController.fetchRequest.fetchLimit = fetchCount
                
                try self.fetchedResultsController.performFetch()
                
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        } else {
            var predicate = NSPredicate(format: #keyPath(SearchHistory.search_query) + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String, searchController.searchBar.text!+"*")
            //adding accounts predicate for multi account support
            let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
            predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate, accountPredicate])
            self.fetchedResultsController.fetchRequest.predicate = predicate
            
            //incremental
            //            self.fetchedResultsController.fetchRequest.fetchOffset = 0
            //            self.fetchedResultsController.fetchRequest.fetchLimit = fetchCount
            
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        //incremental
        //        if (fetchedResultsController.fetchedObjects?.count)! < fetchCount {
        //            hasMoreHistory = false
        //        }
        //        else {
        //            hasMoreHistory = true
        //        }
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}

extension SearchHistoryViewController: UISearchBarDelegate {
    //when cancel button is pressed, offset will be reset.
    //actually it does not make the expected change. Searchbar remains hidden.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performUIUpdatesOnMain {
            //self.tableView.scrollToTop(animated: true)
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.searchController.searchBar.bounds.height + self.searchController.searchBar.bounds.height)) , animated: true)
//            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //when search box is clicked, it will move the table view adjacent to the search box
//        let offset = CGPoint.init(x: 0, y: 0)
//        performUIUpdatesOnMain {
//            self.tableView.setContentOffset(offset, animated: true)
//        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //navigationItem.titleView = searchController.searchBar
        return true
    }
    
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        self.searchController.searchBar.showsCancelButton = false
    //        self.searchController.searchBar.text = ""
    //        self.searchController.searchBar.endEditing(true)
    //        performUIUpdatesOnMain {
    //            self.searchController.searchBar.frame.origin = CGPoint(x: self.view.frame.minX, y: self.view.frame.midY)
    //        }
    //    }
}

extension SearchHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            //return (fetchedResultsController.fetchedObjects?.count)!
            guard fetchedResultsController.sections != nil else {
                return 0
            }
            return (fetchedResultsController.fetchedObjects?.count)!
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    //remove unanted space from bottom of the tableview
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryItemTableViewCell.identifier) as! HistoryItemTableViewCell
            cell.history = fetchedResultsController.object(at: indexPath)
            cell.delegate = self
            
            ///incremental loading
            //            let historyCount = (fetchedResultsController.fetchedObjects?.count)!
            //            let fetchMoreThreshold =  historyCount - 1
            //            if hasMoreHistory, indexPath.row == fetchMoreThreshold {
            //                //then load more results
            //                self.fetchedResultsController.fetchRequest.fetchOffset = historyCount
            //                self.fetchedResultsController.fetchRequest.fetchLimit = fetchCount
            //                do {
            //                    try self.fetchedResultsController.performFetch()
            //
            //                    if (fetchedResultsController.fetchedObjects?.count)! < fetchCount {
            //                        hasMoreHistory = false
            //                    }
            //                    else {
            //                        hasMoreHistory = true
            //                    }
            //
            //                    performUIUpdatesOnMain {
            //                        self.tableView.reloadData()
            //                    }
            //
            //                } catch {
            //                    let fetchError = error as NSError
            //                    print("\(fetchError), \(fetchError.localizedDescription)")
            //                }
            //            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Do you want to search this?", message: "This history will be searched", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { (action:UIAlertAction) in
            let cell = tableView.cellForRow(at: indexPath) as! HistoryItemTableViewCell
            
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
            
            //            if let nav = ZohoSearchKit.sharedInstance().appViewController?.navigationController {
            //                let stack = nav.viewControllers
            //                var copyStack = [UIViewController]()
            //                var counter = 0;
            //                for vc in stack {
            //                    if !(vc is SearchHistoryViewController || vc is SearchSettingsViewController || vc is SearchResultsViewController) {
            //                        copyStack.append(vc)
            //                        //both pop and set nav bar should be there
            //                        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
            //                    }
            //                    counter = counter + 1
            //                }
            //                nav.setViewControllers(copyStack, animated: true)
            //            }
            
            //            if let nav = ZohoSearchKit.sharedInstance().appViewController?.navigationController {
            //                var stack = nav.viewControllers
            //                let vc = stack[stack.count - 1]
            //                if vc is SearchResultsViewController {
            //                    ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: false)
            //                }
            //            }
            
            let target = SearchResultsViewController.vcInstanceFromStoryboard()!
            target.currentIndex =  SearchResultsViewModel.selected_service
            
            let searchQueryAttribute = #keyPath(SearchHistory.search_query)
            SearchResultsViewModel.ResultVC.searchText = ((cell.history?.value(forKey: searchQueryAttribute)) as? String) ?? ""
            SearchResultsViewModel.searchWhenLoaded = true
            
            let mentionZUIDAttribute = #keyPath(SearchHistory.mention_zuid)
            if let zuid = (cell.history?.value(forKey: mentionZUIDAttribute) as? Int64), zuid != -1 {
                SearchResultsViewModel.QueryVC.suggestionContactName  = cell.userName.text!
                SearchResultsViewModel.QueryVC.isAtMensionSelected = true
                SearchResultsViewModel.QueryVC.isNamelabledisplay = false
                SearchResultsViewModel.QueryVC.suggestionZUID = zuid
                let contactNameAttribute = #keyPath(SearchHistory.mention_contact_name)
                SearchResultsViewModel.QueryVC.suggestionContactName = (cell.history?.value(forKey: contactNameAttribute) as? String)!
            }
            else {
                SearchResultsViewModel.QueryVC.suggestionContactName = ""
            }
            
            //            if let settingNav = self.navigationController {
            //                let stack = settingNav.viewControllers
            //                for vc in stack {
            //                    if vc is SearchSettingsViewController {
            //                        vc.dismiss(animated: false, completion: nil)
            //                    }
            //                    else {
            //                        settingNav.popViewController(animated: false)
            //                    }
            //                }
            //            }
            
            //TODO: We will use push modal for search settings as well.
            ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(target, animated: false)
            
            //as history has been presented as modal. So, need to call dismiss.
            //later will replace with navigation push so, it will not be an issue.
            //            self.parent?.dismiss(animated: false, completion: {
            //                print("dismissing")
            //            })
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(searchAction)
        self.present(alertController, animated: true, completion: nil)
        
        //deselect after operation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchHistoryViewController: HistoryListViewCellDelegate {
    func didTapDeleteHistoryItem(_ sender: HistoryItemTableViewCell) {
        let indexPath = tableView.indexPath(for: sender)
        let rowToDelete = fetchedResultsController.object(at: indexPath!)
        fetchedResultsController.managedObjectContext.delete(rowToDelete)
        do {
            try fetchedResultsController.managedObjectContext.save()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

extension SearchHistoryViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default :
            print("Not needed, illegal operation")
        }
    }
}
