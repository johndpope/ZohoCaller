//
//  ChatResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//TODO: Some of the codes are same in most of the cells. Later will make more abstracted and it on consolidation might be we will use only one definition
//for the search result cell, as the layout is almost the same in all of the result cells
class ChatResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var chatType: UILabel!
    
    var searchResultItem: ChatResult? {
        didSet {
            guard let chatResult = searchResultItem else {
                return
            }
            
            //set chat title
            //chatTitle?.text = chatResult.chatTitle
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                chatTitle.text = chatResult.chatTitle
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(chatResult.chatTitle, into: chatTitle)
                chatTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: chatResult.chatTitle, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //set chat time
            messageTime.text = DateUtils.getDisaplayableDate(timestamp: chatResult.messageTime)
            
            //Must not be done for all the cells. One time
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //chatTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            //set chat result image
            if (chatResult.getImageZUID == -1) {
                //set group chat image from local asset
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.CliqGroupChatImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
                resultImageView.addSubview(imageView)
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
                        let _ = ZOSSearchAPIClient.sharedInstance().getContactImage(chatResult.getImageZUID, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
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
            
            //set chat type
            if (chatResult.accountID == ZohoSearchKit.sharedInstance().getCurrentUser().zuid) {
                //Must come from string resouces
                chatType?.text = "Me"
            }
            else {
                chatType?.text = chatResult.chatOwnerName
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
        
        //All the color properties will be set to only prototype/template cell all other view will be cloned, so not a performance bottle neck
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let chatResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
                if let chatTitleField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "chatTitle") {
                    chatTitle.textColor = chatTitleField.fieldFontColor
                    chatTitle.font = chatTitle.font.withSize(CGFloat(chatTitleField.fieldFontSize))
                }
                
                if let chatMsgTimeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "msgTime") {
                    messageTime.textColor = chatMsgTimeField.fieldFontColor
                    messageTime.font = messageTime.font.withSize(CGFloat(chatMsgTimeField.fieldFontSize))
                }
                
                if let chatTypeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "chatType") {
                    chatType.textColor = chatTypeField.fieldFontColor
                    chatType.font = chatType.font.withSize(CGFloat(chatTypeField.fieldFontSize))
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
        
        chatTitle.text = nil
        chatTitle.numberOfLines = 1
        chatTitle.attributedText = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
