//
//  LongPressQuickActions.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 13/02/18.
//

import UIKit

fileprivate enum QuickActions {
    case chatWithCliq
    case openMoreOptions
    case makeCall
    case sendEmail
    case expandResultMetaData
}
enum ZpositionLevel : CGFloat
{
    case maximum
    case high
    case medium
    case low
    case least
    public var rawValue: CGFloat {
        switch self {
        case .maximum:
            return CGFloat.Magnitude.greatestFiniteMagnitude
        case .high:
            return 999999999
        case .medium:
            return 9999999
        case .low:
            return 999999
        case .least:
            return CGFloat.Magnitude.leastNormalMagnitude
        }
    }
}


//Quick actions supported on long press for the search results cell
class LongPressQuickActions: UIView {
    fileprivate let cellID = "QuickActionOptionCell"
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 //gap between each element of collection view
        layout.minimumInteritemSpacing = 6 //gap between modal view cell and collection view
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = UIEdgeInsetsMake(0, 10, 0, 10) //left and right will be enclosed by 10 padding both end of the cv
        return cv
    }()
    fileprivate var diff = CGFloat()
    fileprivate var indexPath = IndexPath()
    fileprivate var selectedResultCellServiceName=String()
    fileprivate var tableServiceName = String()
    fileprivate var currentTableViewController = TableViewController(style: .plain, itemInfo: IndicatorInfo(title: "", serviceName: ""))
    fileprivate var quickActions = [QuickActions]()
    fileprivate var phoneNumber:String = String()
    fileprivate var emailAddress: String = String()
    fileprivate var userZUID: Int = -1
    fileprivate var userDisplayName: String = String()
    fileprivate var expandCell: UICollectionViewCell = UICollectionViewCell()
    fileprivate var isExpanded: Bool = true
    init(frame: CGRect,indexPath : IndexPath,current_Table :TableViewController) {
        super.init(frame: frame)
        self.currentTableViewController = current_Table
        tableServiceName = current_Table.itemInfo.serviceName!
        self.indexPath = indexPath
        let cell = current_Table.tableView.cellForRow(at: indexPath) as! SearchResultCell
        var serviceName = " "
        if let _ =  cell.serviceName
        {
            serviceName = cell.serviceName!
        }
        else if let _ = cell.searchResultDataModal?.serviceName
        {
            serviceName = (cell.searchResultDataModal?.serviceName)!
        }
        self.layer.zPosition = ZpositionLevel.high.rawValue
//        let serviceName = SearchKitUtil.getServiceNameForCell(cell: cell!)
        let item = SearchResultsViewModel.serviceSections[serviceName]
        selectedResultCellServiceName = (item?.serviceName)!
        addQuickActionsForService(serviceName:selectedResultCellServiceName )
        backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false //important for automatic constraints
        addConstraintwithFormate(format: "V:|[v0]|", views: collectionView)
        addConstraintwithFormate(format: "H:|[v0]|", views: collectionView)
        collectionView.transform = CGAffineTransform(scaleX: -1.0 ,y : 1.0)
        collectionView.register(QuickActionCVCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
    }
    
    /*
     init(frame: CGRect,indexPath : IndexPath,current_Table :TableViewController) {
     super.init(frame: frame)
     
     self.currentTableViewController = current_Table
     tableServiceName = current_Table.itemInfo.serviceName!
     
     self.indexPath = indexPath
     var item = SearchResultsViewModel.serviceSections[tableServiceName] //SearchResultsViewModel.serviceSections[indexPath.section] //returns serviceResultviwemodal
     
     if tableServiceName != ZOSSearchAPIClient.ServiceNameConstants.All
     {
     for (service, checkitem) in SearchResultsViewModel.serviceSections
     {
     if tableServiceName == checkitem.serviceName  {
     item = SearchResultsViewModel.serviceSections[service]
     }
     }
     }
     selectedResultCellServiceName = (item?.serviceName)!
     addQuickActionsForService(serviceName:selectedResultCellServiceName )
     backgroundColor = UIColor.clear
     collectionView.backgroundColor = UIColor.clear
     addSubview(collectionView)
     collectionView.translatesAutoresizingMaskIntoConstraints = false //important for automatic constraints
     addConstraintwithFormate(format: "V:|[v0]|", views: collectionView)
     addConstraintwithFormate(format: "H:|[v0]|", views: collectionView)
     collectionView.transform = CGAffineTransform(scaleX: -1.0 ,y : 1.0)
     collectionView.register(QuickActionCVCell.self, forCellWithReuseIdentifier: cellID)
     
     collectionView.showsHorizontalScrollIndicator = false
     collectionView.isPagingEnabled = false
     }
     */
    
    fileprivate func addQuickActionsForService(serviceName:String)
    {
        var serviceSection = SearchResultsViewModel.serviceSections[serviceName]
        
        if tableServiceName != ZOSSearchAPIClient.ServiceNameConstants.All {
            for (service, checkitem) in SearchResultsViewModel.serviceSections {
                if tableServiceName == checkitem.serviceName  {
                    serviceSection = SearchResultsViewModel.serviceSections[service]
                }
            }
        }
        
        let selectedResultItem = serviceSection?.searchResults[indexPath.row]
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            //let cliqResult = selectedResultItem as! ChatResult
            
            //More option should always be the first option
            quickActions.append(.openMoreOptions)
            //Expand option should always be the last option
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            let contactResult = selectedResultItem as! ContactsResult
            quickActions.append(.openMoreOptions)
            
            if let email = contactResult.emailAddress, email.isEmpty == false {
                quickActions.append(.sendEmail)
                emailAddress = contactResult.emailAddress!
            }
            
            if let phoneNum = contactResult.mobileNumber, phoneNum.isEmpty == false {
                quickActions.append(.makeCall)
                phoneNumber = contactResult.mobileNumber!
            }
            
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            let peopleResult = selectedResultItem as! PeopleResult
            quickActions.append(.openMoreOptions)
            
            if ZohoAppManager.isCliqAppInstalled(), peopleResult.isSameOrg!, peopleResult.zuid != nil, peopleResult.zuid != -1 {
                quickActions.append(.chatWithCliq)
                userZUID = peopleResult.zuid!
                if let fName = peopleResult.firstName {
                    userDisplayName = fName
                }
                else if let lName = peopleResult.lastName {
                    userDisplayName = lName
                }
                else {
                    userDisplayName = "Name"
                }
            }
            
            if let email = peopleResult.email, email.isEmpty == false
            {
                quickActions.append(.sendEmail)
                emailAddress = peopleResult.email!
            }
            
            if let phoneNum = peopleResult.mobile, phoneNum.isEmpty == false
            {
                self.phoneNumber = peopleResult.mobile!
                quickActions.append(.makeCall)
            }
            
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            //let mailResult = selectedResultItem as! MailResult
            quickActions.append(.openMoreOptions)
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            //let connectResult = selectedResultItem as! ConnectResult
            quickActions.append(.openMoreOptions)
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            //let docsResult = selectedResultItem as! DocsResult
            quickActions.append(.openMoreOptions)
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            //let crmResult = selectedResultItem as! CRMResult
            quickActions.append(.openMoreOptions)
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            let deskResult = selectedResultItem as!SupportResult
            quickActions.append(.openMoreOptions)
            if (deskResult.moduleID == 3 || deskResult.moduleID == 4)
            {
                if let email = deskResult.subtitle1, email.isEmpty == false
                {
                    quickActions.append(.sendEmail)
                    emailAddress = email
                }
            }
           
//            quickActions.append(.expandResultMetaData)
            break
            
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            //let wikiResult = selectedResultItem as! WikiResult
            quickActions.append(.openMoreOptions)
//            quickActions.append(.expandResultMetaData)
            break
        default:
            fatalError("Error in Menubar Selection ")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Quick Action Option Cell as Collection View
class QuickActionCVCell : UICollectionViewCell,UIGestureRecognizerDelegate
{
    fileprivate var menuAction : QuickActions = .openMoreOptions
    lazy var imageview:UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageview)
        addConstraintwithFormate(format: "H:|[v0]|", views: imageview)
        addConstraintwithFormate(format: "V:|[v0]|", views: imageview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Collection view for the quick actions
extension LongPressQuickActions: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickActions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let quickActionOptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuickActionCVCell
        quickActionOptionCell.transform = CGAffineTransform(scaleX: -1.0 ,y : 1.0)
        quickActionOptionCell.menuAction = quickActions[indexPath.row]
        var optionImage: UIImage?
        //expand icon needed different padding while creating image view with inset
        var isExpandOptionCell: Bool = false
        var tapRecognizer: UITapGestureRecognizer?
        
        switch quickActionOptionCell.menuAction {
        case .openMoreOptions:
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressMoreActionsOption(_:)))
            optionImage = UIImage(named: SearchKitConstants.ImageNameConstants.MoreActionsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
        case .makeCall:
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressMakePhoneCallOption(_:)))
            optionImage = UIImage(named:SearchKitConstants.ImageNameConstants.MakeCallImage , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
        case .sendEmail:
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressSendMailOption(_:)))
            optionImage = UIImage(named:SearchKitConstants.ImageNameConstants.SendMailImage , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
        case .chatWithCliq:
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressChatWithCliqOption(_:)))
            optionImage = UIImage(named:SearchKitConstants.ImageNameConstants.ChatWithTheUser , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
        case .expandResultMetaData:
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressExpandResultCell(_:)))
            optionImage = UIImage(named:SearchKitConstants.ImageNameConstants.ResultCellNotExpanded , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            self.expandCell = quickActionOptionCell
            isExpandOptionCell = true
            break
            
        }
        
        if let tapRecog = tapRecognizer {
            tapRecog.numberOfTapsRequired = 1
            tapRecog.delegate = quickActionOptionCell.self
            quickActionOptionCell.addGestureRecognizer(tapRecog)
            
            var imageView: UIImageView?
            if isExpandOptionCell {
                imageView = UIImageView.createCircularImageViewWithInset(image: optionImage!, bgColor: nil, insetPadding: 0, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewExpand(image: optionImage!)
            }
            else {
                imageView = UIImageView.createCircularImageViewWithInset(image: optionImage!, bgColor: nil, insetPadding: 16, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewForQuickActions(image: optionImage!)
            }
            quickActionOptionCell.imageview.addSubview(imageView!)
        }
        
        return quickActionOptionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : self.frame.height, height : self.frame.height)
    }
}

//Extension handling the action whe quick action button is pressed
extension LongPressQuickActions {
    
    @objc func didPressMoreActionsOption(_ sender : UITapGestureRecognizer)
    {
        //Alert view
        //TODO: get More Options messages form I18N files. All other ui messages as well
        //no message is needed, only title is needed
        let moreOptionsAlert = UIAlertController(title: "More Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //to change font of title if need be
        //        let titleFont = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        //        let titleAttrString = NSMutableAttributedString(string: "More Options", attributes: titleFont)
        //        moreOptionsAlert.setValue(titleAttrString, forKey: "attributedTitle")
        
        var item = SearchResultsViewModel.serviceSections[selectedResultCellServiceName] //returns serviceResultviwemodal
        
        if tableServiceName != ZOSSearchAPIClient.ServiceNameConstants.All {
            for (service, checkitem) in SearchResultsViewModel.serviceSections {
                if tableServiceName == checkitem.serviceName {
                    item = SearchResultsViewModel.serviceSections[service]
                }
            }
        }
        
        let selectedResult = item?.searchResults[indexPath.row]
        
        switch selectedResultCellServiceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            let cliqResult = selectedResult as! ChatResult
            
            //Call the Cliq DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Cliq App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInChatApp(chatID: (cliqResult.chatID))
            }))
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            let contactResult = selectedResult as! ContactsResult
            
            //Contacts call out
            moreOptionsAlert.addAction(UIAlertAction(title: "Open Contacts Details", style: .destructive, handler: { (action: UIAlertAction!) in
                
                //TODO: same code is also in TableViewController as well. We should unify this code in one place.
                let targetVC: PeopleDetailsViewController = PeopleDetailsViewController.vcInstanceFromStoryboard()!
                let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: (contactResult.fullName)!)
                calloutData.imageURL = contactResult.photoURL
                
                if let email = contactResult.emailAddress, !email.isEmpty {
                    let rowData: RowData = RowData(withLabelText: "Email")
                    rowData.rowDataText = email
                    rowData.dataType = RowDataType.Email
                    calloutData.keyValuePairs.append(rowData)
                }
                
                if let mobile = contactResult.mobileNumber, !mobile.isEmpty {
                    let rowData: RowData = RowData(withLabelText: "Mobile")
                    rowData.rowDataText = mobile
                    rowData.dataType = RowDataType.PhoneNumber
                    calloutData.keyValuePairs.append(rowData)
                }
                targetVC.calloutData = calloutData
//                ZohoSearchKit.sharedInstance().searchViewController?.present(targetVC, animated: true)
                   self.currentTableViewController.tableView(self.currentTableViewController.tableView, didSelectRowAt: self.indexPath)
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            let peopleResult = selectedResult as! PeopleResult
            
            //Call the People DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with People App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInPeopleApp(emailID: (peopleResult.email)!)
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            let mailResult = selectedResult as! MailResult
            //Call the Mail DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open Mail Details", style: .destructive, handler: { (action: UIAlertAction!) in
                let targetVC: MailCalloutViewController = MailCalloutViewController.vcInstanceFromStoryboard()!
                targetVC.calloutData = mailResult
//                ZohoSearchKit.sharedInstance().searchViewController?.present(targetVC, animated: true)
                self.currentTableViewController.tableView(self.currentTableViewController.tableView, didSelectRowAt: self.indexPath)
                
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            let connectResult = selectedResult as! ConnectResult
            
            //Call the Connect DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Connect App", style: .destructive, handler: { (action: UIAlertAction!) in
                //var connectFeedUrl = connectResult.postURL
                //connectFeedUrl = connectFeedUrl.replacingOccurrences(of: "https://", with: "", options: .literal, range: nil)
                //ZohoAppsDeepLinkUtil.openInConnectAppWithURL(connectUrl: connectFeedUrl)
                ZohoAppsDeepLinkUtil.openInConnectApp(type: (connectResult.type)!, entityID: connectResult.postID, scopeID: 105000017039001)
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            let docsResult = selectedResult as! DocsResult
            //Call the Docs DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Docs App", style: .destructive, handler: { (action: UIAlertAction!) in
                ZohoAppsDeepLinkUtil.openInDocsApp(docsFileID: (docsResult.docID))
            }))
            
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            let crmResult = selectedResult as! CRMResult
            //Call the CRM DeepLinking handler
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with CRM", style: .destructive, handler: { (action: UIAlertAction!) in
                //Only Leads and Contacts module is supported right now
                if (crmResult.moduleName == "Leads" || crmResult.moduleName == "Contacts") {
                    ZohoAppsDeepLinkUtil.openInCRMApp(moduleName: (crmResult.moduleName), recordID: (crmResult.entID), zuid: TableViewController.currentUserZUID)
                }
                else {
                    SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
                }
            }))
            
            
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            //Call the Desk DeepLinking handler if needed
            moreOptionsAlert.addAction(UIAlertAction(title: "Open with Desk App", style: .destructive, handler: { (action: UIAlertAction!) in
                let deskResult = item?.searchResults[self.indexPath.row] as? SupportResult
                
                if (deskResult?.moduleID == 1 || deskResult?.moduleID == 2 ) {
                    if deskResult?.moduleID == 2
                    {
                        SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
                        return
                    }
                    ZohoAppsDeepLinkUtil.openInDeskApp(moduleName: (deskResult?.getModuleName())!, entityID: (deskResult?.entID)!, portalID: (deskResult?.orgID)!)
                }
                else {
                    //3 = contacts and 4 = accounts
                    let targetVC: PeopleDetailsViewController = PeopleDetailsViewController.vcInstanceFromStoryboard()!
                    
                    //some duplicate codes, later will make it concise
                    if (deskResult?.moduleID == 3) {
                        let contactName = deskResult?.title
                        let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: contactName!)
                        calloutData.imageName = "searchsdk-desk-contacts"
                        
                        if let email = deskResult?.subtitle1 {
                            let rowData: RowData = RowData(withLabelText: "Email")
                            rowData.rowDataText = email
                            rowData.dataType = RowDataType.Email
                            calloutData.keyValuePairs.append(rowData)
                        }
                        
                        targetVC.calloutData = calloutData
                    }
                    else if (deskResult?.moduleID == 4) {
                        let accountName = deskResult?.title
                        let calloutData: PeopleCalloutData = PeopleCalloutData(withTitle: accountName!)
                        //only image name differs from the contacts
                        calloutData.imageName = "searchsdk-desk-accounts"
                        if let email = deskResult?.subtitle1, email.isEmpty == false {
                            let rowData: RowData = RowData(withLabelText: "Email")
                            rowData.rowDataText = email
                            rowData.dataType = RowDataType.Email
                            calloutData.keyValuePairs.append(rowData)
                        }
                        
                        targetVC.calloutData = calloutData
                    }
                    
//                    ZohoSearchKit.sharedInstance().searchViewController?.present(targetVC, animated: true)
                    self.currentTableViewController.tableView(self.currentTableViewController.tableView, didSelectRowAt: self.indexPath)
                
                }
                
            }))
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            let wikiResult = selectedResult as! WikiResult
            
            //wiki call out
            moreOptionsAlert.addAction(UIAlertAction(title: "Open Wiki Details", style: .destructive, handler: { (action: UIAlertAction!) in
                let targetVC: WikiCalloutViewController = WikiCalloutViewController.vcInstanceFromStoryboard()!
                targetVC.calloutData = wikiResult
//                ZohoSearchKit.sharedInstance().searchViewController?.present(targetVC, animated: true)
                self.currentTableViewController.tableView(self.currentTableViewController.tableView, didSelectRowAt: self.indexPath)
            }))
            
        default:
            //TODO: Use SearchKitLogger for logging
            fatalError("Given service call out option is not supported yet!")
        }
        
        moreOptionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //no closure for cancel
        }))
//        moreOptionsAlert.accessibilityNavigationStyle = .separate
        //MARK:- for ipad this should be added for alertview Controller
        moreOptionsAlert.modalPresentationStyle = .popover
        let popoverPresentationController: UIPopoverPresentationController? = moreOptionsAlert.popoverPresentationController
        
        let view  = currentTableViewController.tableView.cellForRow(at: indexPath)
        popoverPresentationController?.sourceView = view!
        popoverPresentationController?.sourceRect = (view?.bounds)!
        currentTableViewController.present(moreOptionsAlert, animated: true, completion: nil)
        currentTableViewController.dismissQuickActionModalView()
    }
    
    @objc func didPressMakePhoneCallOption(_ sender : UITapGestureRecognizer)
    {
        currentTableViewController.dismissQuickActionModalView()
        IntentActionHandler.makePhoneCall(phoneNumber: phoneNumber)
    }
    
    @objc func didPressSendMailOption(_ sender : UITapGestureRecognizer)
    {
        currentTableViewController.dismissQuickActionModalView()
        IntentActionHandler.sendNewMail(emailID: emailAddress)
    }
    
    @objc func didPressChatWithCliqOption(_ sender : UITapGestureRecognizer)
    {
        currentTableViewController.dismissQuickActionModalView()
        ZohoAppsDeepLinkUtil.chatUsingCliq(zuid: userZUID, displayName: userDisplayName)
    }
    
    //called when user presses the expand the search result meta data
    @objc func didPressExpandResultCell(_ sender : UITapGestureRecognizer)
    {
        //TODO: optimize code, seems some duplicate code
        var image: UIImage?
        if self.isExpanded {
            image = UIImage(named:SearchKitConstants.ImageNameConstants.ResultCellExpanded, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
            expandResultCell()
            
            //has been replaced with service independent handling for shrinking the cell
            /*
            switch selectedResultCellServiceName {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                expandMailResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                expandDocsResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                expandChatResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
                expandContactsResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                expandConnectResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.People:
                expandPeopleResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                expandDeskResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                expandCRMResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                expandWikiResultCell()
                break
                
            default:
                //TODO: replace with SearchKitLogger call so that unwanted messages are not printed in production app
                fatalError("Nothing to do!")
            }
            */
            
            //MARK:- handling Invisible modalview positions
            let modalViewHeight = self.currentTableViewController.longPressedSearchResultCell.frame.maxY
            let ScreenHeight = UIScreen.main.bounds.maxY
            if modalViewHeight > ScreenHeight
            {
                let diff = modalViewHeight - ScreenHeight
                self.diff = diff
                self.currentTableViewController.longPressedSearchResultCell.frame = CGRect(x:self.currentTableViewController.longPressedSearchResultCell.frame.minX,  y:(self.currentTableViewController.longPressedSearchResultCell.frame.minY - diff), width:self.currentTableViewController.longPressedSearchResultCell.frame.width, height:self.currentTableViewController.longPressedSearchResultCell.frame.height)
                let quickactionview = self.getParentViewController()?.view.viewWithTag(200) as! LongPressQuickActions
                quickactionview.frame = CGRect(x:quickactionview.frame.minX,  y:(quickactionview.frame.minY - diff), width:quickactionview.frame.width, height:quickactionview.frame.height)
            }
        }
        else {
            //MARK:- restoring QuickAction height
            self.frame = CGRect(x:self.frame.minX,  y:(self.frame.minY + self.diff), width:self.frame.width, height:self.frame.height)
            self.diff = CGFloat()

            image = UIImage(named:SearchKitConstants.ImageNameConstants.ResultCellNotExpanded , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            currentTableViewController.longPressedSearchResultCell.frame = currentTableViewController.restoreQuickActionModalViewRect
            
            shrinkResultCell()
            
            //has been replaced with service independent handling for shrinking the cell
            /*
            switch selectedResultCellServiceName {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                shrinkMailResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                shrinkDocsResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                shrinkChatResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
                shrinkContactResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                shrinkConnectResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.People:
                shrinkPeopleResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                shrinkDeskResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                shrinkCRMResultCell()
                break
                
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                shrinkWikiResultCell()
                break
                
            default:
                //TODO: replace with SearchKitLogger call so that unwanted messages are not printed in production app
                fatalError("Nothing to do!")
            }
            */
        }
        
        performUIUpdatesOnMain {
            let imageView =  UIImageView.createCircularImageViewWithInset(image: image!, bgColor: nil, insetPadding: 0, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewExpand(image: image!)
            (self.expandCell as! QuickActionCVCell).imageview.addSubview(imageView)
        }
        
        
        //update the expanded state - flip the state
        self.isExpanded = !self.isExpanded
    }
    
    /*
     private func expandMailResultCell() -> Void {
     let cell = currentTableViewController.modalView as! MailResultViewCell
     cell.mailSubject.numberOfLines = 4
     
     let singleLineHeight = cell.mailSubject.font.lineHeight
     var height = cell.mailSubject.frame.height
     //when even plain text is set, attributed text will not be nil. So, whether highlighting is enabled is not should be checked
     if cell.mailSubject.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
     //respective label frame width not the table view cell.
     height = (cell.mailSubject.attributedText?.height(withConstrainedWidth: cell.mailSubject.frame.width))!
     }
     else {
     height = cell.mailSubject.text!.height(withConstrainedWidth: cell.mailSubject.frame.width, font: cell.mailSubject.font)
     }
     
     resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
     }
     */
    
    private func expandResultCell() -> Void {
        let cell = currentTableViewController.longPressedSearchResultCell as! SearchResultCell
        
        //TODO: These constants will be exported to Constants
        cell.resultTitle.numberOfLines = 4
        cell.resultSubtitle.numberOfLines = 2
        
        let subjectFieldHeight = computeHeightValueForLabel(label: cell.resultTitle, maxNumberOfLinesToDisplay: CGFloat(cell.resultTitle.numberOfLines), isHighlightingEnabledForField: true)
        let senderFieldHeight = computeHeightValueForLabel(label: cell.resultSubtitle, maxNumberOfLinesToDisplay: CGFloat(cell.resultSubtitle.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: subjectFieldHeight + senderFieldHeight)
    }
    
    //has been replaced with service independent handling for shrinking the cell
    /*
    //Make sure to handle properly as it is error prone
    //height, width of the result cell and also the label being expanded must be handled carefully
    private func expandMailResultCell() -> Void {
        let cell = currentTableViewController.modalView as! MailResultViewCell
        
        //TODO: These constants will be exported to Constants
        cell.mailSubject.numberOfLines = 4
        cell.mailSender.numberOfLines = 2
        
        let subjectFieldHeight = computeHeightValueForLabel(label: cell.mailSubject, maxNumberOfLinesToDisplay: CGFloat(cell.mailSubject.numberOfLines), isHighlightingEnabledForField: true)
        let senderFieldHeight = computeHeightValueForLabel(label: cell.mailSender, maxNumberOfLinesToDisplay: CGFloat(cell.mailSender.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: subjectFieldHeight + senderFieldHeight)
    }
    
    private func expandDocsResultCell() {
        let cell = currentTableViewController.modalView as! DocsResultViewCell
        cell.docName.numberOfLines = 4
        cell.docAuthor.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.docName.font.lineHeight
         var height = cell.docName.frame.height
         if cell.docName.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.docName.attributedText?.height(withConstrainedWidth: cell.docName.frame.width))!
         }
         else {
         height = cell.docName.text!.height(withConstrainedWidth: cell.docName.frame.width, font: cell.docName.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let docNameFieldHeight = computeHeightValueForLabel(label: cell.docName, maxNumberOfLinesToDisplay: CGFloat(cell.docName.numberOfLines), isHighlightingEnabledForField: true)
        let docAuthorFieldHeight = computeHeightValueForLabel(label: cell.docAuthor, maxNumberOfLinesToDisplay: CGFloat(cell.docAuthor.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: docNameFieldHeight + docAuthorFieldHeight)
    }
    
    private func expandChatResultCell() {
        let cell = currentTableViewController.modalView as! ChatResultViewCell
        cell.chatTitle.numberOfLines = 4
        
        /*
         let singleLineHeight = cell.chatTitle.font.lineHeight
         var height = cell.chatTitle.frame.height
         if cell.chatTitle.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.chatTitle.attributedText?.height(withConstrainedWidth: cell.chatTitle.frame.width))!
         }
         else {
         height = cell.chatTitle.text!.height(withConstrainedWidth: cell.chatTitle.frame.width, font: cell.chatTitle.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let chatNameFieldHeight = computeHeightValueForLabel(label: cell.chatTitle, maxNumberOfLinesToDisplay: CGFloat(cell.chatTitle.numberOfLines), isHighlightingEnabledForField: true)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: chatNameFieldHeight)
    }
    
    private func expandPeopleResultCell() {
        let cell = currentTableViewController.modalView as! PeopleResultViewCell
        cell.empName.numberOfLines = 4
        cell.email.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.empName.font.lineHeight
         var height = cell.empName.frame.height
         if cell.empName.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.empName.attributedText?.height(withConstrainedWidth: cell.empName.frame.width))!
         }
         else {
         height = cell.empName.text!.height(withConstrainedWidth: cell.empName.frame.width, font: cell.empName.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let peopleNameFieldHeight = computeHeightValueForLabel(label: cell.empName, maxNumberOfLinesToDisplay: CGFloat(cell.empName.numberOfLines), isHighlightingEnabledForField: true)
        let peopleEmailFieldHeight = computeHeightValueForLabel(label: cell.email, maxNumberOfLinesToDisplay: CGFloat(cell.email.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: peopleNameFieldHeight + peopleEmailFieldHeight)
    }
    
    private func expandContactsResultCell() {
        let cell = currentTableViewController.modalView as! ContactsResultViewCell
        cell.contactName.numberOfLines = 4
        cell.contactEmail.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.contactName.font.lineHeight
         var height = cell.contactName.frame.height
         if cell.contactName.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.contactName.attributedText?.height(withConstrainedWidth: cell.contactName.frame.width))!
         }
         else {
         height = cell.contactName.text!.height(withConstrainedWidth: cell.contactName.frame.width, font: cell.contactName.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let contactNameFieldHeight = computeHeightValueForLabel(label: cell.contactName, maxNumberOfLinesToDisplay: CGFloat(cell.contactName.numberOfLines), isHighlightingEnabledForField: true)
        let contactEmailFieldHeight = computeHeightValueForLabel(label: cell.contactEmail, maxNumberOfLinesToDisplay: CGFloat(cell.contactEmail.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: contactNameFieldHeight + contactEmailFieldHeight)
    }
    
    private func expandConnectResultCell() {
        let cell = currentTableViewController.modalView as! ConnectResultViewCell
        cell.postTitle.numberOfLines = 4
        cell.postAuthor.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.postTitle.font.lineHeight
         var height = cell.postTitle.frame.height
         if cell.postTitle.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.postTitle.attributedText?.height(withConstrainedWidth: cell.postTitle.frame.width))!
         }
         else {
         height = cell.postTitle.text!.height(withConstrainedWidth: cell.postTitle.frame.width, font: cell.postTitle.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let postTitleFieldHeight = computeHeightValueForLabel(label: cell.postTitle, maxNumberOfLinesToDisplay: CGFloat(cell.postTitle.numberOfLines), isHighlightingEnabledForField: true)
        let postAuthorFieldHeight = computeHeightValueForLabel(label: cell.postAuthor, maxNumberOfLinesToDisplay: CGFloat(cell.postAuthor.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: postTitleFieldHeight + postAuthorFieldHeight)
        
    }
    
    private func expandDeskResultCell() {
        let cell = currentTableViewController.modalView as! DeskResultViewCell
        cell.deskTitle.numberOfLines = 4
        cell.subtitleOne.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.deskTitle.font.lineHeight
         var height = cell.deskTitle.frame.height
         if cell.deskTitle.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.deskTitle.attributedText?.height(withConstrainedWidth: cell.deskTitle.frame.width))!
         }
         else {
         height = cell.deskTitle.text!.height(withConstrainedWidth: cell.deskTitle.frame.width, font: cell.deskTitle.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let deskTitleFieldHeight = computeHeightValueForLabel(label: cell.deskTitle, maxNumberOfLinesToDisplay: CGFloat(cell.deskTitle.numberOfLines), isHighlightingEnabledForField: true)
        let subtitleFieldHeight = computeHeightValueForLabel(label: cell.subtitleOne, maxNumberOfLinesToDisplay: CGFloat(cell.subtitleOne.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: deskTitleFieldHeight + subtitleFieldHeight)
    }
    
    private func expandCRMResultCell() {
        let cell = currentTableViewController.modalView as! CRMResultViewCell
        cell.resultTitle.numberOfLines = 4
        
        /*
         let singleLineHeight = cell.resultTitle.font.lineHeight
         var height = cell.resultTitle.frame.height
         if cell.resultTitle.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.resultTitle.attributedText?.height(withConstrainedWidth: cell.resultTitle.frame.width))!
         }
         else {
         height = cell.resultTitle.text!.height(withConstrainedWidth: cell.resultTitle.frame.width, font: cell.resultTitle.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let crmTitleFieldHeight = computeHeightValueForLabel(label: cell.resultTitle, maxNumberOfLinesToDisplay: CGFloat(cell.resultTitle.numberOfLines), isHighlightingEnabledForField: true)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: crmTitleFieldHeight)
    }
    
    private func expandWikiResultCell() {
        let cell = currentTableViewController.modalView as! WikiResultViewCell
        cell.wikiName.numberOfLines = 4
        cell.wikiAuthor.numberOfLines = 2
        
        /*
         let singleLineHeight = cell.wikiName.font.lineHeight
         var height = cell.wikiName.frame.height
         if cell.wikiName.attributedText != nil, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
         height = (cell.wikiName.attributedText?.height(withConstrainedWidth: cell.wikiName.frame.width))!
         }
         else {
         height = cell.wikiName.text!.height(withConstrainedWidth: cell.wikiName.frame.width, font: cell.wikiName.font)
         }
         
         resizeModalFrame(resultCell: cell, maxNumOfLines: 4, estimatedHeight: height, heightForSingleLine: singleLineHeight)
         */
        
        let wikiNameFieldHeight = computeHeightValueForLabel(label: cell.wikiName, maxNumberOfLinesToDisplay: CGFloat(cell.wikiName.numberOfLines), isHighlightingEnabledForField: true)
        let wikiAuthorFieldHeight = computeHeightValueForLabel(label: cell.wikiAuthor, maxNumberOfLinesToDisplay: CGFloat(cell.wikiAuthor.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: wikiNameFieldHeight + wikiAuthorFieldHeight)
        
    }
    */
    
    private func shrinkResultCell() {
        let cell = currentTableViewController.longPressedSearchResultCell as! SearchResultCell
        cell.resultTitle.numberOfLines = 1
        cell.resultSubtitle.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    //has been replaced with generic handling for the result cell
    /*
    private func shrinkMailResultCell() {
        let cell = currentTableViewController.modalView as! MailResultViewCell
        cell.mailSubject.numberOfLines = 1
        cell.mailSender.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkDocsResultCell() {
        let cell = currentTableViewController.modalView as! DocsResultViewCell
        cell.docName.numberOfLines = 1
        cell.docAuthor.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkChatResultCell() {
        let cell = currentTableViewController.modalView as! ChatResultViewCell
        cell.chatTitle.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkContactResultCell() {
        let cell = currentTableViewController.modalView as! ContactsResultViewCell
        cell.contactName.numberOfLines = 1
        cell.contactEmail.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkPeopleResultCell() {
        let cell = currentTableViewController.modalView as! PeopleResultViewCell
        cell.empName.numberOfLines = 1
        cell.email.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkConnectResultCell() {
        let cell = currentTableViewController.modalView as! ConnectResultViewCell
        cell.postTitle.numberOfLines = 1
        cell.postAuthor.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkDeskResultCell() {
        let cell = currentTableViewController.modalView as! DeskResultViewCell
        cell.deskTitle.numberOfLines = 1
        cell.subtitleOne.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkCRMResultCell() {
        let cell = currentTableViewController.modalView as! CRMResultViewCell
        cell.resultTitle.numberOfLines = 1
        cell.moduleNameLabel.numberOfLines = 1
        cell.awakeFromNib()
    }
    
    private func shrinkWikiResultCell() {
        let cell = currentTableViewController.modalView as! WikiResultViewCell
        cell.wikiName.numberOfLines = 1
        cell.wikiAuthor.numberOfLines = 1
        cell.awakeFromNib()
    }
    */
    
    //This can be in UILabel extension, what about creating our own Label class which has some setting like
    //whether highlighting is enabled for that field or not. So, that lot of unwanted code becomes simpler
    private func computeHeightValueForLabel(label: UILabel, maxNumberOfLinesToDisplay: CGFloat, isHighlightingEnabledForField: Bool) -> CGFloat {
        let singleLineHeight = label.font.lineHeight
        var height = label.frame.height
        //when even plain text is set, attributed text will not be nil. So, whether highlighting is enabled is not should be checked
        //here we are checking whether globally highlighting is enabled or not and also whether specific label field is equiped with highlighting
        if isHighlightingEnabledForField, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            //respective label frame width not the table view cell.
            height = (label.attributedText?.height(withConstrainedWidth: label.frame.width))!
        }
        else {
            height = label.text!.height(withConstrainedWidth: label.frame.width, font: label.font)
        }
        
        let numOfLines = floor(height/singleLineHeight)
        
        if numOfLines > maxNumberOfLinesToDisplay {
            height = maxNumberOfLinesToDisplay * singleLineHeight
        }
        else {
            height = singleLineHeight * numOfLines
        }
        
        //as one line height is already part of the cell frame height, so should be substracted from height to be increased
        height = height - singleLineHeight
        
        return height
    }
    
    private func updateQuickActionCellFrame(resultCell: UITableViewCell, heightToBeIncreased: CGFloat) {
        resultCell.frame = CGRect(origin: CGPoint(x: resultCell.frame.minX, y: resultCell.frame.minY), size: CGSize(width: resultCell.frame.width, height: resultCell.frame.height + heightToBeIncreased))
        resultCell.awakeFromNib()
    }
    
    //TODO: to be removed as code has been duplicated
    // resize the modal view frame with updated height needed to render max supported lines.
    // MARK: proper computaion is very very important, otherwise view might break on different devices
    private func resizeModalFrame(resultCell: UITableViewCell, maxNumOfLines: CGFloat, estimatedHeight: CGFloat, heightForSingleLine: CGFloat) {
        //this can be in common function other can be in one logic
        var height = estimatedHeight
        let numOfLines = floor(height/heightForSingleLine)
        
        if numOfLines > maxNumOfLines {
            height = maxNumOfLines * heightForSingleLine
        }
        else {
            height = heightForSingleLine * numOfLines
        }
        
        //as one line height is already part of the cell frame height, so should not be added
        height = height - heightForSingleLine
        
        resultCell.frame = CGRect(origin: CGPoint(x: resultCell.frame.minX, y: resultCell.frame.minY), size: CGSize(width: resultCell.frame.width, height: resultCell.frame.height + height))
        resultCell.awakeFromNib()
    }
}

