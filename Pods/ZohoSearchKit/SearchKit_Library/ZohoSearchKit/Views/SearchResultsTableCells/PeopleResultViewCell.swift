//
//  PeopleResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class PeopleResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var extnNumber: UILabel!
    
    var searchResultItem: PeopleResult? {
        didSet {
            guard let peopleResult = searchResultItem else {
                return
            }
            
            //set people name
            //empName?.text = item.firstName! + " " + item.lastName!
            let empFullName = peopleResult.firstName! + " " + peopleResult.lastName!
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                empName.text = empFullName
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(empFullName, into: empName)
                empName.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: empFullName, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //this is important for expand cell to work. if not set the text height will return wrong value first time and cause expand to not function as expected.
            //empName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            //email.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            //extnNumber.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            email.text = peopleResult.email
            extnNumber.text = peopleResult.extn
            
            //do we need to check if photo url is there or not
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
                    let _ = ZOSSearchAPIClient.sharedInstance().getImageForURL(peopleResult.photoURL, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
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
            if let peopleResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.People) {
                if let empNameField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "empName") {
                    empName.textColor = empNameField.fieldFontColor
                    empName.font = empName.font.withSize(CGFloat(empNameField.fieldFontSize))
                }
                
                if let emailField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "email") {
                    email.textColor = emailField.fieldFontColor
                    email.font = email.font.withSize(CGFloat(emailField.fieldFontSize))
                }
                
                if let extnNumField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "extnNumber") {
                    extnNumber.textColor = extnNumField.fieldFontColor
                    extnNumber.font = extnNumber.font.withSize(CGFloat(extnNumField.fieldFontSize))
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
        
        empName.text = nil
        empName.attributedText = nil
        empName.numberOfLines = 1
        
        email.numberOfLines = 1
        email.text = nil
        email.attributedText = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

