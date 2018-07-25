//
//  CalloutVCMetaDataCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 14/05/18.
//

import UIKit
import CoreData

class CalloutVCMetaDataCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var metaDataContainer: UIStackView!
    @IBOutlet weak var fromNameValueContainer: UIStackView!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var fromValueLabel: UILabel!
    @IBOutlet weak var dateFolderContainer: UIStackView!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var folderValueLabel: UILabel!
    @IBOutlet weak var toNameValueContainer: UIStackView!
    @IBOutlet weak var toNameLabel: UILabel!
    @IBOutlet weak var toValueLabel: UILabel!
    
    @IBOutlet weak var viewDetailsButton: UIButton!

    @IBOutlet weak var separatorLine: UIView!

     func  setUpConnectCallout()
     {
        let connectMetaData = self.calloutMetaData as! ConnectCalloutMetaData
        
        if connectMetaData.postByValue != nil
        {
            self.fromNameValueContainer.isHidden = false
            self.fromNameLabel.text = connectMetaData.postByLabelName
            self.fromValueLabel.text = connectMetaData.postByValue
        }
        else
        {
             self.fromNameValueContainer.isHidden = true
        }
     
        if connectMetaData.postedIn != nil && connectMetaData.postedIn?.isEmpty == false
        {
            self.toNameValueContainer.isHidden = false
            self.toNameLabel.text = connectMetaData.postedInLabelName
            self.toValueLabel.text = connectMetaData.postedIn
        }
        else
        {
            self.toNameValueContainer.isHidden = true
        }
        if connectMetaData.dateValue != nil
        {
            self.dateFolderContainer.isHidden = false
            self.dateValueLabel.text = connectMetaData.dateValue
            self.folderValueLabel.isHidden = true
        }
        else
        {
            self.dateFolderContainer.isHidden = true
        }
        
    }
    func  setUpWikiCallout()
    {
        let wikiMetaData = self.calloutMetaData as! WikiCalloutMetaData
        
        if wikiMetaData.createdByValue != nil
        {
            self.fromNameValueContainer.isHidden = false
            self.fromNameLabel.text = wikiMetaData.createdByLabelName
            self.fromValueLabel.text = wikiMetaData.createdByValue
        }
        else
        {
            self.fromNameValueContainer.isHidden = true
        }
        if wikiMetaData.postedIn != nil && wikiMetaData.postedIn?.isEmpty == false
        {
            self.toNameValueContainer.isHidden = false
            self.toNameLabel.text = wikiMetaData.postedInLabelName
            self.toValueLabel.text = wikiMetaData.postedIn
        }
        else
        {
            self.toNameValueContainer.isHidden = true
        }
        
        if wikiMetaData.dateValue != nil
        {
            self.dateFolderContainer.isHidden = false
            self.dateValueLabel.text = wikiMetaData.dateValue
            
            self.folderValueLabel.isHidden = true
        }
        else
        {
            self.dateFolderContainer.isHidden = true
        }
    }
    func  setUpDeskCallout()
    {
        let deskMetaData = self.calloutMetaData as! DeskCalloutMetaData
        
        if deskMetaData.fromValue != nil
        {
            self.fromNameValueContainer.isHidden = false
            self.fromNameLabel.text = deskMetaData.fromLabelName
            self.fromValueLabel.text = deskMetaData.fromValue
        }
        else
        {
            self.fromNameValueContainer.isHidden = true
        }
        if deskMetaData.assignedToValue != nil &&  deskMetaData.assignedToValue?.isEmpty == false
        {
            self.toNameValueContainer.isHidden = false
            self.toNameLabel.text = deskMetaData.assignedToLabelName
            self.toValueLabel.text = deskMetaData.assignedToValue
        }
        else
        {
            self.toNameValueContainer.isHidden = true
        }
        if deskMetaData.dateValue != nil || deskMetaData.statusValue != nil
        {
            self.dateFolderContainer.isHidden = false
            self.dateValueLabel.text = deskMetaData.dateValue
            self.folderValueLabel.text = deskMetaData.statusValue
        }
        else
        {
            self.dateFolderContainer.isHidden = true
        }
        
    }
    var calloutMetaData : CalloutMetaData?{
        didSet {
            guard let _ = calloutMetaData else {
                return
            }
            if self.calloutMetaData?.photoFromMailId != nil ,self.calloutMetaData?.photoFromMailId?.isEmpty == false
            {
                loadImageFromMailID = self.calloutMetaData?.photoFromMailId
            }
            else if self.calloutMetaData?.photoFromZuID != nil
            {
                loadImageFromZuID = self.calloutMetaData?.photoFromZuID
            }
            let serviceName = self.calloutMetaData?.serviceName
            switch  serviceName
            {
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                setUpConnectCallout()
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                setUpDeskCallout()
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                setUpWikiCallout()
            default:
                break
            }
        }
    }
    let blueTextColor = SearchKitConstants.ColorConstants.SkyBlueColorForSelectionIndication
    let blackTextColor = SearchKitConstants.ColorConstants.Bold_Text_Color
    var loadImageFromZuID  :Int64?{
        didSet{
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            photo.addSubview(imageView)
            
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
                                self.photo.maskCircle(anyImage: defImage)
                            }
                        }
                        else {
                            performUIUpdatesOnMain {
                                //stop the loading image animation
                                imageView.stopAnimate()
                                //set new downloaded image to the image view withing above created border
                                imageView.image = image
                                self.photo.maskCircle(anyImage: image!)
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
            photo.addSubview(imageView)
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
                photo.addSubview(imageView)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        separatorLine.shadow()
        viewDetailsButton.setTitle("View Details", for: .normal)
        viewDetailsButton.setTitle("Hide Details", for: .selected)
        viewDetailsButton.isHidden = true
    }
    static var  expandedStatus = false

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
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
            let records = try coreDataStack?.context.fetch(fetchRequest)
            
            if let records = records as? [UserContacts] {
                result = records
            }
            
        } catch {
            SearchKitLogger.errorLog(message: "Unable to fetch managed objects for entity", filePath: #file, lineNumber: #line, funcName: #function)
            
        }
        
        return result
    }
    
}
