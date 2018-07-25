//
//  newMailCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 23/07/18.
//

import UIKit
import CoreData

class newMailCalloutMetaDataCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var fromValueLabel: UILabel!
    
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toValueLabel: UILabel!
    @IBOutlet weak var viewDetails: UIButton!
    
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var folderValueLabel: UILabel!
    
    @IBOutlet weak var moreDetailsContainer: UIStackView!
    
    @IBOutlet weak var moreDetail_fromNameLabel: UILabel!
    @IBOutlet weak var moreDetail_fromValueLabel: UILabel!
    
    @IBOutlet weak var moreDetail_toNameLabel: UILabel!
    @IBOutlet weak var moreDetail_toValueLabel: UILabel!
    
    @IBOutlet weak var moreDetail_CcContainerVIew: UIStackView!
    @IBOutlet weak var moreDetail_CcNameLabel: UILabel!
    @IBOutlet weak var moreDetail_CcValueLabel: UILabel!
    
    @IBOutlet weak var moreDetail_BccContainerVIew: UIStackView!
    @IBOutlet weak var moreDetail_BccNameLabel: UILabel!
    @IBOutlet weak var moreDetail_BccValueLabel: UILabel!
    
    var calloutMetaData : CalloutMetaData?{
        didSet {
            guard let _ = calloutMetaData else {
                return
            }
            if self.calloutMetaData?.photoFromMailId != nil ,self.calloutMetaData?.photoFromMailId?.isEmpty == false
            {
                loadImageFromMailID = self.calloutMetaData?.photoFromMailId
            }
            self.setUpMetaDataCell()
        }
    }
    func  setUpMetaDataCell()
    {
        let mailMetaData = self.calloutMetaData as! MailCalloutMetaData
        if mailMetaData.fromValue != nil
        {
            self.fromNameLabel.text = mailMetaData.fromLabelName
            self.fromValueLabel.text = mailMetaData.fromValue
            
            self.moreDetail_fromNameLabel.text = mailMetaData.moreDetail_fromLabelName
            self.moreDetail_fromValueLabel.text = mailMetaData.moreDetail_fromValue
        }
        
        if mailMetaData.toValue != nil
        {
            
            self.toNameLabel.text = mailMetaData.toLabelName
            self.toValueLabel.text = mailMetaData.toValue
            
            self.moreDetail_toNameLabel.text = mailMetaData.moreDetail_toLabelName
            self.moreDetail_toValueLabel.text = mailMetaData.moreDetail_toValue
            
            let toAddress =  mailMetaData.toValue?.split(separator: "\n")
            if (toAddress?.count)! > 1
            {
                self.viewDetails.isHidden = false
            }
            else
            {
                self.viewDetails.isHidden = true
            }
        }
        if mailMetaData.dateValue != nil || mailMetaData.folderValue != nil
        {
            self.dateValueLabel.text = mailMetaData.dateValue
            self.folderValueLabel.text = mailMetaData.folderValue
        }
        if mailMetaData.moreDetail_BccValue != nil && mailMetaData.moreDetail_BccValue?.isEmpty == false
        {
            self.moreDetail_BccContainerVIew.isHidden = false
            self.moreDetail_BccNameLabel.text = mailMetaData.moreDetail_BccLabelName
            self.moreDetail_BccValueLabel.text = mailMetaData.moreDetail_BccValue
            
            if self.viewDetails.isHidden == true
            {
                self.viewDetails.isHidden = false
            }
        }
        else
        {
            self.moreDetail_BccContainerVIew.isHidden = true
        }
        if mailMetaData.moreDetail_CcValue != nil && mailMetaData.moreDetail_CcValue?.isEmpty == false
        {
            self.moreDetail_CcContainerVIew.isHidden = false
            self.moreDetail_CcNameLabel.text = mailMetaData.moreDetail_CcLabelName
            self.moreDetail_CcValueLabel.text = mailMetaData.moreDetail_CcValue
            
            if self.viewDetails.isHidden == true
            {
                self.viewDetails.isHidden = false
            }
        }
        else
        {
            self.moreDetail_CcContainerVIew.isHidden = true
        }
        
    }
     var  expandedStatus = false
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        expandedStatus = false
        self.selectionStyle = .none
        separatorLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        separatorLine.shadow()
//        self.moreDetailsContainer.isHidden = false
        self.viewDetails.isHidden = true
        self.moreDetailsContainer.isHidden = true
        self.viewDetails.addTarget(self, action: #selector(didviewDetailsTapped), for: UIControlEvents.touchUpInside)
        self.viewDetails.setTitle("Hide Details", for: .selected)
        self.viewDetails.setTitle("View Details", for: .normal)
        // Initialization code
    }
    @objc func didviewDetailsTapped()
    {
        if expandedStatus == false
        {
             self.expandedStatus = true
            performUIUpdatesOnMain {
                self.viewDetails.isSelected = true
                
                self.moreDetailsContainer.isHidden = false
                
                let tableview : UITableView = self.superview as! UITableView
                //It will update the cell height
                tableview.beginUpdates()
                tableview.endUpdates()
            }
        }
        else
        {
            performUIUpdatesOnMain {
                self.viewDetails.isSelected = false
                self.moreDetailsContainer.isHidden = true
                self.expandedStatus = false
                //                self.setUpMetaDataCell()
                let tableview : UITableView = self.superview as! UITableView
                //It will update the cell height
                tableview.beginUpdates()
                tableview.endUpdates()
            }
        }
    }
    var loadImageFromZuID  :Int64?{
        didSet{
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            self.profileImageView.addSubview(imageView)
            
            //animate the image loading icon
            var loadImages: [UIImage] = []
            loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
            imageView.animate(images: loadImages)
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                //ZSSOKit.getOAuth2Token({ (token, error) in
                if let oAuthToken = token {
                    let _ = ZOSSearchAPIClient.sharedInstance().getContactImage((self.loadImageFromZuID)!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                        if image == nil {
                            //Only UI update need to be done on main thread. This is just loading the image from asset
                            let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                            performUIUpdatesOnMain {
                                imageView.stopAnimate()
                                imageView.image = defImage
                                self.profileImageView.maskCircle(anyImage: defImage)
                            }
                        }
                        else {
                            performUIUpdatesOnMain {
                                //stop the loading image animation
                                imageView.stopAnimate()
                                //set new downloaded image to the image view withing above created border
                                imageView.image = image
                                self.profileImageView.maskCircle(anyImage: image!)
                            }
                        }
                    })
                }
            })
        }
    }
    var loadImageFromMailID : String?{
        didSet{
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            profileImageView.addSubview(imageView)
            // Loading Contact Image
            let matchedContacts = fetchRecordsForEntity(emailID: loadImageFromMailID!)
            if matchedContacts.count > 0 {
                self.loadImageFromZuID = matchedContacts[0].contact_zuid
            }
            else {
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                profileImageView.addSubview(imageView)
            }
        }
    }
    
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    private func fetchRecordsForEntity(emailID: String) -> [UserContacts] {
        // Create Fetch Request
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let portalPredicate = NSPredicate(format: #keyPath(UserContacts.email_address) + " == " + SearchKitConstants.FormatStringConstants.String, emailID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: SearchKitConstants.CoreDataStackConstants.UserContactsTable)
        fetchRequest.predicate = portalPredicate
        
        // Helpers
        var result = [UserContacts]()
        
        do {
            // Execute Fetch Request
            let records = try  coreDataStack?.context.fetch(fetchRequest)
            
            if let records = records as? [UserContacts] {
                result = records
            }
            
        } catch {
            SearchKitLogger.errorLog(message: "Unable to fetch managed objects for entity", filePath: #file, lineNumber: #line, funcName: #function)
            
        }
        
        return result
    }
    
}
