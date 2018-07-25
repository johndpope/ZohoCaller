//
//  ResultVCSearchBar.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 15/02/18.
//

import UIKit
import CoreData

class ResultVCSearchBar: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftViewMode = .always
        changeServiceImge()
        self.layer.cornerRadius = 6
        self.shadow(color: UIColor.darkGray, offSet: CGSize(width: 0, height: 0))
    }
    // padding for contact icon
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        if let view = self.leftView {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left:(view.frame.width) + 10, bottom: 0, right: 0))
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 8 , bottom: 0, right: 0))
            //            return super.textRect(forBounds: bounds)
        }
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        super.placeholderRect(forBounds: bounds)
        if let view = self.leftView {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: view.frame.width + 10 , bottom: 0, right: 0))
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 8 , bottom: 0, right: 0))
            //            return super.placeholderRect(forBounds: bounds)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        if let view = self.leftView {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: view.frame.width + 10 , bottom: 0, right: 0))
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 8 , bottom: 0, right: 0))
            //            return super.editingRect(forBounds: bounds)
        }
    }
    
    
    func changeServiceImge()
    {
        // updating placeholder
        let currentServiceName = SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!
        if currentServiceName == ZOSSearchAPIClient.ServiceNameConstants.All
        {
            self.placeholder = "Search across Zoho"
        }
        else
        {
            self.placeholder = "Search..."
        }
        let service_view = UIView(frame :CGRect(x: 5 , y: 10,width : self.frame.height-18 , height: self.frame.height-18))
        let img:UIImage =  ServiceIconUtils.getServiceSelectedStateIcon(serviceName: SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!)!
        let imageView = UIImageView.createCircularImageViewWithInsetForGradient(image: img, insetPadding: 5, imageViewWidth: self.frame.height-18, imageViewHeight: self.frame.height-18)
        
        //Setting gradient, will later export this code outside
        let colorTop =  SearchKitConstants.ColorConstants.SelectedServiceGradientTopColor.cgColor
        let colorBottom = SearchKitConstants.ColorConstants.SelectedServiceGradientBottomColor.cgColor
        
        let view = UIView(frame: imageView.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = imageView.bounds
        gradientLayer.cornerRadius = (imageView.frame.width/2)
        view.layer.insertSublayer(gradientLayer, at: 0)
        service_view.addSubview(view)
        //setting gradient ends
        
        service_view.addSubview(imageView)
        
        let cimg:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!//SearchResultsViewModel.ResultVC.contactImage
      
        //MARK:- If we have Service Icone then, we need this rect
        //        let contact_view = UIView(frame: CGRect(x:self.frame.height-10 , y: 10, width: self.frame.height-20 , height: self.frame.height-20))
        //MARK:-below rect is for without rect
        let contact_view = UIView(frame: CGRect(x:5 , y: 10, width: self.frame.height-20 , height: self.frame.height-20))
        let imageV = UIImageView(image: cimg.imageWithInsets(insets: UIEdgeInsetsMake( 5, 5, 5, 0)))
        imageV.frame = CGRect(x: 0, y: 0, width: contact_view.frame.width, height: contact_view.frame.height)
        
        //make circle
        imageV.maskCircle(anyImage: cimg)
        contact_view.addSubview(imageV)
        contact_view.layer.zPosition = ZpositionLevel.high.rawValue
        let guesture = UITapGestureRecognizer(target: self, action: #selector(self.contactTouched))
        contact_view.addGestureRecognizer(guesture)
        
        ZohoSearchKit.sharedInstance().getImagefor(zuid: SearchResultsViewModel.QueryVC.suggestionZUID!, completionHandler: { (img,error)  in
            if let contactImage =  img
            {
                performUIUpdatesOnMain {
                    imageV.image = contactImage
                }
            }
        })
        //        let customLeftView = UIView(frame: CGRect(x: 0, y: 0, width:self.frame.height + contact_view.frame.width - 10 , height: self.frame.height))
        let customLeftView = UIView(frame: CGRect(x: 0, y: 0, width: contact_view.frame.width  , height: self.frame.height))
        
        //        customLeftView.addSubview(service_view)
        customLeftView.addSubview(contact_view)
        
        //Filter View
        
        let Fimg:UIImage = UIImage(named:"searchsdk-filter", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        
        //here 10 is padding
        let FimageView = UIImageView(image: Fimg.imageWithInsets(insets: UIEdgeInsetsMake(12, 12, 12, 12)))
        //here 60 is height, should be from image view container
        FimageView.frame = CGRect(x: 0, y: 0, width:self.frame.height , height: self.frame.height)
        
        //make circle
        FimageView.layer.cornerRadius = imageView.frame.size.width / 2;
        FimageView.clipsToBounds = true;
        FimageView.layer.masksToBounds = false
        
        let Filter_view = UIView(frame :CGRect(x: 0 , y: 0, width:self.frame.height , height: self.frame.height))
        //        service_view.backgroundColor  = UIColor.blue
        let Filter_guesture = UITapGestureRecognizer(target: self, action: #selector(self.FilterCliqed))
        Filter_view.addGestureRecognizer(Filter_guesture)
        
        Filter_view.addSubview(FimageView)
        
        
        switch SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.All?:
            performUIUpdatesOnMain {
                self.rightViewMode = .never
            }
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts?:
            performUIUpdatesOnMain {
                self.rightViewMode = .never
            }
        case ZOSSearchAPIClient.ServiceNameConstants.People?:
            performUIUpdatesOnMain {
                self.rightViewMode = .never
            }
        default:
            //enablefilter disablefilter
            self.rightViewMode = .always
            self.rightView = Filter_view
        }
        
        if SearchResultsViewModel.ResultVC.isContactSearch == false
        {
            performUIUpdatesOnMain
                {
                    //                    self.leftView = service_view
            }
        }
        else
        {
            performUIUpdatesOnMain
                {
                    self.leftView =  customLeftView
            }
        }
    }
    @objc func dismisFilterVC(_ sender : UIPanGestureRecognizer)
    {
        let parentVC = self.getParentViewController()
        let hidenView = parentVC?.view.viewWithTag(654321)
        var filterVC : FilterViewController?
        for viewController in (parentVC?.childViewControllers)!
        {
            if viewController is FilterViewController
            {
                filterVC = viewController as? FilterViewController
            }
        }
        parentVC?.view.bringSubview(toFront: (filterVC?.view)!)
        let translation = sender.translation(in:  parentVC?.view)
        let newMinX = ((filterVC?.view)?.frame.minX)! + translation.x
        let newCenterX = ((filterVC?.view)?.center.x)! + translation.x
        let originX = ((parentVC?.view.frame.width)! / 4 )
        
        if newMinX >= originX
        {
            filterVC?.view.center = CGPoint(x:newCenterX, y: ((filterVC?.view)?.center.y)! )
            sender.setTranslation(CGPoint.zero, in: parentVC?.view)
        }
        switch sender.state {
        case .ended ,.cancelled,.failed ,.possible:
            let originCenterX = originX + ((filterVC?.view.frame.width)! / 2)
            if (newMinX - originX) > 30 // threshold for closing filterview by sliding
            {
                hidenView?.removeFromSuperview()
                filterVC?.didBackButtonPressed(UIButton())
                parentVC?.remove(childViewController: filterVC!)
            }
            else
            {
                filterVC?.view.center = CGPoint(x:originCenterX, y: ((filterVC?.view)?.center.y)! )
                sender.setTranslation(CGPoint.zero, in: parentVC?.view)
            }
        default: break
        }
        
    }
    @objc func dismisFilterVCforTap(_ sender:UITapGestureRecognizer)
    {
        let parentVC = self.getParentViewController()
        let hidenView = parentVC?.view.viewWithTag(654321)
        var filterVC : FilterViewController?
        for viewController in (parentVC?.childViewControllers)!
        {
            if viewController is FilterViewController
            {
                filterVC = viewController as? FilterViewController
            }
        }
        
        UIView.animate(withDuration: 0.3,
                       animations:
            {
                filterVC?.view.center =  CGPoint(x:((filterVC?.view)?.center.x)!  + ((filterVC?.view)?.frame.width)!, y: ((filterVC?.view)?.center.y)! )
        },
                       completion:
            {
                (complete) in
                hidenView?.removeFromSuperview()
                filterVC?.didBackButtonPressed(UIButton())
                parentVC?.remove(childViewController: filterVC!)
        }
        )
        
    }
    func presentChildViewController()
    {
        if   let filterVC: FilterViewController = FilterViewController.vcInstanceFromStoryboard()
        {
            let parentVC = self.getParentViewController()
            let f_X : CGFloat = ((parentVC?.view.bounds.width)! / 4)
            var topSafeArea: CGFloat
            if #available(iOS 11.0, *) {
                topSafeArea = parentVC?.view.safeAreaInsets.top ?? 20
            } else {
                topSafeArea = parentVC?.topLayoutGuide.length ?? 20
            }
            let f_Y : CGFloat = topSafeArea //(self.frame.minX)
            let f_width : CGFloat = f_X * 3
            let f_Height : CGFloat = (parentVC?.view.bounds.height)! - f_Y
            let hidenView = UIView(frame: (parentVC?.view.layer.bounds)!)//UIView(frame: CGRect(x: 0, y: 0, width: f_X, height: f_Height))
            hidenView.backgroundColor = .black
            hidenView.layer.zPosition = CGFloat.Magnitude.greatestFiniteMagnitude
            hidenView.alpha = 0.5
            hidenView.tag = 654321
            let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(dismisFilterVC(_: )))
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismisFilterVCforTap(_:)))
            hidenView.addGestureRecognizer(panGuesture)
            hidenView.addGestureRecognizer(tapGesture)
            filterVC.view.frame = CGRect(x: f_X, y: f_Y , width: f_width, height: f_Height)
            parentVC?.view.addSubview(hidenView)
            parentVC?.add(childViewController: filterVC)
            //Slide out animation
            filterVC.view.center = CGPoint(x: filterVC.view.center.x + filterVC.view.frame.width, y: filterVC.view.center.y)
            UIView.animate(withDuration: 0.3, animations: {
                filterVC.view.center = CGPoint(x: filterVC.view.center.x - filterVC.view.frame.width, y: filterVC.view.center.y)
            })
            parentVC?.view.addConstraintwithFormate(format: "V:|[v0]|", views: hidenView)
            parentVC?.view.addConstraintwithFormate(format: "H:|[v0]|", views: hidenView)
            
        }
    }
    static  func createFilterViewModelForCurrentService(service: String) -> FilterResultViewModel
    {
        //TODO: in the filter storage we will need to store the filter value and also the id(string - 123 or allfolders)
        //which should be sent in the search request
        // Do any additional setup after loading the view.
        func createDateFilter() -> FilterModule
        {
            //MARK:- Date Filters for Mail
            let dateFilter :FilterModule = FilterModule()
            dateFilter.filterName = FilterConstants.DisPlayValues.DATE
            // date filter has 2 keys from date and to date so we create 2  key  in query formation
            // values are calculated from the display name , so we no need to store it
            dateFilter.filterViewType = .dropDownView
            dateFilter.defaultSelectionName = FilterConstants.DisPlayValues.Date.ALL_DAYS
            dateFilter.selectedFilterName = FilterConstants.DisPlayValues.Date.ALL_DAYS
            dateFilter.selectedFilterServerValue = "" // all days has no values we dont sent it to server .
            dateFilter.selectedFilterServerValue_2 = ""
            dateFilter.filterServerKey = nil //MARK:- if you make key  as nil ,it will be ignored in query formation
            dateFilter.filterServerKey_2 = nil // FilterConstants.Keys.DateFilterKeys.TO_DATE
            
            dateFilter.searchResults = [FilterConstants.DisPlayValues.Date.ALL_DAYS,
                                        FilterConstants.DisPlayValues.Date.TODAY,
                                        FilterConstants.DisPlayValues.Date.YESTERDAY,
                                        FilterConstants.DisPlayValues.Date.LAST_7_DAYS,
                                        FilterConstants.DisPlayValues.Date.THIS_MONTH,
                                        FilterConstants.DisPlayValues.Date.SPECIFIC_DATE,
                                        FilterConstants.DisPlayValues.Date.CUSTOM_RANGE]
            dateFilter.filtersBackUp = dateFilter.searchResults
            dateFilter.isDropViewExpanded = false
            return dateFilter
        }
        func createSortByFilter() -> FilterModule
        {
            let sortFilter :FilterModule = FilterModule()
            sortFilter.filterName = FilterConstants.DisPlayValues.SORT_BY //Display Name same for all service
            //MARK:- sortby filter is generic for all service ,
            sortFilter.sortByFilterDefultIndex = 0
            sortFilter.sortBYFIlterSelectedIndex = 0
            sortFilter.filterViewType = .segmentedView
            return sortFilter
        }
        func createFlagHeaderWith(key : String , name : String) -> FilterModule
        {
            let flagFilter :FilterModule = FilterModule()
            flagFilter.CheckBoxSelectedStatus = false
            flagFilter.CheckBoxDefaultStatus = false
            flagFilter.filterServerKey  = key
            flagFilter.filterName = name //Display Name same for all service
            //MARK:- sortby filter is generic for all service ,
            flagFilter.filterViewType = .flagView
            return flagFilter
        }
        if   let _: FilterViewController = FilterViewController.vcInstanceFromStoryboard()
        {
            switch  service
            {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail :
                
//                 MARK:- Creating mail filter from plist file
                let mailFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Mail)
                return MailFilterResultViewModal(filters : mailFilterdata.filters)
//                var filters : [FilterModule] = [FilterModule]()
//                let mailAccounts = ResultVCSearchBar.fetchMailAccounts()
//                //only if mail account exists rest of the filters will be appended
//                if let mailAccounts = mailAccounts, mailAccounts.count > 0 {
//                    // MARK: Account filter
//                    let accountsFilter : FilterModule = FilterModule()
//                    accountsFilter.filterName = FilterConstants.Module.MailModules.ACCOUNT
//                    accountsFilter.filterServerKey = FilterConstants.Keys.MailFilterKeys.EMAIL_ID
//                    accountsFilter.filterViewType = .dropDownView
//                    accountsFilter.isDropViewExpanded = false
//                    //accountsFilter.defaultSelectionName = 0
//                    var defIndex = 0
//                    var emailSet = [String]()
//                    var defaultAccountEmailId :Int64 = 0
//                    for mailAccount in mailAccounts {
//                        emailSet.append(mailAccount.email_address!)
//                        if (mailAccount.is_default) {
//                            accountsFilter.selectedFilterServerValue = String(mailAccount.email_address!)
//                            accountsFilter.defaultSelectionName = mailAccount.email_address!
//
//                            accountsFilter.defaultSelectionServerValue = String(mailAccount.email_address!)
//                            defaultAccountEmailId = mailAccount.account_id
//                        }
//                        defIndex = defIndex + 1
//                    }
//                    if accountsFilter.selectedFilterName == ""
//                    {
//                        accountsFilter.selectedFilterName = accountsFilter.defaultSelectionName
//                    }
//                    accountsFilter.searchResults = emailSet
//                    accountsFilter.filtersBackUp = accountsFilter.searchResults
//                    filters.append(accountsFilter)
//
//                    // MARK: Mail account folders
//                    //                    if let mailAcntFolders = fetchMailFoldersForAccount(mailAccountID: mailAccounts[accountsFilter.defaultSelectionName].account_id) {
//                    if let mailAcntFolders = ResultVCSearchBar.fetchMailFoldersForAccount(mailAccountID: defaultAccountEmailId) {
//
//                        let folderFilter : FilterModule = FilterModule()
//                        folderFilter.filterName = FilterConstants.Module.MailModules.FOLDERS
//                        folderFilter.filterServerKey = FilterConstants.Keys.MailFilterKeys.FOLDER_ID
//                        folderFilter.defaultSelectionName = FilterConstants.DisPlayValues.Mail.ALL_FOLDERS
//                        folderFilter.selectedFilterServerValue = FilterConstants.Values.MailFilterValues.ALL_FOLDERS
//                        folderFilter.defaultSelectionServerValue =  FilterConstants.Values.MailFilterValues.ALL_FOLDERS
//                        folderFilter.selectedFilterName = folderFilter.defaultSelectionName
//                        folderFilter.filterViewType = .dropDownView
//                        folderFilter.isDropViewExpanded = false
//                        var folderSet = [String]()
//                        //default one and should be taken from message properties for i18n
//                        folderSet.append(FilterConstants.DisPlayValues.Mail.ALL_FOLDERS)
//                        //TODO: Folder order as per in the web and also the Mail web client should be followed
//                        //to be tested as we are obtaining folders as ordered set
//
//                        for folder in mailAcntFolders {
//                            folderSet.append(folder.folder_name!)
//                        }
//                        folderFilter.searchResults = folderSet
//                        folderFilter.filtersBackUp = folderFilter.searchResults
//                        filters.append(folderFilter)
//                    }
//                    //TODO: else we have to send request to fetch more widget data and show and append in the db on bg thread
//
//                    // MARK: search fields filter
//                    let searchInFilter :FilterModule = FilterModule()
//                    searchInFilter.filterName = FilterConstants.Module.MailModules.SEARCH_IN
//                    searchInFilter.filterServerKey = FilterConstants.Keys.MailFilterKeys.SERACH_IN
//                    searchInFilter.selectedFilterServerValue = FilterConstants.Values.MailFilterValues.ENTIRE_MESSAGE // default one
//                    searchInFilter.defaultSelectionServerValue = FilterConstants.Values.MailFilterValues.ENTIRE_MESSAGE // default one
//                    searchInFilter.filterViewType = .dropDownView
//                    searchInFilter.defaultSelectionName = FilterConstants.DisPlayValues.Mail.ENTIRE_MESSAGE
//                    searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                    searchInFilter.searchResults = [FilterConstants.DisPlayValues.Mail.ENTIRE_MESSAGE,FilterConstants.DisPlayValues.Mail.SUBJECT,FilterConstants.DisPlayValues.Mail.CONTENT,FilterConstants.DisPlayValues.Mail.ATTACHMENT_NAME,FilterConstants.DisPlayValues.Mail.ATTACHMENT_CONTENT]
//                    searchInFilter.filtersBackUp = searchInFilter.searchResults
//                    searchInFilter.isDropViewExpanded = false
//                    filters.append(searchInFilter)
//
//                    //MARK:- Date Filters for Connect
//                    filters.append(createDateFilter())
//
//                    //MARK:- Adding Tag filters
//                    if let tags = ResultVCSearchBar.fetchMailTagsForAccount(mailAccountID: defaultAccountEmailId) {
//
//                        let tagFilter : FilterModule = FilterModule()
//                        tagFilter.filterName = FilterConstants.Module.MailModules.TAGS
//                        tagFilter.filterServerKey = FilterConstants.Keys.MailFilterKeys.LABEL_ID
//                        tagFilter.filterServerKey_2 = nil
//                        tagFilter.defaultSelectionName = FilterConstants.DisPlayValues.Mail.ALL_TAGS
//                        tagFilter.selectedFilterServerValue = FilterConstants.Values.MailFilterValues.ALL_TAGS
//                        tagFilter.defaultSelectionServerValue =  FilterConstants.Values.MailFilterValues.ALL_TAGS
//                        tagFilter.selectedFilterName = tagFilter.defaultSelectionName
//                        tagFilter.filterViewType = .dropDownView
//                        tagFilter.isDropViewExpanded = false
//                        var tagSet = [String]()
//                        //default one and should be taken from message properties for i18n
//                        tagSet.append(FilterConstants.DisPlayValues.Mail.ALL_TAGS)
//                        //TODO: Folder order as per in the web and also the Mail web client should be followed
//                        //to be tested as we are obtaining folders as ordered set
//
//                        for tag in tags {
//                            tagSet.append(tag.tag_name!)
//                        }
//
//                        tagFilter.searchResults = tagSet
//                        tagFilter.filtersBackUp = tagFilter.searchResults
//                        filters.append(tagFilter)
//                    }
//                    // Adding Attachment flag
//                    filters.append(createFlagHeaderWith(key: FilterConstants.Keys.MailFilterKeys.HAS_ATTACHMENT, name: FilterConstants.Module.MailModules.HAS_ATTACHMENT))
//                    // Adding Flagged flag
//                    filters.append(createFlagHeaderWith(key: FilterConstants.Keys.MailFilterKeys.HAS_FLAG, name: FilterConstants.Module.MailModules.HAS_FLAG))
//                    // Adding Replies flag
//                    filters.append(createFlagHeaderWith(key: FilterConstants.Keys.MailFilterKeys.HAS_REPLIES, name: FilterConstants.Module.MailModules.HAS_REPLIES))
//                }// if mail account has more than 0
//                let mail_filters = MailFilterResultViewModal(filters: filters)
//                return mail_filters
//                //                SearchResultsViewModel.FilterSections.append(mail_filters)
            case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                let cliqFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Cliq)
                return CLiqFilterResultViewModal(filters : cliqFilterdata.filters)
                
//                var filters : [FilterModule] = [FilterModule]()
//                //MARK:- Sort By FIlter
//                filters.append(createSortByFilter())
//                //MARK:- Date Filters for Cliq
//                filters.append(createDateFilter())
//                let cliq_filters = CLiqFilterResultViewModal(filters: filters)
//                return cliq_filters

            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                let cliqFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Connect)
                return ConnectFilterResultViewModal(filters : cliqFilterdata.filters)
                
//                var filters : [FilterModule] = [FilterModule]()
//
//                if let connectPortals = ResultVCSearchBar.fetchConnectPortals() {
//                    let portalFilter : FilterModule = FilterModule()
//                    portalFilter.filterName = FilterConstants.Module.ConnectModules.PORTAL
//                    portalFilter.filterServerKey = FilterConstants.Keys.ConnectFilterKeys.CONNECTID
//                    //portalFilter.defaultSelectionName = 0
//                    portalFilter.filterViewType = .dropDownView
//                    portalFilter.isDropViewExpanded = false
//                    var defIndex = 0
//                    var portalSet = [String]()
//                    for portal in connectPortals {
//                        portalSet.append(portal.portal_name!)
//                        if portal.is_default {
//                            portalFilter.selectedFilterServerValue = String(portal.portal_id)
//                            portalFilter.defaultSelectionServerValue = String(portal.portal_id)
//
//                            portalFilter.defaultSelectionName = portal.portal_name!
//                        }
//                        defIndex = defIndex + 1
//                    }
//                    portalFilter.selectedFilterName = portalFilter.defaultSelectionName
//                    portalFilter.searchResults = portalSet
//                    portalFilter.filtersBackUp = portalFilter.searchResults
//
//                    filters.append(portalFilter)
//
//                    let searchInFilter :FilterModule = FilterModule()
//                    searchInFilter.filterName = FilterConstants.Module.ConnectModules.SEARCH_IN
//                    searchInFilter.filterServerKey = FilterConstants.Keys.ConnectFilterKeys.SERACH_IN
//                    searchInFilter.filterViewType = .dropDownView
//                    searchInFilter.defaultSelectionName = FilterConstants.DisPlayValues.Connect.FEEDS
//                    searchInFilter.selectedFilterServerValue = FilterConstants.Values.ConnectFilterValues.FEEDS
//                    searchInFilter.defaultSelectionServerValue = FilterConstants.Values.ConnectFilterValues.FEEDS
//
//                    searchInFilter.searchResults = [FilterConstants.DisPlayValues.Connect.FEEDS,FilterConstants.DisPlayValues.Connect.FORUMS]
//                    searchInFilter.filtersBackUp = searchInFilter.searchResults
//                    searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//
//                    searchInFilter.isDropViewExpanded = false
//                    filters.append(searchInFilter)
//
//                    let sortFilter :FilterModule = FilterModule()
//                    sortFilter.filterName = FilterConstants.Module.ConnectModules.SORT_BY
//
//                    sortFilter.filterViewType = .segmentedView
//                    filters.append(sortFilter)
//                }
//
//                //MARK:- Date Filters for Connect
//                filters.append(createDateFilter())
//
//
//                let connect_filters = ConnectFilterResultViewModal(filters: filters)
//                return connect_filters
//            //                SearchResultsViewModel.FilterSections.append(connect_filters)
            case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                let docsFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Documents)
                return DocsFilterResultViewModal(filters : docsFilterdata.filters)

//                var filters : [FilterModule] = [FilterModule]()
//
//                let portalFilter : FilterModule = FilterModule()
//                portalFilter.filterName = FilterConstants.Module.DocsModules.OWN_TYPE
//                portalFilter.filterServerKey = FilterConstants.Keys.DocsFilterKeys.OWNER_TYPE
//                portalFilter.defaultSelectionName = FilterConstants.DisPlayValues.Docs.Types.ALL_FILES
//                portalFilter.selectedFilterServerValue = FilterConstants.Values.DocsFilterValues.ALL_FILES
//                portalFilter.defaultSelectionServerValue = portalFilter.selectedFilterServerValue
//
//                portalFilter.filterViewType = .dropDownView
//                portalFilter.searchResults = [FilterConstants.DisPlayValues.Docs.Types.ALL_FILES,FilterConstants.DisPlayValues.Docs.Types.OWNED_BY_ME,FilterConstants.DisPlayValues.Docs.Types.SHARED_TO_ME,FilterConstants.DisPlayValues.Docs.Types.SHARED_BY_ME]
//                portalFilter.filtersBackUp = portalFilter.searchResults
//                portalFilter.selectedFilterName = portalFilter.defaultSelectionName
//                portalFilter.isDropViewExpanded = false
//                filters.append(portalFilter)
//
//                let searchInFilter :FilterModule = FilterModule()
//                searchInFilter.filterName = FilterConstants.Module.DocsModules.SEARCH_IN
//                searchInFilter.filterServerKey = FilterConstants.Keys.DocsFilterKeys.SEARCH_IN
//
//                searchInFilter.selectedFilterServerValue = FilterConstants.Values.DocsFilterValues.ALL_TYPES
//                searchInFilter.defaultSelectionServerValue = searchInFilter.selectedFilterServerValue
//
//                searchInFilter.filterViewType = .dropDownView
//                searchInFilter.defaultSelectionName = FilterConstants.DisPlayValues.Docs.SearchIn.ALL_TYPES
//                searchInFilter.searchResults = [FilterConstants.DisPlayValues.Docs.SearchIn.ALL_TYPES,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.WRITER,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.SHEET,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.SHOW,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.PDF,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.IMAGE,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.MUSIC,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.VIDEO,
//                                                FilterConstants.DisPlayValues.Docs.SearchIn.ZIP]
//                searchInFilter.filtersBackUp = searchInFilter.searchResults
//                searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                searchInFilter.isDropViewExpanded = false
//                filters.append(searchInFilter)
//
//                //MARK:- Sort By FIlter
//                filters.append(createSortByFilter())
//
//                let Docs_filters = DocsFilterResultViewModal(filters: filters)
//                return Docs_filters
                
            case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                
                let crmFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Crm)
                return CRMFilterResultViewModal(filters : crmFilterdata.filters)
//                var filters : [FilterModule] = [FilterModule]()
//                if let crmModules = ResultVCSearchBar.fetchCRMModules() {
//                    let portalFilter : FilterModule = FilterModule()
//                    portalFilter.filterName = FilterConstants.Module.CRMModules.MODULES
//                    portalFilter.filterServerKey = FilterConstants.Keys.CrmFilterKeys.MODULE_NAME
//
//                    portalFilter.defaultSelectionName = FilterConstants.DisPlayValues.CRM.All_MODULES
//                    portalFilter.defaultSelectionServerValue = FilterConstants.Values.CrmFilterValues.ALL_MODULE
//                    portalFilter.selectedFilterName = portalFilter.defaultSelectionName
//                    portalFilter.selectedFilterServerValue = portalFilter.defaultSelectionServerValue
//                    portalFilter.filterViewType = .dropDownView
//                    portalFilter.isDropViewExpanded = false
//                    var moduleSet = [String]()
//                    //default one and should be taken from message properties for i18n
//                    moduleSet.append(FilterConstants.DisPlayValues.CRM.All_MODULES)
//
//                    for module in crmModules {
//                        moduleSet.append(module.module_display_name!)
//                    }
//
//                    portalFilter.searchResults = moduleSet
//                    portalFilter.filtersBackUp = portalFilter.searchResults
//
//                    filters.append(portalFilter)
//                }
//
//                let crmFilters = CRMFilterResultViewModal(filters: filters)
//                return crmFilters
                //                SearchResultsViewModel.FilterSections.append(crmFilters)
                
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                 let deskFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Desk)
                return DeskFilterResultViewModal(filters: deskFilterdata.filters)
//                var filters : [FilterModule] = [FilterModule]()
//
//                if let deskPortals = ResultVCSearchBar.fetchDeskPortals() {
//                    let portalFilter : FilterModule = FilterModule()
//                    portalFilter.filterName = FilterConstants.Module.DeskModules.PORTAL
//                    portalFilter.filterServerKey = FilterConstants.Keys.DeskFilterKeys.PORTALID
//
//                    portalFilter.filterViewType = .dropDownView
//                    portalFilter.isDropViewExpanded = false
//
//                    var defIndex = 0
//                    var defaultPortslId : Int64?
//                    var portalSet = [String]()
//                    for portal in deskPortals {
//                        portalSet.append(portal.portal_name!)
//                        if portal.is_default {
//                            portalFilter.defaultSelectionName = portal.portal_name!
//                            portalFilter.selectedFilterServerValue = String( portal.portal_id)
//                            portalFilter.defaultSelectionServerValue = String( portal.portal_id)
//
//                            defaultPortslId = portal.portal_id
//                        }
//                        defIndex = defIndex + 1
//                    }
//                    portalFilter.selectedFilterName = portalFilter.defaultSelectionName
//                    portalFilter.searchResults = portalSet
//                    portalFilter.filtersBackUp = portalFilter.searchResults
//
//                    filters.append(portalFilter)
//
//                    //                    if let deskDepartments = fetchDeskDepartmentsForPortal(portalID: deskPortals[portalFilter.defaultSelectionName].portal_id) {
//                    if let deskDepartments = ResultVCSearchBar.fetchDeskDepartmentsForPortal(portalID: defaultPortslId!) {
//
//                        let searchInFilter :FilterModule = FilterModule()
//                        searchInFilter.filterName = FilterConstants.Module.DeskModules.DEPARTMENT
//                        searchInFilter.filterServerKey = FilterConstants.Keys.DeskFilterKeys.DEPARTMENT_ID
//
//                        searchInFilter.filterViewType = .dropDownView
//                        searchInFilter.isDropViewExpanded = false
//
//                        var departmentSet = [String]()
//                        var flag = true
//                        for department in deskDepartments {
//                            if flag == true
//                            {
//                                flag = false
//                                searchInFilter.selectedFilterServerValue = String(department.dept_id) // first department id
//                                searchInFilter.defaultSelectionServerValue = String(department.dept_id) // first department id
//
//                            }
//                            departmentSet.append(department.dept_name!)
//                        }
//
//                        searchInFilter.defaultSelectionName = departmentSet.first!
//
//                        searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                        searchInFilter.searchResults = departmentSet
//                        searchInFilter.filtersBackUp = searchInFilter.searchResults
//
//                        filters.append(searchInFilter)
//                    }
//
//                    if let deskModules = ResultVCSearchBar.fetchDeskModulesForPortal(portalID: defaultPortslId!) {
//                        let moduleFilter :FilterModule = FilterModule()
//                        moduleFilter.filterName = FilterConstants.Module.DeskModules.MODULES
//                        moduleFilter.filterServerKey = FilterConstants.Keys.DeskFilterKeys.MODULE_ID
//
//                        moduleFilter.filterViewType = .dropDownView
//
//                        moduleFilter.isDropViewExpanded = false
//
//                        var moduleSet = [String]()
//                        moduleSet.append(FilterConstants.DisPlayValues.Desk.All_MODULES)
//                        var flag = true
//                        for module in deskModules {
//                            if flag
//                            {
//                                flag = false
//                                moduleFilter.selectedFilterServerValue = String(module.module_id)
//                                moduleFilter.defaultSelectionServerValue = String(module.module_id)
//
//                            }
//                            moduleSet.append(module.module_name!)
//                        }
//                        moduleFilter.defaultSelectionName = moduleSet.first!
//                        moduleFilter.searchResults = moduleSet
//                        moduleFilter.filtersBackUp = moduleFilter.searchResults
//                        moduleFilter.selectedFilterName = moduleFilter.defaultSelectionName
//
//                        filters.append(moduleFilter)
//                    }
//
//                }
//                //MARK:- Sort By FIlter
//                filters.append(createSortByFilter())
//
//                let Desk_filters = DeskFilterResultViewModal(filters: filters)
//                return Desk_filters
            //                SearchResultsViewModel.FilterSections.append(Desk_filters)
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki: // wiki
                let wikiFilterdata = FilterModuleData(servicename :ZOSSearchAPIClient.ServiceNameConstants.Wiki)
                return WikiFilterResultViewModal(filters: wikiFilterdata.filters)
//                
//                var filters : [FilterModule] = [FilterModule]()
//                
//                let accountsFilter : FilterModule = FilterModule()
//                accountsFilter.filterName = FilterConstants.Module.WikiModules.Wiki_Types
//                //                accountsFilter.filterMuduleKey = FilterConstants.Keys.WikiFilterKeys.WIKIID //MARK:- wiki has only wiki ID in filters so ignore this one , check for nil  in query formation
//                accountsFilter.filterViewType = .dropDownView
//                accountsFilter.searchResults = [FilterConstants.DisPlayValues.Wiki.MY_WIKI,
//                                                FilterConstants.DisPlayValues.Wiki.SUBSCRIBED_WIKI]
//                accountsFilter.filterServerKey = nil
//                accountsFilter.filterServerKey_2 = nil
//                accountsFilter.isDropViewExpanded = false
//                accountsFilter.filtersBackUp = accountsFilter.searchResults
//                
//                //TODO: this will be problem still, as we need to map portal to wikis
//                //I mean parent child like reationship
//                //0 - my wiki and 1 - subscribed wiki
//                // TODO : If there is no My Wiki Subscribed Wiki Should be Checked
//                var mywikiFlag = false
//                if let wikiPortals = ResultVCSearchBar.fetchWikiPortals(wikiType: 0) {
//                    if wikiPortals.count != 0 // if no my wiki skip My Wiki and make Subscribe wiki as default one
//                    {
//                        let searchInFilter :FilterModule = FilterModule()
//                        searchInFilter.filterName = FilterConstants.Module.WikiModules.Portals
//                        searchInFilter.filterServerKey = FilterConstants.Keys.WikiFilterKeys.WIKIID
//                        searchInFilter.filterViewType = .dropDownView
//                        //searchInFilter.defaultSelectionName = 0
//                        searchInFilter.isDropViewExpanded = false
//                        var portalSet = [String]()
//                        var defIndex = 0
//                        var firstSelectionflag = true
//                        for portal in wikiPortals {
//                            portalSet.append(portal.wiki_name!)
//                            //MARK:- IF there is no default value in subscribed wiki so i assumed first one is default
//                            if firstSelectionflag
//                            {
//                                firstSelectionflag = false
//                                accountsFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionName = FilterConstants.DisPlayValues.Wiki.MY_WIKI
//                                accountsFilter.selectedFilterName = accountsFilter.defaultSelectionName
//                                
//                                searchInFilter.defaultSelectionName = portal.wiki_name!
//                                searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                            }
//                            
//                            if portal.is_default {
//                                accountsFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionName = FilterConstants.DisPlayValues.Wiki.MY_WIKI
//                                accountsFilter.selectedFilterName = accountsFilter.defaultSelectionName
//                                
//                                searchInFilter.defaultSelectionName = portal.wiki_name!
//                                searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                            }
//                            defIndex = defIndex + 1
//                        }
//                        
//                        searchInFilter.searchResults = portalSet
//                        searchInFilter.filtersBackUp = searchInFilter.searchResults
//                        
//                        filters.append(accountsFilter)
//                        filters.append(searchInFilter)
//                        mywikiFlag = true
//                    }
//                    
//                }
//                
//                if let wikiPortals = ResultVCSearchBar.fetchWikiPortals(wikiType: 1){
//                    if ( mywikiFlag == false) // if my wiki is not default one
//                    {
//                        let searchInFilter :FilterModule = FilterModule()
//                        searchInFilter.filterName = FilterConstants.Module.WikiModules.Portals
//                        searchInFilter.filterServerKey = FilterConstants.Keys.WikiFilterKeys.WIKIID
//                        searchInFilter.filterViewType = .dropDownView
//                        //                    searchInFilter.defaultSelectionName = 0
//                        searchInFilter.isDropViewExpanded = false
//                        var portalSet = [String]()
//                        
//                        var defIndex = 0
//                        var firstSelectionflag = true
//                        for portal in wikiPortals {
//                            portalSet.append(portal.wiki_name!)
//                            
//                            //MARK:- IF there is no default value in subscribed wiki so we assumed first one is default
//                            // if it has default the all value will be overwirted again
//                            if firstSelectionflag
//                            {
//                                firstSelectionflag = false
//                                accountsFilter.defaultSelectionName = FilterConstants.DisPlayValues.Wiki.SUBSCRIBED_WIKI
//                                accountsFilter.selectedFilterName = accountsFilter.defaultSelectionName
//                                accountsFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                                
//                                searchInFilter.defaultSelectionName = portal.wiki_name!
//                                searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                                searchInFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                searchInFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                            }
//                            if portal.is_default {
//                                accountsFilter.defaultSelectionName = FilterConstants.DisPlayValues.Wiki.SUBSCRIBED_WIKI
//                                accountsFilter.selectedFilterName = accountsFilter.defaultSelectionName
//                                accountsFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                accountsFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                                
//                                searchInFilter.defaultSelectionName = portal.wiki_name!
//                                searchInFilter.selectedFilterName = searchInFilter.defaultSelectionName
//                                searchInFilter.selectedFilterServerValue = String(portal.wiki_id)
//                                searchInFilter.defaultSelectionServerValue = String(portal.wiki_id)
//                            }
//                            defIndex = defIndex + 1
//                        }
//                        
//                        searchInFilter.searchResults = portalSet
//                        searchInFilter.filtersBackUp = searchInFilter.searchResults
//                        filters.append(accountsFilter)
//                        
//                        filters.append(searchInFilter)
//                    }
//                }
//                
//                //MARK:- Sort By FIlter
//                filters.append(createSortByFilter())
//                
//                //MARK:- Date Filters for Cliq
//                filters.append(createDateFilter())
//                
//                let Wiki_filters = WikiFilterResultViewModal(filters: filters)
//                return Wiki_filters
//            //                SearchResultsViewModel.FilterSections.append(Wiki_filters)
            default:
                print("Inconsistent State")
            }
        }
        let filters = [FilterModule]()
        let filtermodule = MailFilterResultViewModal(filters: filters)
        return filtermodule
    }
    @objc func FilterCliqed(_ sender : UITapGestureRecognizer)
    {
        if   let _: FilterViewController = FilterViewController.vcInstanceFromStoryboard()
        {
            let selectedService =   SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName
            for filter in SearchResultsViewModel.FilterSections
            {
                if filter.serviceName == selectedService
                {
                    //If filtermodule is already created no need to duplicate
                    self.presentChildViewController()
                    return
                }
            }
            // If filtermodule is not in filter sections then create new one
            performUIUpdatesOnMain {
                let currentService = SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName
                let filterModule = ResultVCSearchBar.createFilterViewModelForCurrentService(service: currentService!)
                SearchResultsViewModel.FilterSections.append(filterModule)
                self.presentChildViewController()
            }
            
        }
    }
    
    static func fetchMailAccounts() -> [MailAccounts]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(MailAccounts.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String, ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAccounts]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchMailFoldersForAccount(mailAccountID: Int64) -> [MailAcntFolders]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsFolderTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntFolders.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntFolders]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchMailTagsForAccount(mailAccountID: Int64) -> [MailAcntTags]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsTagTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntTags.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntTags]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchConnectPortals() -> [ConnectPortals]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.ConnectPortalsTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(ConnectPortals.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String, ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [ConnectPortals]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    static func fetchCRMModules() -> [CRMModules]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.CRMModulesTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(CRMModules.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String, ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [CRMModules]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchDeskPortals() -> [DeskPortals]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.DeskPortalsTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(DeskPortals.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String, ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [DeskPortals]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchDeskDepartmentsForPortal(portalID: Int64) -> [DeskDepartments]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.DeskDepartmentsTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(DeskDepartments.portal_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, portalID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [DeskDepartments]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchDeskModulesForPortal(portalID: Int64) -> [DeskModules]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.DeskModulesTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(DeskModules.portal_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, portalID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [DeskModules]
            
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    //TODO: I think we can fetch all wikis independendent of type and then set the default one
    //now it will require two calls
    //for now using 0 and 1, later will use enum type
    static func fetchWikiPortals(wikiType: Int) -> [UserWikis]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.UserWikisTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(UserWikis.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String + " AND " + #keyPath(UserWikis.wiki_type) + " == " + SearchKitConstants.FormatStringConstants.SignedInt, ZohoSearchKit.sharedInstance().getCurrentUser().zuid, wikiType)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [UserWikis]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    @objc func contactTouched(_ sender : UITapGestureRecognizer)
    {
        if SearchResultsViewModel.ResultVC.isNamelabledisplay == true
        {
            return
        }
        SearchResultsViewModel.ResultVC.isNamelabledisplay = true
        let expandedview : UIView = self.leftView!
        
        let max_width = CGFloat( self.frame.width / 2 - self.frame.height )
        
        var dynamic_width = max_width
        
         let string = SearchResultsViewModel.ResultVC.contactName
        let font = UIFont.systemFont(ofSize: 15)
        let name_width = string.size(OfFont: font).width
        if name_width > max_width
        {
            dynamic_width = max_width
        }
        else
        {
            dynamic_width = name_width
        }
        
        let name_padding : CGFloat = 4.0
        
        let nameLableView = UIView(frame : CGRect(x: expandedview.frame.width - ((expandedview.frame.height - 20) / 2) + 5, y: 10, width: dynamic_width + ((expandedview.frame.height - 20) + name_padding ) + 5 , height: expandedview.frame.height - 20))
        nameLableView.backgroundColor =  SearchKitConstants.ColorConstants.AtMension_NameLabel_BackGround_Color
        let lable = UILabel(frame: CGRect(x:  nameLableView.frame.height / 2 + name_padding, y: 0, width: nameLableView.frame.width - (nameLableView.frame.height / 2 ) , height: nameLableView.frame.height))
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text  = SearchResultsViewModel.ResultVC.contactName
        nameLableView.addSubview(lable)
        let srinkButton = UIView(frame : CGRect(x: expandedview.frame.width + nameLableView.frame.width - 2*( nameLableView.frame.height / 2), y:nameLableView.frame.minY, width: nameLableView.frame.height, height: nameLableView.frame.height))
        
        let img:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.GoBackImage , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView(image: img.imageWithInsets(insets: UIEdgeInsetsMake(12, 12, 12, 12)))
        imageView.frame = CGRect(x: 0, y: 0, width:srinkButton.frame.width , height: srinkButton.frame.height)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true;
        imageView.backgroundColor = SearchKitConstants.ColorConstants.AtMension_NameLabel_BackGround_Color
        imageView.layer.masksToBounds = false
        let guesture = UITapGestureRecognizer(target: self, action: #selector(self.CloseNameLable))
        srinkButton.addGestureRecognizer(guesture)
        srinkButton.addSubview(imageView)
        
        expandedview.frame = CGRect(x: 0, y: 0, width: expandedview.frame.width + nameLableView.frame.width , height: expandedview.frame.height)
        expandedview.addSubview(nameLableView)
        
        expandedview.addSubview(srinkButton)
        self.leftView = expandedview
    }
    @objc func CloseNameLable(_ sender : UITapGestureRecognizer)
    {
        SearchResultsViewModel.ResultVC.isNamelabledisplay = false
        self.awakeFromNib()
    }
}
