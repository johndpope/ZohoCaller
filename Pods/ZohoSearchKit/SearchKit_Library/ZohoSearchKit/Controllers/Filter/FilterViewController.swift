//
//  FilterViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/02/18.
//

import UIKit

protocol FilterSelectionDelegate: class {
    func TitleHeaderTapped( section: Int , offset : CGPoint)
    
}
class FilterViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    var isSearchBarEmpty = true
    var searchText = ""
  
    var currentFilter: FilterResultViewModel{
        get{
            let selected_service_Name : String = SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!
            for service in SearchResultsViewModel.FilterSections
            {
                if service.serviceName == selected_service_Name
                {
                    return service
                }
            }
            return self.currentFilter
        }
        set{
            let selected_service_Name : String = SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!
            for (index,service) in SearchResultsViewModel.FilterSections.enumerated()
            {
                if service.serviceName == selected_service_Name
                {
                    SearchResultsViewModel.FilterSections[index] = newValue
                    break
                }
            }
        }
    }
    func configurenavigationBar()
    {
        filterVCNavigationBarView.backgroundColor = SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color
        backButton.tintColor = SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color
        resetButton.tintColor = SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color
        applyButton.layer.cornerRadius = 5
        applyButton.backgroundColor = SearchKitConstants.ColorConstants.NavigationBar_Items_Tint_Color
        applyButton.tintColor = SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.zPosition = CGFloat.Magnitude.greatestFiniteMagnitude
        configurenavigationBar()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        //ListView or DropDownView files
        self.tableView?.register(FilterVCListView.nib, forCellReuseIdentifier: FilterVCListView.identifier)
        self.tableView.register(FilterVCListViewTitle.nib, forHeaderFooterViewReuseIdentifier: FilterVCListViewTitle.identifier)
        self.tableView.register(FilterVCListViewTitleWithSearchBar.nib, forHeaderFooterViewReuseIdentifier: FilterVCListViewTitleWithSearchBar.identifier)
        // segmented view files
        self.tableView?.register(FilterVCSegmentedView.nib, forCellReuseIdentifier: FilterVCSegmentedView.identifier)
        self.tableView.register(FilterVCSegmentedViewTitle.nib, forHeaderFooterViewReuseIdentifier: FilterVCSegmentedViewTitle.identifier)
        //CheckBox and FooterView files
        self.tableView.register(FilterVCCheckBox.nib, forHeaderFooterViewReuseIdentifier: FilterVCCheckBox.identifier)
        self.tableView.register(FilterVCFooterView.nib, forCellReuseIdentifier: FilterVCFooterView.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SearchResultsViewModel.searchWhenLoaded = false
    }
    @IBOutlet weak var filterVCNavigationBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    static func vcInstanceFromStoryboard() -> FilterViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: FilterViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? FilterViewController
    }
    
    static func presentVC() {
        ZohoSearchKit.sharedInstance().searchViewController?.present(vcInstanceFromStoryboard()!, animated: true, completion: nil)
    }
    func dismissFilterVC()
    {
        let parentVC = self.getParentViewController()
        let hidenView = parentVC?.view.viewWithTag(654321)
        UIView.animate(withDuration: 0.3,
                       animations:
            {
                self.view.center =  CGPoint(x:(self.view.center.x)  + (self.view.frame.width) , y: (self.view.center.y) )
        },
                       completion:
            {
                (complete) in
                hidenView?.removeFromSuperview()
                parentVC?.remove(childViewController: self)
        }
        )
    }
    @IBAction func reSetToDefault(_ sender: UIButton) {
        
        FilterVCHelper.sharedInstance().resetService(filterResultModal: currentFilter)
        performUIUpdatesOnMain {
             self.tableView.reloadData()
        }
       
    }
    @IBAction func didFilterButtonTapped(_ sender: Any) {
        // Apply selected filters in search Query
        // selectedfilterName parameter will hold the selected filter
        SearchResultsViewModel.ResultVC.isFilterEnabled = true
        var searchFilters = [String : AnyObject]()
        for section in 0..<currentFilter.filtersResultArray.count
        {
            let filterModule = currentFilter.filtersResultArray[section]
            if  filterModule.filterViewType == .dropDownView
            {
                filterModule.defaultSelectionName = filterModule.selectedFilterName
                filterModule.defaultSelectionServerValue = filterModule.selectedFilterServerValue
                filterModule.defaultSelectionServerValue_2 = filterModule.selectedFilterServerValue_2
                if  filterModule.filterServerKey  != nil
                {
                    searchFilters[filterModule.filterServerKey!] = filterModule.selectedFilterServerValue as AnyObject
                }
                if filterModule.filterServerKey_2  != nil // MARK:- Date Filter has 2 keys
                {
                    searchFilters[filterModule.filterServerKey_2!] = filterModule.selectedFilterServerValue_2 as AnyObject
                }
            }
            else if filterModule.filterViewType == .segmentedView
            {
                filterModule.sortByFilterDefultIndex = filterModule.sortBYFIlterSelectedIndex
                if   filterModule.sortBYFIlterSelectedIndex == 0 //cell.SortBySelector.selectedSegmentIndex == 0
                {
                    searchFilters[FilterConstants.Keys.SORTBY] = FilterConstants.Values.Sortby.TIME as AnyObject
                }
                else if filterModule.sortBYFIlterSelectedIndex == 1//cell.SortBySelector.selectedSegmentIndex == 1
                {
                    searchFilters[FilterConstants.Keys.SORTBY] = FilterConstants.Values.Sortby.RELAVANCE as AnyObject
                }
            }
            else if filterModule.filterViewType == .flagView
            {
                
                filterModule.CheckBoxDefaultStatus = filterModule.CheckBoxSelectedStatus
                if   filterModule.CheckBoxSelectedStatus == true
                {
                    searchFilters[filterModule.filterServerKey!] = true as AnyObject //MARK:- add to query object only if checkbox is set.
                }
                else
                {
                    // if it is not enabled then we dont add it to search query
                }
            }
        }
        performUIUpdatesOnMain {
            self.currentFilter.filterSearchQuery = searchFilters as [String : AnyObject]
            //            self.dismiss(animated: false, completion: nil)
            let parentVC = self.getParentViewController()
            parentVC?.viewWillAppear(false)
            self.dismissFilterVC()
        }
    }
    //MARK :- Ignore the selected filters state and restore it with default selection values
    @IBAction func didBackButtonPressed(_ sender: Any) {
        SearchResultsViewModel.ResultVC.isFilterEnabled = false
        SearchResultsViewModel.searchFilters = nil
       FilterVCHelper.sharedInstance().resetBackToDefaultState(filterResultModal: currentFilter)

        self.dismissFilterVC()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let module = currentFilter.filtersResultArray[section]
        if module.filterViewType == .dropDownView
        {
            if module.isDropViewExpanded == true
            {
                return (module.searchResults?.count)!
            }
            else
            {
                let selectedFilter = currentFilter.filtersResultArray[section].selectedFilterName
                if selectedFilter == FilterConstants.DisPlayValues.Date.CUSTOM_RANGE || selectedFilter == FilterConstants.DisPlayValues.Date.SPECIFIC_DATE
                {
                    return 1
                }
                return 0
            }
        }
        else // for sortby filter and checkbox filter section
        {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentFilter.filtersCount
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let module = currentFilter.filtersResultArray[section]
        if (module.filterViewType == .dropDownView)
        {
            if module.isDropViewExpanded == true && (module.filtersBackUp?.count)! > SearchResultsViewModel.ResultVC.searchBarThreshold
            {
                return 150
            }
            else
            {
                return 100
            }
        }
        else if module.filterViewType == .segmentedView{ // segmented view height and flag view
            return 100
        }
        else
        {
            return 50
        }
    }
    func TitleHeaderTapped(section: Int , offset: CGPoint) {
        performUIUpdatesOnMain {
            let indexPath = IndexPath(row:0,section:section)
            let dropDownStatus : Bool = {
                let module =  self.currentFilter.filtersResultArray[section]
                return (module.filterViewType == .dropDownView ? module.isDropViewExpanded : false)
            }()
            if dropDownStatus == false
            {
                for (i , filter) in self.currentFilter.filtersResultArray.enumerated()
                {
                    if filter.isDropViewExpanded == true
                    {
                        let filter_index = IndexPath(row: 0, section: i)
                        let (_ , _ ) = self.UpdateSearchResults(newString: "", section: i)
                        self.changeDropDownStatus(indexpath: filter_index, changeTo: false)
                        self.collapseCell(indexpath: filter_index)
                    }
                }
                self.changeDropDownStatus(indexpath: indexPath, changeTo: true)
                self.expandCell(indexpath: indexPath)
            }
            else
            {
                self.changeDropDownStatus(indexpath: indexPath, changeTo: false)
                self.collapseCell(indexpath: indexPath)
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        func CreateSearchableHeaderview(filterModule : FilterModule,at section :Int) -> FilterVCListViewTitleWithSearchBar
        {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterVCListViewTitleWithSearchBar.identifier) as! FilterVCListViewTitleWithSearchBar
            header.filterModule = filterModule
            header.section = section
            header.delegate = self
            header.searchBar.delegate = self
            header.searchBar.section = section
            return header
        }
        func CreateHeaderview(filterModule : FilterModule,at section :Int) -> FilterVCListViewTitle
        {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterVCListViewTitle.identifier) as! FilterVCListViewTitle
            header.filterModule = filterModule
            header.section = section
            header.delegate = self
            return header
        }
        let module =  currentFilter.filtersResultArray[section]
        if  ( module.filterViewType == .dropDownView)
        {
            if module.isDropViewExpanded == true
            {
                if  (module.filtersBackUp?.count)! > SearchResultsViewModel.ResultVC.searchBarThreshold// header view with search bar
                {
                    return CreateSearchableHeaderview(filterModule : module ,at: section)
                }
                else // header with without search bar
                {
                    return CreateHeaderview(filterModule: module, at: section)
                }
            } // header with without search bar
            else
            {
                return CreateHeaderview(filterModule: module, at: section)
            }
        } // header view for  sort by filter
        else if  ( module.filterViewType == .segmentedView)
        {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterVCSegmentedViewTitle.identifier) as! FilterVCSegmentedViewTitle
            header.filterModule = module
            header.section = section
            header.delegate = self
            return header
        }
        else //if  ( module.filterViewType == .flagView)
        {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterVCCheckBox.identifier) as! FilterVCCheckBox
            header.section = section
            header.filterModule = module
            header.delegate = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let module = currentFilter.filtersResultArray[indexPath.section]
        if module.filterViewType == .dropDownView // Drop Down View
        {
            if module.isDropViewExpanded == true
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterVCListView.identifier) as! FilterVCListView
                cell.indexPath = indexPath
                cell.filterModule = module
                return cell
            }
            else // if dropdowntable is not visible ,then there will be no cell
            {
                if module.filterName == FilterConstants.Module.MailModules.DATE
                {
                    let footer = tableView.dequeueReusableCell(withIdentifier: FilterVCFooterView.identifier) as! FilterVCFooterView
                    footer.filterModule =  module
                    footer.FilterViewController = self
                    footer.section = indexPath.section
                    return footer
                }
            }
        }
        else  if module.filterViewType == .segmentedView // segmented View
        {
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = UpdateSearchResults(newString: "", section: indexPath.section)
        performUIUpdatesOnMain {
            let firstRowOfSection = IndexPath(row: 0, section: indexPath.section)
            let droptableCell =  ( tableView.cellForRow(at: indexPath) as! FilterVCListView )
            let selected_filter = droptableCell.NameLabel.text
            
            self.didDropTableViewCellSelected(indexpath: firstRowOfSection , selected_Filter : selected_filter!, selected_index: indexPath.row )
            self.changeDropDownStatus(indexpath: firstRowOfSection, changeTo: false)
            self.collapseCell(indexpath: firstRowOfSection)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
extension FilterViewController : CheckBoxDelegate
{
    func didStatusChangedIn(checkBoxHeader: FilterVCCheckBox) {
        currentFilter.filtersResultArray[checkBoxHeader.section].CheckBoxSelectedStatus =  checkBoxHeader.checkBox.status!
    }
}
extension FilterViewController : SegmentedHeaderDelegate
{
    func didSortByFilterChangedfor(header: FilterVCSegmentedViewTitle){
        currentFilter.filtersResultArray[header.section].sortBYFIlterSelectedIndex = header.SortBySelector.selectedSegmentIndex
    }
}
enum DateRequiredType {
    case SpecificDate
    case CustomRange
}
extension FilterViewController
{
    func changeDropDownStatus(indexpath : IndexPath ,changeTo : Bool)
    {
        let module =  currentFilter.filtersResultArray[indexpath.section]
        if module.filterViewType == .dropDownView
        {
            module.isDropViewExpanded = changeTo
            //Reset results if DropDown is closed
            if changeTo == false
            {
                module.searchResults = module.filtersBackUp
            }
        }
    }
    func expandCell(indexpath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: indexpath.section) as IndexSet, with: .fade)
        tableView.endUpdates()
    }
    func collapseCell(indexpath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: indexpath.section) as IndexSet, with: .fade)
        tableView.endUpdates()
    }
    func showDatePicker(fortype : DateRequiredType,filterModule : FilterModule , currentSelectionName : String , oldSlectionName : String)
    {
        let actionViewHeight = CGFloat(50)
        let screenHeight =  (UIScreen.main.fixedCoordinateSpace.bounds.height)
        let screenWidth =  (UIScreen.main.fixedCoordinateSpace.bounds.width)
        let datePickerHeight = (screenHeight / 2) - actionViewHeight
        let datePickerViewY = screenHeight - datePickerHeight
        let rect = CGRect(x: 2, y: datePickerViewY, width: screenWidth - 4, height: datePickerHeight)
        var fromDate = Date()
        var toDate = Date()
        // MARK:- this selected name is previous selection name not current one
        if (currentSelectionName == oldSlectionName) //filterModule.selectedFilterName this is old selection
        {
            if filterModule.selectedFilterServerValue != nil
            {
                fromDate = Date.serverDateFormate.date(from: filterModule.selectedFilterServerValue!)!
            }
            if filterModule.selectedFilterServerValue_2 != nil
            {
                toDate = Date.serverDateFormate.date(from: filterModule.selectedFilterServerValue_2!)!
            }
        }
        let datePickerView = DatePickerView(frame: rect, filtermodule: filterModule ,fromdate : fromDate , todate : toDate,fromToselectedIndex : 0 , datePickertype : fortype)
        datePickerView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 356)
        UIView.animate(withDuration: 0.3, animations: {
            datePickerView.frame = rect
        })
        
        datePickerView.tag = 1111
        let parentVC = self.getParentViewController()
        datePickerView.layoutIfNeeded()
        //disabling user interation
        let  datePickBaseView = UIView()
        datePickBaseView.frame = (parentVC?.view.frame)!
        datePickBaseView.alpha = 1
        datePickBaseView.backgroundColor = .clear
        datePickBaseView.tag = 1212
        parentVC?.view.addSubview(datePickBaseView)
        
        parentVC?.view.addSubview(datePickerView)
    }
    func datepickerfor(filterModule : FilterModule , newselectedFilterName : String , oldselectedFilterName : String)
    {
        if filterModule.filterName == FilterConstants.Module.CliqModules.DATE {
            //calculate from date and to date
            var fromDate : String = String()
            var toDate : String = String()
            switch newselectedFilterName
            {
            case FilterConstants.DisPlayValues.Date.ALL_DAYS:
                break
            case FilterConstants.DisPlayValues.Date.TODAY:
                fromDate = Date.today
                toDate = Date.today
            case FilterConstants.DisPlayValues.Date.YESTERDAY:
                fromDate = Date.yesterday
                toDate = Date.yesterday
            case FilterConstants.DisPlayValues.Date.LAST_7_DAYS:
                fromDate = Date.Last7thday
                toDate = Date.today
            case FilterConstants.DisPlayValues.Date.THIS_MONTH:
                fromDate = Date.ThisMonthFirstDay
                toDate = Date.today
            case FilterConstants.DisPlayValues.Date.THISYEAR:
                fromDate = Date.ThisYearFirstDay
                toDate = Date.today
            case FilterConstants.DisPlayValues.Date.SPECIFIC_DATE:
                showDatePicker(fortype : .SpecificDate, filterModule: filterModule,currentSelectionName : newselectedFilterName, oldSlectionName: oldselectedFilterName )
            case FilterConstants.DisPlayValues.Date.CUSTOM_RANGE:
                showDatePicker(fortype : .CustomRange, filterModule: filterModule ,currentSelectionName : newselectedFilterName, oldSlectionName: oldselectedFilterName)
            default:
                break
            }
            
            //dont sent date query when all days is selected
            if newselectedFilterName == FilterConstants.DisPlayValues.Date.ALL_DAYS
            {
                filterModule.filterServerKey = nil
                filterModule.filterServerKey_2 = nil
                filterModule.selectedFilterServerValue = nil
                filterModule.selectedFilterServerValue_2 = nil
            }
            else // if its not all Days form filter query
            {
                //MARK:- If user selects specific date or custom date query will be seted in DatePickerView itself
                if (newselectedFilterName != FilterConstants.DisPlayValues.Date.SPECIFIC_DATE) &&
                    (newselectedFilterName != FilterConstants.DisPlayValues.Date.CUSTOM_RANGE)
                {
                    filterModule.filterServerKey = FilterConstants.Keys.DateFilterKeys.FROM_DATE
                    filterModule.filterServerKey_2 = FilterConstants.Keys.DateFilterKeys.TO_DATE
                    filterModule.selectedFilterServerValue = fromDate
                    filterModule.selectedFilterServerValue_2 = toDate
                }
            }
        }
    }
    func didDropTableViewCellSelected(indexpath: IndexPath, selected_Filter: String, selected_index: Int) {
        let currentFilterResultModal = currentFilter
        let currentFilterModule = currentFilterResultModal.filtersResultArray[indexpath.section]
        
        if currentFilterModule.filterViewType == .dropDownView
        {
            if currentFilterModule.isDropViewExpanded == true
            {
                if  currentFilterModule.filterName == FilterConstants.Module.MailModules.ACCOUNT &&
                    currentFilterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail
                {
                    currentFilterModule.selectedFilterName = selected_Filter
                    currentFilterModule.selectedFilterServerValue =  selected_Filter
                    let defaultAccountEmailId :Int64 = Int64(currentFilterModule.filterNameServerValuePairs![selected_Filter]!)!
                    FilterVCHelper.sharedInstance().resetFoldersAndTagsForMail(filterModal: currentFilterResultModal, defaultAccountEmailId: defaultAccountEmailId, selected_Filter: selected_Filter, tableView: tableView)
                    performUIUpdatesOnMain {
                         self.tableView.reloadData()
                    }
                   
                }
                else if currentFilterModule.filterName == FilterConstants.Module.WikiModules.Wiki_Types &&
                    currentFilterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki
                {
                   currentFilterModule.selectedFilterName =  selected_Filter
                    FilterVCHelper.sharedInstance().resetWIkiPortals(filterModal: currentFilterResultModal, selected_Filter: selected_Filter)
                    performUIUpdatesOnMain {
                         self.tableView.reloadData()
                    }
                   
                } // Account if ends
                else  if  currentFilterModule.filterName == FilterConstants.Module.DeskModules.PORTAL &&
                currentFilterResultModal.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk
                {
                    // getting selected Portal Id
                    currentFilterModule.selectedFilterName = selected_Filter
                    currentFilterModule.selectedFilterServerValue =   currentFilterModule.filterNameServerValuePairs![selected_Filter]!
                    
                    let defaultPortalId :Int64  = Int64(currentFilterModule.filterNameServerValuePairs![selected_Filter]!)!
                    FilterVCHelper.sharedInstance().reSetDeskDepartmentAndModules(filterModal: currentFilterResultModal, defaultPortalId: defaultPortalId)
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                    
                }
                else if currentFilterModule.filterName == FilterConstants.Module.MailModules.DATE
                {
                    self.datepickerfor(filterModule:  currentFilterModule, newselectedFilterName: selected_Filter, oldselectedFilterName: currentFilterModule.selectedFilterName!)
                    //MARK:- we should update selected filter only after date picked because we need previous selected name to set date picker date . if he selects same filter again
                    currentFilterModule.selectedFilterName = selected_Filter
                    // we dont need the selection Id here because we have to calculate it based on the
                }
                else{ // MARK:- for others ,Folders,Tags,SearchIN,
                    currentFilterModule.selectedFilterName = selected_Filter
                    currentFilterModule.selectedFilterServerValue =   currentFilterModule.filterNameServerValuePairs![selected_Filter]!
                }
            }
        }
        else // SortBy filter
        {
            //we will handle sort by filter in filterbutton tapped function
        }
    }
}
