//
//  MailCalloutMetaDataTableViewCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 07/05/18.
//

import UIKit
import CoreData
class MailCalloutMetaDataTableViewCell: UITableViewCell {
    @IBOutlet weak var otherToAddresses: UILabel!
    @IBOutlet var senderImageView: UIImageView!
    @IBOutlet var fromValueLabel: UILabel!
    @IBOutlet var expandedToValue: UILabel!
    @IBOutlet var toValueLabel: UILabel!
    @IBOutlet var messageTime: UILabel!
    @IBOutlet var folderNameLabel: UILabel!
    @IBOutlet weak var cCValue: UILabel!
    @IBOutlet weak var metaDataContainerSV: UIStackView!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var SenderDetailedStackView: UIStackView!
    @IBOutlet weak var ExpandedTOAdressContainer: UIStackView!
    @IBOutlet weak var ccDetailedContainer: UIStackView!
    let blueTextColor = SearchKitConstants.ColorConstants.SkyBlueColorForSelectionIndication
    let blackTextColor = SearchKitConstants.ColorConstants.Bold_Text_Color
    var toAddreses : [String]?{
        didSet{
            var temptoAddress = toAddreses
            if temptoAddress?.isEmpty == false
            {
                temptoAddress?.remove(at: 0)
            }
            expandedToValue.text =  temptoAddress?.joined(separator: "\n")
            if ( toAddreses?.count)! > 1
            {
                otherToAddresses.isHidden = false
                if ccAddress != nil
                {
                    toValueLabel.text = (toAddreses?.first)!
                    otherToAddresses.text  = " & \((toAddreses?.count)! + (ccAddress?.count)! - 1) Others"
                }
                else
                {
                    toValueLabel.text = (toAddreses?.first)!
                    otherToAddresses.text  = " & \((toAddreses?.count)!  - 1) Others"
                }
                ExpandedTOAdressContainer.isHidden = false
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didToValueTapped))
                let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didToValueTapped))
                otherToAddresses.addGestureRecognizer(tapGesture2)
                toValueLabel.addGestureRecognizer(tapGesture)
                toValueLabel.textColor = blueTextColor
                otherToAddresses.textColor = blueTextColor
            }
            else
            {
                otherToAddresses.isHidden = true
                if ccAddress != nil && (ccAddress?.count)! <= 0
                {
                    toValueLabel.textColor = blackTextColor
                    otherToAddresses.textColor = blackTextColor
                }
                ExpandedTOAdressContainer.isHidden = true
                toValueLabel.text = toAddreses?.first
                
            }
        }
    }
    var ccAddress : [String]?{
        didSet{
            if let cc = ccAddress?.joined(separator: "\n") , cc.isEmpty == false , (ccAddress?.count)! > 0
            {
                otherToAddresses.isHidden = false
                cCValue.text = cc
                ccDetailedContainer.isHidden = false
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didToValueTapped))
                let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didToValueTapped))
                otherToAddresses.addGestureRecognizer(tapGesture2)
                toValueLabel.addGestureRecognizer(tapGesture)
                toValueLabel.textColor = blueTextColor
                otherToAddresses.textColor = blueTextColor
                if toAddreses != nil
                {
                    toValueLabel.text = (toAddreses?.first)!
                    otherToAddresses.text  = " & \((toAddreses?.count)! + (ccAddress?.count)! - 1) Others"
                }
                else
                {
                    toValueLabel.text = toValueLabel.text!
                    otherToAddresses.text  = " & \( (ccAddress?.count)! - 1) Others"
                }
            }
            else
            {
                ccDetailedContainer.isHidden = true
                if toAddreses != nil && (toAddreses?.count)! <= 0
                {
                    toValueLabel.textColor = blackTextColor
                    otherToAddresses.textColor = blackTextColor
                    otherToAddresses.isHidden = true
                }
                
            }
            
        }
    }
    
    var LoadImageForMailID : String?{
        didSet{
            // Loading Contact Image
            let matchedContacts = fetchRecordsForEntity(emailID: LoadImageForMailID!)
            if matchedContacts.count > 0 {
                //first load the no user image and show loading icon
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularSuggestionImageViewWithBorder(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                senderImageView.addSubview(imageView)
                
                //animate the image loading icon
                var loadImages: [UIImage] = []
                loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
                imageView.animate(images: loadImages)
                
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    //ZSSOKit.getOAuth2Token({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getContactImage((matchedContacts[0].contact_zuid), oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            //ZOSSearchAPIClient.sharedInstance().getImageForURL((self.contact?.photo_url!)!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            //contact image url from the contact table does not return image. So, we are getting image based on zuid
                            if image == nil {
                                performUIUpdatesOnMain {
                                    let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                    imageView.stopAnimate()
                                    imageView.image = defImage
                                    self.senderImageView.maskCircle(anyImage: defImage)
                                }
                            }
                            else {
                                performUIUpdatesOnMain {
                                    //stop the loading image animation
                                    imageView.stopAnimate()
                                    //set new downloaded image to the image view withing above created border
                                    imageView.image = image
                                    self.senderImageView.maskCircle(anyImage: image!)
                                }
                            }
                        })
                    }
                })
            }
            else {
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                senderImageView.addSubview(imageView)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        separatorLine.shadow()
        SenderDetailedStackView.isHidden = true
        toValueLabel.isUserInteractionEnabled = true
        otherToAddresses.isUserInteractionEnabled = true
    }
    static var  expandedStatus = false
    @objc func didToValueTapped()
    {
        if MailCalloutMetaDataTableViewCell.expandedStatus == false
        {
            
            if (toAddreses?.count)! > 1 || (ccAddress?.count)! > 0
            {
                MailCalloutMetaDataTableViewCell.expandedStatus = true
                SenderDetailedStackView.isHidden = false
                let tableview : UITableView = self.superview as! UITableView
                //It will update the cell height
                tableview.beginUpdates()
                tableview.endUpdates()
            }

        }
        else
        {
            if (toAddreses?.count)! > 1 || (ccAddress?.count)! > 0
            {
                MailCalloutMetaDataTableViewCell.expandedStatus = false
                SenderDetailedStackView.isHidden = true
                let tableview : UITableView = self.superview as! UITableView
                //It will update the cell height
                tableview.beginUpdates()
                tableview.endUpdates()
            }
            
        }
    }
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
