//
//  SavedSearchViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 31/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit
import CoreData

//Will be opened from SearchSettingsViewController and this will just allow the user to get list of the saved searched.
class SavedSearchViewController: ZSViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var fetchedResultsController: NSFetchedResultsController<SavedSearches> = {
        let accountZUIDPredicate = #keyPath(SavedSearches.account_zuid)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SavedSearches> = SavedSearches.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SavedSearches.lmtime), ascending: false)]
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
    
    static func vcInstanceFromStoryboard() -> SavedSearchViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SavedSearchViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? SavedSearchViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.hidesNavigationBarDuringPresentation = false //this will make search bar present at the same place. It will not move to the nav bar
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barStyle = .default
        //searchController.searchBar.backgroundImage = nil
        searchController.searchBar.barTintColor = SearchKitConstants.ColorConstants.SettingsSearchBarTintColor
        searchController.searchBar.layer.borderWidth = 1;
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.keyboardDismissMode = .onDrag
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(SavedSearchItemTableViewCell.nib, forCellReuseIdentifier: SavedSearchItemTableViewCell.identifier)
        
        do {
            try self.fetchedResultsController.performFetch()
            
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
    
    @IBAction func didPressBack(_ sender: UIButton) {
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

//search and load
extension SavedSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let accountZUIDPredicate = #keyPath(SavedSearches.account_zuid)
        if searchController.searchBar.text! == "" {
            do {
                //reset the predicate
                //self.fetchedResultsController.fetchRequest.predicate = nil
                //set account predicate
                let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = %d", Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
                self.fetchedResultsController.fetchRequest.predicate = accountPredicate
                
                try self.fetchedResultsController.performFetch()
                
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        } else {
            var predicate = NSPredicate(format: #keyPath(SavedSearches.saved_search_name) + " LIKE[c] " + SearchKitConstants.FormatStringConstants.String, searchController.searchBar.text!+"*")
            //adding accounts predicate for multi account support
            let accountPredicate = NSPredicate(format: accountZUIDPredicate + " = " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, Int64(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)!)
            predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate, accountPredicate])
            self.fetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}

extension SavedSearchViewController: UISearchBarDelegate {
    //when cancel button is pressed, offset will be reset.
    //actually it does not make the expected change. Searchbar remains hidden.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performUIUpdatesOnMain {
            //self.tableView.scrollToTop(animated: true)
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.searchController.searchBar.bounds.height + self.searchController.searchBar.bounds.height)) , animated: true)
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //when search box is clicked, it will move the table view adjacent to the search box
        let offset = CGPoint.init(x: 0, y: self.searchController.searchBar.bounds.height)
        performUIUpdatesOnMain {
            self.tableView.setContentOffset(offset, animated: true)
        }
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

extension SavedSearchViewController: UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: SavedSearchItemTableViewCell.identifier) as! SavedSearchItemTableViewCell
            cell.savedSearch = fetchedResultsController.object(at: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SavedSearchViewController: UITableViewDelegate {
    
    //TODO: duplicated code from SearchQueryViewController, we should unify the code
    //to set the filter and initiate Search Call
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //SnackbarUtils.showMessageWithDismiss(msg: "Not action supported yet!")
        
        //TODO: this clear can be an issue, if any state need to be cleared
        //then clear it here. clearing the search box and reseting state
        //is not same as clearing state for selection of suggestion clearing state
        //self.searchbar.isclearButtonTapped()
        var cell = tableView.cellForRow(at: indexPath) as? SavedSearchItemTableViewCell
        //MARK: Important - This cell can be nil when we have user selected for @mention and when we do view more in the history or saved search
        //suggestion and select one from the last or so. Reason being those cells can be out of view even though
        //visible, it might not have cleared the older cells.
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: SavedSearchItemTableViewCell.identifier, for: indexPath) as? SavedSearchItemTableViewCell
            let savedSearch = fetchedResultsController.object(at: indexPath)
            cell?.savedSearch = savedSearch
            
        }
        if cell != nil
        {
               FilterVCHelper.sharedInstance().ConvertDataAndPresentResultVC(from: (cell?.savedSearch)!)
        }

        //cell will be used when we support saved searches search from suggestion tap
        //SnackbarUtils.showMessageWithDismiss(msg: "Not supported yet!")
     
   
        //set service state
        //deselect after operation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//not needed as we are not supporting delete of saved search in this view controller.
//only in the details page it can be deleted
extension SavedSearchViewController: NSFetchedResultsControllerDelegate {
    
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
