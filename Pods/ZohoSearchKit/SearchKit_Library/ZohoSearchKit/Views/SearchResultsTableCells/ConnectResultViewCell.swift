//
//  ConnectResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class ConnectResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    var searchResultItem: ConnectResult? {
        didSet {
            guard let connectResult = searchResultItem else {
                return
            }
            
            //set post title, author and time
            //postTitle?.text = item.postTitle
            
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                postTitle.text = connectResult.postTitle!
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(connectResult.postTitle!, into: postTitle)
                postTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: connectResult.postTitle!, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //postTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            postAuthor.text = connectResult.authorName
            postTime.text = DateUtils.getDisaplayableDate(timestamp: connectResult.postTime)
            
            //set author image
            if (connectResult.authorZUID == -1) {
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                self.resultImageView.maskCircle(anyImage: image)
            }
            else {
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
                        let _ = ZOSSearchAPIClient.sharedInstance().getContactImage(connectResult.authorZUID, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            if image == nil {
                                //Only UI update need to be done on main thread. This is just loading the image from asset
                                let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                performUIUpdatesOnMain {
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
            
            if connectResult.hasAttachments! {
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.AttachmentImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                performUIUpdatesOnMain {
                    self.attachmentImageView.isHidden = false
                    
                    let imageView = UIImageView(image: image.imageWithInsets(insets: UIEdgeInsetsMake(6, 6, 6, 6)))
                    //here 60 is height, should be from image view container
                    imageView.frame = CGRect(x: -6, y: 0, width: 22, height: 22)
                    
                    //make circle
                    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
                    imageView.clipsToBounds = true;
                    imageView.layer.masksToBounds = false
                    
                    self.attachmentImageView.addSubview(imageView)
                    
                }
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
            if let chatResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Connect) {
                if let connectTitleField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectTitle") {
                    postTitle.textColor = connectTitleField.fieldFontColor
                    postTitle.font = postTitle.font.withSize(CGFloat(connectTitleField.fieldFontSize))
                }
                
                if let connectPostTimeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectPostTime") {
                    postTime.textColor = connectPostTimeField.fieldFontColor
                    postTime.font = postTime.font.withSize(CGFloat(connectPostTimeField.fieldFontSize))
                }
                
                if let connectPostAuthorField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectPostAuthor") {
                    postAuthor.textColor = connectPostAuthorField.fieldFontColor
                    postAuthor.font = postAuthor.font.withSize(CGFloat(connectPostAuthorField.fieldFontSize))
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
        
        attachmentImageView.isHidden = true
        attachmentImageView.image = nil
        let aExtSubviews = attachmentImageView.subviews
        for subView in aExtSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        postTitle.text = nil
        postTitle.attributedText = nil
        postTitle.numberOfLines = 1
        
        postAuthor.numberOfLines = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
