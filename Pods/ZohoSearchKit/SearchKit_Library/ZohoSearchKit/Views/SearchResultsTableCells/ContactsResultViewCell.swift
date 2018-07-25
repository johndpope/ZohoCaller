//
//  ContactsResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit
//import SSOKit

class ContactsResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    
    var searchResultItem: ContactsResult? {
        didSet {
            guard let contactResult = searchResultItem else {
                return
            }
            
            //set contact name
            //contactName?.text = item.fullName
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                contactName.text = contactResult.fullName!
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(contactResult.fullName!, into: contactName)
                contactName.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: contactResult.fullName!, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //contactName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            contactEmail.text = contactResult.emailAddress
            
            if let photo = contactResult.photoURL, photo.isEmpty {
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                self.resultImageView.maskCircle(anyImage: image)
            }
            else {
                //currently using photo url and it does not work as Accounts team has issue
                
                //first load the no user image and show loading icon
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                resultImageView.addSubview(imageView)
                
                //animate the image loading icon
                var loadImages: [UIImage] = []
                loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
                imageView.animate(images: loadImages)
                
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    //ZSSOKit.getOAuth2Token({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getImageForURL(contactResult.photoURL!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            if image == nil {
                                performUIUpdatesOnMain {
                                    let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                    imageView.stopAnimate()
                                    imageView.image = defImage
                                    self.resultImageView.maskCircle(anyImage: defImage)
                                }
                            }
                            else {
                                performUIUpdatesOnMain {
                                    //stop the loading image animation
                                    imageView.stopAnimate()
                                    //set new downloaded image to the image view withing above created border
                                    imageView.image = image
                                    self.resultImageView.maskCircle(anyImage: image!)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let contactsResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Contacts) {
                if let contactNameField = contactsResultUIConfig.getFieldUIConfig(withIdentifier: "contactName") {
                    contactName.textColor = contactNameField.fieldFontColor
                    contactName.font = contactName.font.withSize(CGFloat(contactNameField.fieldFontSize))
                }
                
                if let contactEmailField = contactsResultUIConfig.getFieldUIConfig(withIdentifier: "contactEmail") {
                    contactEmail.textColor = contactEmailField.fieldFontColor
                    contactEmail.font = contactEmail.font.withSize(CGFloat(contactEmailField.fieldFontSize))
                }
            }
        }
    }
    
    //so that image overlapping does not happen in case of cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.image = nil
        let extSubviews = resultImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        contactName.text = nil
        contactName.attributedText = nil
        contactName.numberOfLines = 1
        
        contactEmail.numberOfLines = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
