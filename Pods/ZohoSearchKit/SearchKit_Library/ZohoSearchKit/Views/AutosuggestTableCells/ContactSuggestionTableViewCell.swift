//
//  ContactSuggestionTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 16/02/18.
//

import UIKit

class ContactSuggestionTableViewCell: UITableViewCell {
    @IBOutlet weak var contactsImageView: UIImageView!
    @IBOutlet weak var contactsName: UILabel!
    @IBOutlet weak var contactsEmail: UILabel!
    
    var contact: UserContacts? {
        didSet {
            guard contact != nil else {
                return
            }
            
            //contactsName.text = (contact?.first_name)! + " " + (contact?.last_name)!
            let contactName = (contact?.first_name)! + " " + (contact?.last_name)!
            var searchQueryText = SearchResultsViewModel.QueryVC.suggestionPageSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //to avoid highlighting issue, as if @ is part of search query then first word will not be highlighted.
            //and also if there is no char after @ - i mean when the user just started typing @, then it should not be replaced with whitespace
            if searchQueryText.first == "@" {
                //when the user starts with @
                searchQueryText = searchQueryText.replacingOccurrences(of: "@", with: "")
            }
            else if searchQueryText.last != "@" {
                searchQueryText = searchQueryText.replacingOccurrences(of: " @", with: " ")
            }
            
            let contactEmail = (contact?.email_address)!
            
            if searchQueryText.isEmpty {
                //added in prepareForReuse
                contactsName.attributedText = nil
                contactsName.text = contactName
                
                contactsEmail.attributedText = nil
                contactsEmail.text = contactEmail
            }
            else {
                //highlighting contact
                let maxVisibleCharRange = ResultHighlighter.fit(contactName, into: contactsName)
                contactsName.attributedText = ResultHighlighter.genAutosuggestHighlightedString(with: searchQueryText, targetString: contactName, font: contactsName.font, maxVisibleCharRange: maxVisibleCharRange)
                
                //highlighting email
                let maxVisibleCharRangeEmail = contactsEmail.frame.width
                //this wrongly returns 0 ResultHighlighter.fit(contactEmail, into: contactsEmail)
                contactsEmail.attributedText = ResultHighlighter.genAutosuggestHighlightedString(with: searchQueryText, targetString: contactEmail, font: contactsEmail.font, maxVisibleCharRange: Int(maxVisibleCharRangeEmail))
            }
            
            //contactsEmail.text = contact?.email_address
            
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 40, imageViewHeight: 40) //UIImageView.createCircularSuggestionImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            contactsImageView.addSubview(imageView)
            
            //animate the image loading icon
            var loadImages: [UIImage] = []
            loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
            imageView.animate(images: loadImages)
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                //ZSSOKit.getOAuth2Token({ (token, error) in
                if let oAuthToken = token {
                    let _ = ZOSSearchAPIClient.sharedInstance().getContactImage((self.contact?.contact_zuid)!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                        //ZOSSearchAPIClient.sharedInstance().getImageForURL((self.contact?.photo_url!)!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                        //contact image url from the contact table does not return image. So, we are getting image based on zuid
                        if image == nil {
                            performUIUpdatesOnMain {
                                let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                imageView.stopAnimate()
                                imageView.image = defImage
                                self.contactsImageView.maskCircle(anyImage: defImage)
                            }
                        }
                        else {
                            performUIUpdatesOnMain {
                                //stop the loading image animation
                                imageView.stopAnimate()
                                //set new downloaded image to the image view withing above created border
                                imageView.image = image
                                self.contactsImageView.maskCircle(anyImage: image!)
                            }
                        }
                    })
                }
            })
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
        
        contactsName.attributedText = nil
        contactsEmail.attributedText = nil
    }
    
    override func prepareForReuse() {
        contactsName.attributedText = nil
        contactsEmail.attributedText = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
