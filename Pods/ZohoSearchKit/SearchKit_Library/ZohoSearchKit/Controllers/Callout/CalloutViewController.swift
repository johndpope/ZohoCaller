//
//  CalloutViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 26/04/18.
//

import UIKit
class CalloutViewController: AbstractCalloutViewController {
    
    @IBOutlet weak var quickActionView: CallOutActionView!
    @IBOutlet weak var peopleMetaView: UIView!
    @IBOutlet weak var peopleImageView: UIImageView!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var inOutStatus: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var empDetailsTableView: UITableView!
    fileprivate var dataDictionary = [DataLabelAndValue]()
    fileprivate var quickActionComponents = [DataLabelAndValue]()
    
    @IBAction func didbackPress(_ sender: Any) {
        super.handleBackPress()
    }
    static func vcInstanceFromStoryboard() -> CalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: CalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? CalloutViewController
    }
    var searchResult : SearchResult?
    var serviceName = String()
    var deskResult : SupportResult?
    var crmResult : CRMResult?{
    didSet{
        var resultDataPairs = [DataLabelAndValue]()
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                _ = ZOSSearchAPIClient.sharedInstance().getCRMCallout(oAuthToken: oAuthToken, entityID: Int64((self.crmResult?.entityID)!)!, crmMod: (self.crmResult?.moduleName)!, clickPosition: 0)
                {
                    (calloutDataResp, error) in
                    if let calloutDataResp = calloutDataResp {
                        if let impFeilds = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.ImportFeilds] as? [String:String] {
                            performUIUpdatesOnMain {
                                for feild in impFeilds
                                {
                                    let feildData = DataLabelAndValue(labelText: feild.key, valueText: feild.value )
                                    resultDataPairs.append(feildData)
                                }
                            }
                        }
                    }
                    if let calloutDataResp = calloutDataResp {
                        if let extraFeilds = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.ExtraFeilds] as? [String:String] {
                            performUIUpdatesOnMain {
                                var titleName = ""
                                if let modName = self.crmResult?.moduleName {
                                    switch modName
                                    {
                                    case ZOSSearchAPIClient.CRMModulesNames.Accounts:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Accounts.Title
                                    case ZOSSearchAPIClient.CRMModulesNames.Contacts:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Contacts.Title
                                    case ZOSSearchAPIClient.CRMModulesNames.Leads:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Leads.Title
                                    case ZOSSearchAPIClient.CRMModulesNames.Campaigns:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Campaigns.Title
                                    case ZOSSearchAPIClient.CRMModulesNames.Potentials:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Potentials.Title
                                    case ZOSSearchAPIClient.CRMModulesNames.Solutions:
                                        titleName = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Solutions.Title
                                    default:
                                        break
                                    }
                                }
                                
                                for feild in extraFeilds
                                {
                                    if titleName == feild.key
                                    {
                                        let feildData = DataLabelAndValue(labelText: CallOutFeilds.name.rawValue, valueText: feild.value )
                                        resultDataPairs.append(feildData)
                                    }
                                    else
                                    {
                                        let feildData = DataLabelAndValue(labelText: feild.key, valueText: feild.value )
                                        resultDataPairs.append(feildData)
                                    }
                                    
                                }
                            }
                        }
                    }
                    performUIUpdatesOnMain {
                        let calloutResult = CallOutResult(dictionary: resultDataPairs)
                        self.callOutResult = calloutResult
                        self.empDetailsTableView.reloadData()
                        self.view.setNeedsDisplay() // To Redraw the View Again,but it  Works for ImageView Only not for labels.
                        //reloading callout VC after we get data from server request
                        //                            NotificationCenter.default.post(name: .reloadCalloutVC, object: nil)
                    }
                }
            }
        })
        }
    }

    var callOutResult: CallOutResult? {
        didSet {
            guard let _ = callOutResult?.keyValuepair else {
                return
            }
            for result in (callOutResult?.keyValuepair.enumerated())!
            {
                if let key : CallOutFeilds = CallOutFeilds(rawValue: result.element.dataLabel)
                {
                    switch key
                    {
                    case .empID ,.location , .extn , .mobile , .email:
                        if let empID = callOutResult?.keyValuepair.vauleFor(key: key.rawValue)  {
                            //TODO: We should get the label from the I18N
                            let keyValuePair = DataLabelAndValue(labelText: key.rawValue, valueText: empID )
                            dataDictionary.append(keyValuePair)
                        }
                    default:
                        break
                    }
                }
                else
                {
                    if let keyValue = callOutResult?.keyValuepair.vauleFor(key:  result.element.dataLabel) , keyValue.isEmpty == false  {
                        //TODO: We should get the label from the I18N
                        let keyValuePair = DataLabelAndValue(labelText: result.element.dataLabel, valueText: keyValue )
                        dataDictionary.append(keyValuePair)
                    }
                }
            }
            //MARK:- Adding Quick Action components , shold be in order
            if let mail = callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.email.rawValue)
            {
                let keyValuePair = DataLabelAndValue(labelText: CallOutFeilds.email.rawValue, valueText: mail)
                quickActionComponents.append(keyValuePair)
                
            }
            if let zuid = callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.zuid.rawValue)
            {
                let keyValuePair = DataLabelAndValue(labelText: CallOutFeilds.zuid.rawValue, valueText: zuid)
                quickActionComponents.append(keyValuePair)
                
            }
            if let call = callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.mobile.rawValue)
            {
                let keyValuePair = DataLabelAndValue(labelText: CallOutFeilds.mobile.rawValue, valueText: call)
                quickActionComponents.append(keyValuePair)
                
            }
        }
    }
    var loadPhotoFromURL : String?{
        didSet{
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 120, imageViewHeight: 120) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
//            peopleImageView.addSubview(imageView)
            
            if let imageURL = loadPhotoFromURL  {
                
                //animate the image loading icon
                var loadImages: [UIImage] = []
                loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
                imageView.animate(images: loadImages)
                
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    //ZSSOKit.getOAuth2Token({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getImageForURL(imageURL , oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            if image == nil {
                                performUIUpdatesOnMain {
                                    let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                    imageView.stopAnimate()
                                    imageView.image = defImage
                                    self.peopleImageView.maskCircle(anyImage: defImage)
                                }
                            }
                            else {
                                performUIUpdatesOnMain {
                                    //stop the loading image animation
                                    imageView.stopAnimate()
                                    //set new downloaded image to the image view withing above created border
                                    imageView.image = image
                                    self.peopleImageView.maskCircle(anyImage: image!)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    @IBOutlet weak var inOutStatusWidth: NSLayoutConstraint!
    @objc  func moreButtonPressed(sender : UINavigationItem)
    {
        OpenServiceWithNativeApp.sharedInstance().selectedResultCellServiceName = serviceName
        OpenServiceWithNativeApp.sharedInstance().selectedServiceResult = self.searchResult
        OpenServiceWithNativeApp.sharedInstance().didPressMoreActionsOption(sender, currentViewcontroller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let rightButtonItem = UIBarButtonItem.init(
            title: nil,
            style: .done,
            target: self,
            action: #selector(moreButtonPressed)
        )
        rightButtonItem.image = UIImage(named: "searchsdk-more", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        quickActionView.quickActionComponents = quickActionComponents
        quickActionView.setUpQuickActions()
        empDetailsTableView.tableFooterView = UIView()
        empDetailsTableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        empDetailsTableView.register(KeyValueTableViewCell.nib, forCellReuseIdentifier: KeyValueTableViewCell.identifier)
        //empDetailsTableView.delegate = self
        empDetailsTableView.dataSource = self
        empDetailsTableView.estimatedRowHeight = 80
        empDetailsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        peopleMetaView.backgroundColor = SearchKitConstants.ColorConstants.PeopleMetaViewBGColor
        
        empName.textColor = SearchKitConstants.ColorConstants.PeopleMetaTitleColor
        if let name =  (callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.name.rawValue))
        {
            quickActionView.empName =  name
            empName.text =  name
        }
        else
        {
            empName.isHidden = true
        }
        designation.textColor = SearchKitConstants.ColorConstants.PeopleMetaSubtitleColor
        if let desigNation = (callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.designation.rawValue))
        {
            designation.text = desigNation
        }
        else
        {
           designation.isHidden = true
        }
        department.textColor = SearchKitConstants.ColorConstants.PeopleMetaSubtitleColor
        if let depName = (callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.departmentName.rawValue))
        {
            department.text = depName
        }
        else
        {
            department.isHidden = true
        }
        if let imageURL = (callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.photoURL.rawValue))
        {
            loadPhotoFromURL = imageURL
        }
        else
        {
            if crmResult != nil
            {
                let image:UIImage =  ResultIconUtils.getIconForCRMResult(crmResult: crmResult!)!.imageWithInsets(insets: UIEdgeInsetsMake(10, 10, 10, 10))!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: peopleImageView.frame.width, imageViewHeight: peopleImageView.frame.width) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage:image)
                peopleImageView.addSubview(imageView)
                
            }
            else if deskResult != nil
            {
                let image:UIImage =  ResultIconUtils.getIconForDeskResult(deskResult: deskResult!).imageWithInsets(insets: UIEdgeInsetsMake(10, 10, 10, 10))!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: peopleImageView.frame.width, imageViewHeight: peopleImageView.frame.width) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage:image)
                peopleImageView.addSubview(imageView)
            }
            else
            {
                //first load the no user image and show loading icon
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 120, imageViewHeight: 120) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                peopleImageView.addSubview(imageView)
            }
            
        }
        if let zuid = (callOutResult?.keyValuepair.vauleFor(key: CallOutFeilds.zuid.rawValue))
        {
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    //TODO: temp code zuid must be stored as Int64 integer itself
                    let _ = ZOSSearchAPIClient.sharedInstance().getPeopleInOutStatus(oAuthToken: oAuthToken, zuid: Int(zuid)! ) { (peopleStatusData, error) in
                        if let peopleStatusData = peopleStatusData as? [String: AnyObject] {
                            
                            var isUserAvailable: Bool = false
                            if let available = peopleStatusData["isUserAvailable"] as? Bool, available == true {
                                isUserAvailable = available
                            }
                            
                            performUIUpdatesOnMain {
                                //temp status, we have to fetch from the server people status
                                self.inOutStatus.textColor = SearchKitConstants.ColorConstants.PeopleMetaTitleColor
                                if isUserAvailable {
                                    //TODO: This text should come from I18N file
                                    self.inOutStatus.text = "In"
                                    self.inOutStatus.layer.borderColor = SearchKitConstants.ColorConstants.PeopleInBorderColor.cgColor
                                }
                                else {
                                    self.inOutStatus.text = "Out"
                                    self.inOutStatus.layer.borderColor = SearchKitConstants.ColorConstants.PeopleOutBorderColor.cgColor
                                }
                                self.inOutStatusWidth.constant = (self.inOutStatus.text?.size(OfFont: self.inOutStatus.font))!.width + 18
                                self.inOutStatus.layer.borderWidth = 1.0
                                self.inOutStatus.layer.cornerRadius = 3
                                self.inOutStatus.backgroundColor = UIColor.white
                                self.inOutStatus.layer.masksToBounds = true
                                
                                self.inOutStatus.isHidden = false
                                
                                self.inOutStatus.alpha = 0.1
                               
                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                    self.inOutStatus.alpha = 1.0
                                })
                            }
                        }
                    }
                }
            })
        }
    }
}

extension CalloutViewController: UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueTableViewCell.identifier, for: indexPath) as? KeyValueTableViewCell {
            cell.keyValue = dataDictionary[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
}
