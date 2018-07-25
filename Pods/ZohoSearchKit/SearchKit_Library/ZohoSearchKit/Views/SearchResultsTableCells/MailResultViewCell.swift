//
//  MailResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class MailResultViewCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var mailSubject: UILabel!
    @IBOutlet weak var msgTime: UILabel!
    @IBOutlet weak var mailSender: UILabel!
    @IBOutlet weak var mailFolderName: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    //temp code so that each cell is aware of the search query, later should be able to access search query object globally
    
    var searchResultItem: MailResult? {
        didSet {
            guard let mailResult = searchResultItem else {
                return
            }
            
            //set mail subject title
            //mailSubject?.text = item.subject
            
            if mailResult.subject.isEmpty {
                //TODO: we should get this message alone from I18N file
                mailSubject.text = "--- No subject available ---"
            }
            else {
                //search query text that can be stored once should remove unwanted white spaces and store once
                //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
                if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                    mailSubject.text = mailResult.subject
                }
                else {
                    let maxVisibleCharRange = ResultHighlighter.fit(mailResult.subject, into: mailSubject)
                    mailSubject.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: mailResult.subject, maxVisibleCharRange: maxVisibleCharRange)
                }
            }
            
            
            mailSender.text = mailResult.fromAddress
            mailFolderName.text = mailResult.folderName
            //set mail received time
            msgTime.text = DateUtils.getDisaplayableDate(timestamp: mailResult.receivedTime)
            
            //set respective icon depending on mail is read or unread
            if (mailResult.isMailUnRead) {
                mailSubject.font = mailSubject.font.bold
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.MailUnreadImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
                resultImageView.addSubview(imageView)
            }
            else {
                //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
                //mailSubject.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.MailReadImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
                resultImageView.addSubview(imageView)
                //old approach to just show circular image. Above we have added border, padding
                //self.resultImageView.maskCircle(anyImage: image)
            }
            
            if mailResult.hasAttachments! {
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
            if let mailResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                if let mailSubjectField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "mailSubject") {
                    mailSubject.textColor = mailSubjectField.fieldFontColor
                    mailSubject.font = mailSubject.font.withSize(CGFloat(mailSubjectField.fieldFontSize))
                }
                
                if let msgTimeField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "msgTime") {
                    msgTime.textColor = msgTimeField.fieldFontColor
                    msgTime.font = msgTime.font.withSize(CGFloat(msgTimeField.fieldFontSize))
                }
                
                if let mailSenderField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "sender") {
                    mailSender.textColor = mailSenderField.fieldFontColor
                    mailSender.font = mailSender.font.withSize(CGFloat(mailSenderField.fieldFontSize))
                }
                
                if let folderNameField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "folderName") {
                    mailFolderName.textColor = folderNameField.fieldFontColor
                    mailFolderName.font = mailFolderName.font.withSize(CGFloat(folderNameField.fieldFontSize))
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
        
        mailSubject.attributedText = nil
        mailSubject.numberOfLines = 1
        mailSubject.text = nil
        
        //there is no highlighting enabled so attributed text settings is not needed
        //mailSender.attributedText = nil
        //mailSender.text = nil
        mailSender.numberOfLines = 1
        
        //reset font so that bold is not reflected again and again
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let mailResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                if let mailSubjectField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "mailSubject") {
                    mailSubject.textColor = mailSubjectField.fieldFontColor
                    //mailSubject.font = mailSubject.font.withSize(CGFloat(mailSubjectField.fieldFontSize))
                    let subFont = UIFont.systemFont(ofSize: CGFloat(mailSubjectField.fieldFontSize))
                    mailSubject.font = subFont
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
