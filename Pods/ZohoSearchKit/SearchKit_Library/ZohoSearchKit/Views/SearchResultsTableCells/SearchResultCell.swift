//
//  SearchResultCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 11/06/18.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var textIconForResult: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultSubtitle: UILabel!
    @IBOutlet weak var timeOrModule: UILabel!
    @IBOutlet weak var thirdRowStackView: UIStackView!
    @IBOutlet weak var thirdRowMobile: UILabel!
    @IBOutlet weak var thirdRowMobileImageView: UIImageView!
    @IBOutlet weak var thirdRowExtension: UILabel!
    //    @IBOutlet weak var resultModule: UILabel!
    @IBOutlet weak var thirdRowExtnImageView: UIImageView!
    
    var searchResultDataModal  :SearchResultCellDataModal?
    {
        didSet{
            guard searchResultDataModal != nil else
            {
                return
            }
            loadDataSourcefrom(searchResultDataModal: searchResultDataModal!)
        }
    }
    //set this before setting the search result object
    var serviceName: String?
    
    var searchResultItem: SearchResult? {
        didSet {
            
            guard let serviceName = serviceName else {
                return
            }
            
            guard searchResultItem != nil else {
                return
            }
            switch serviceName {
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                self.setMailResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                self.setCliqResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                self.setConnectResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.People:
                self.setPeopleResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                self.setDeskResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                self.setDocsResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                self.setCRMResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
                self.setContactsResultFields()
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                self.setWikiResultFields()
            default:
                break
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
        separatorLine.backgroundColor = SearchKitConstants.ColorConstants.AllService_SectionsSeparatorView_BackGround_Color
        //Initialization code
        
        //Important: If we don't set explicitly the font and font size, expand shrink creates issue, it will not expand and shrink properly
        //as the cell does not it's intrinsic height and all.
        //TODO: Later will handle generically, for now will follow old logic
        //Most probably we will have common color and size for all the result cells, when we have different one we will have to handle
        
        //All the color properties will be set to only prototype/template cell all other view will be cloned, so not a performance bottle neck
        //also please remember that awakeFromNib will be called only once during cell creation
        
        if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let mailResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                    if let mailSubjectField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "mailSubject") {
                        resultTitle.textColor = mailSubjectField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(mailSubjectField.fieldFontSize))
                    }
                    
                    if let msgTimeField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "msgTime") {
                        timeOrModule.textColor = msgTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(msgTimeField.fieldFontSize))
                    }
                    
                    if let mailSenderField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "sender") {
                        resultSubtitle.textColor = mailSenderField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(mailSenderField.fieldFontSize))
                    }
                    
//                    if let folderNameField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "folderName") {
//                        resultModule.textColor = folderNameField.fieldFontColor
//                        resultModule.font = resultModule.font.withSize(CGFloat(folderNameField.fieldFontSize))
//                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Cliq {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let chatResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
                    if let chatTitleField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "chatTitle") {
                        resultTitle.textColor = chatTitleField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(chatTitleField.fieldFontSize))
                    }
                    
                    if let chatMsgTimeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "msgTime") {
                        timeOrModule.textColor = chatMsgTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(chatMsgTimeField.fieldFontSize))
                    }
                    
                    if let chatTypeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "chatType") {
                        resultSubtitle.textColor = chatTypeField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(chatTypeField.fieldFontSize))
                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let chatResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Connect) {
                    if let connectTitleField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectTitle") {
                        resultTitle.textColor = connectTitleField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(connectTitleField.fieldFontSize))
                    }
                    
                    if let connectPostTimeField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectPostTime") {
                        timeOrModule.textColor = connectPostTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(connectPostTimeField.fieldFontSize))
                    }
                    
                    if let connectPostAuthorField = chatResultUIConfig.getFieldUIConfig(withIdentifier: "connectPostAuthor") {
                        resultSubtitle.textColor = connectPostAuthorField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(connectPostAuthorField.fieldFontSize))
                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Documents {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let docsResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Documents) {
                    if let docNameField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "docName") {
                        resultTitle.textColor = docNameField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(docNameField.fieldFontSize))
                    }
                    
                    if let lmTimeField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "lmTime") {
                        timeOrModule.textColor = lmTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(lmTimeField.fieldFontSize))
                    }
                    
                    if let docAuthorField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "docAuthor") {
                        resultSubtitle.textColor = docAuthorField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(docAuthorField.fieldFontSize))
                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Contacts {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let contactsResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Contacts) {
                    if let contactNameField = contactsResultUIConfig.getFieldUIConfig(withIdentifier: "contactName") {
                        resultTitle.textColor = contactNameField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(contactNameField.fieldFontSize))
                    }
                    
                    if let contactEmailField = contactsResultUIConfig.getFieldUIConfig(withIdentifier: "contactEmail") {
                        resultSubtitle.textColor = contactEmailField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(contactEmailField.fieldFontSize))
                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.People {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let peopleResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.People) {
                    if let empNameField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "empName") {
                        resultTitle.textColor = empNameField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(empNameField.fieldFontSize))
                    }
                    
                    if let emailField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "email") {
                        resultSubtitle.textColor = emailField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(emailField.fieldFontSize))
                    }
                    
//                    if let extnNumField = peopleResultUIConfig.getFieldUIConfig(withIdentifier: "extnNumber") {
//                        resultModule.textColor = extnNumField.fieldFontColor
//                        resultModule.font = resultModule.font.withSize(CGFloat(extnNumField.fieldFontSize))
//                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let deskResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Desk) {
                    if let deskTitleField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "deskTitle") {
                        resultTitle.textColor = deskTitleField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(deskTitleField.fieldFontSize))
                    }
                    
                    if let creationTimeField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "creationTime") {
                        timeOrModule.textColor = creationTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(creationTimeField.fieldFontSize))
                    }
                    
                    if let subtitleOneField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleOne") {
                        resultSubtitle.textColor = subtitleOneField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(subtitleOneField.fieldFontSize))
                    }
                    
//                    if let subtitleTwoField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleTwo") {
//                        resultModule.textColor = subtitleTwoField.fieldFontColor
//                        resultModule.font = resultModule.font.withSize(CGFloat(subtitleTwoField.fieldFontSize))
//                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Crm {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let crmResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Crm) {
                    if let crmTitleField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "crmTitle") {
                        resultTitle.textColor = crmTitleField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(crmTitleField.fieldFontSize))
                    }
                    
                    if let subtitleOneField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleOne") {
                        resultSubtitle.textColor = subtitleOneField.fieldFontColor
                        resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(subtitleOneField.fieldFontSize))
                    }
                    
                    if let textIconField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "iconText") {
                        textIconForResult.textColor = textIconField.fieldFontColor
                        textIconForResult.font = textIconForResult.font.withSize(CGFloat(textIconField.fieldFontSize))
                    }
                }
            }
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki {
            if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
                if let wikiResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
                    if let wikiNameField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "wikiName") {
                        resultTitle.textColor = wikiNameField.fieldFontColor
                        resultTitle.font = resultTitle.font.withSize(CGFloat(wikiNameField.fieldFontSize))
                    }
                    
                    if let wikiLMTimeField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "lastModTime") {
                        timeOrModule.textColor = wikiLMTimeField.fieldFontColor
                        timeOrModule.font = timeOrModule.font.withSize(CGFloat(wikiLMTimeField.fieldFontSize))
                    }
                    
//                    if let wikiAuthorField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "wikiAuthor") {
//                        resultModule.textColor = wikiAuthorField.fieldFontColor
//                        resultModule.font = resultModule.font.withSize(CGFloat(wikiAuthorField.fieldFontSize))
//                    }
                }
            }
        }
        
    }
    
    //so that image overlapping does not happen in case of cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        thirdRowStackView.isHidden = true
        thirdRowMobileImageView.isHidden = true
        thirdRowExtnImageView.isHidden = true
        thirdRowMobile.isHidden = true
        thirdRowExtension.isHidden = true
        //Time fields and module field is used only in some service results
        timeOrModule.isHidden = true
//        resultModule.isHidden = true
        //text icon instead of image icon is used only in CRM
        textIconForResult.isHidden = true
        
        //attachment icon is used only in Mail,Connect
        attachmentImageView.isHidden = true
        attachmentImageView.image = nil
        let aExtSubviews = attachmentImageView.subviews
        for subView in aExtSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        resultImageView.image = nil
        
        let extSubviews = resultImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        resultTitle.text = nil
        resultTitle.attributedText = nil
        resultTitle.numberOfLines = 1
        
        resultSubtitle.numberOfLines = 1
        
        //this is used only in case of mail search results
        //reset font so that bold is not reflected again and again
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let mailResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                if let mailSubjectField = mailResultUIConfig.getFieldUIConfig(withIdentifier: "mailSubject") {
                    resultTitle.textColor = mailSubjectField.fieldFontColor
                    //mailSubject.font = mailSubject.font.withSize(CGFloat(mailSubjectField.fieldFontSize))
                    let subFont = UIFont.systemFont(ofSize: CGFloat(mailSubjectField.fieldFontSize))
                    resultTitle.font = subFont
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func setMailResultFields() {
        timeOrModule.isHidden = false
//        resultModule.isHidden = false
        
        let mailResult = searchResultItem as! MailResult
        if mailResult.subject.isEmpty {
            //TODO: we should get this message alone from I18N file
            resultTitle.text = "--- No subject available ---"
        }
        else {
            //search query text that can be stored once should remove unwanted white spaces and store once
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                resultTitle.text = mailResult.subject
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(mailResult.subject, into: resultTitle)
                resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: mailResult.subject, maxVisibleCharRange: maxVisibleCharRange)
            }
        }
        
        
        resultSubtitle.text = mailResult.fromAddress
//        resultModule.text = mailResult.folderName
        //set mail received time
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: mailResult.receivedTime)
        
        //set respective icon depending on mail is read or unread
        if (mailResult.isMailUnRead) {
            resultTitle.font = resultTitle.font.bold
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
    
    internal func setCliqResultFields() {
        timeOrModule.isHidden = false
        
        let chatResult = searchResultItem as! ChatResult
        
        //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = chatResult.chatTitle
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(chatResult.chatTitle, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: chatResult.chatTitle, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        //set chat time
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: chatResult.messageTime)
        
        //Must not be done for all the cells. One time
        //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
        //chatTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        //temp code to test static image for all cases
        /*
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
        //so that after failure of image loading also image will be circular
        imageView.maskCircle(anyImage: image)
        
        resultImageView.addSubview(imageView)
        */
        
        
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
        //if (chatResult.accountID == ZohoSearchKit.sharedInstance().getCurrentUser().zuid) {
        if (chatResult.accountID == ZohoSearchKit.sharedInstance().getCurrentUserZUID()) {
            //Must come from string resouces
            resultSubtitle?.text = "Me"
        }
        else {
            resultSubtitle?.text = chatResult.chatOwnerName
        }
    }
    
    internal func setConnectResultFields() {
        timeOrModule.isHidden = false
        
        let connectResult = searchResultItem as! ConnectResult
        //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = connectResult.postTitle!
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(connectResult.postTitle!, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: connectResult.postTitle!, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
        //postTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        resultSubtitle.text = connectResult.authorName
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: connectResult.postTime)
        
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
    
    internal func setPeopleResultFields() {
        let peopleResult = searchResultItem as! PeopleResult
        let empFullName = peopleResult.firstName! + " " + peopleResult.lastName!
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = empFullName
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(empFullName, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: empFullName, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        //this is important for expand cell to work. if not set the text height will return wrong value first time and cause expand to not function as expected.
        //empName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        //email.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //extnNumber.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        if  (peopleResult.extn != nil && peopleResult.extn?.isEmpty == false) || (peopleResult.mobile != nil && peopleResult.mobile?.isEmpty == false)
        {
            thirdRowStackView.isHidden = false
            if peopleResult.extn != nil && peopleResult.extn?.isEmpty == false
            {
                 self.thirdRowExtension.text = peopleResult.extn
                self.thirdRowExtension.isHidden = false
                self.thirdRowExtnImageView.isHidden = false
            }
            if peopleResult.mobile != nil && peopleResult.mobile?.isEmpty == false
            {
                 self.thirdRowMobile.text = peopleResult.mobile
                self.thirdRowMobile.isHidden = false
                self.thirdRowMobileImageView.isHidden = false
            }
        }
       resultSubtitle.text = peopleResult.email
//        resultModule.text = peopleResult.extn
        
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
    
    internal func setDocsResultFields() {
        timeOrModule.isHidden = false
        
        let docsResult = searchResultItem as! DocsResult
        
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = docsResult.docName
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(docsResult.docName, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: docsResult.docName, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        resultSubtitle.text = docsResult.docAuthor
        
        //set document last modified time
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: docsResult.lastModifiedTime)
        
        let image:UIImage = ResultIconUtils.getIconForDocsResult(docResult: docsResult)
        let imageView =  UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
        resultImageView.addSubview(imageView)
    }
    
    internal func setDeskResultFields() {
//        resultModule.isHidden = false
        
        //TODO: this will not be shown in case of contacts and accounts
        timeOrModule.isHidden = false
        
        let supportResult = searchResultItem as! SupportResult
        
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = supportResult.title!
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(supportResult.title!, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: supportResult.title!, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        resultSubtitle.text = supportResult.subtitle1
//        resultModule.text = supportResult.subtitle2
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: supportResult.createdTime)
        
        let image:UIImage = ResultIconUtils.getIconForDeskResult(deskResult: supportResult)
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
        resultImageView.addSubview(imageView)
    }
    
    internal func setCRMResultFields() {
//        resultModule.isHidden = false
        let crmResult = searchResultItem as! CRMResult
        timeOrModule.isHidden = false
        timeOrModule.text = crmResult.moduleName
//        resultModule.text = crmResult.moduleName
        //find title and subtitle and then set
        var title = ""
        var subtitle = ""
        (title , subtitle) = crmResult.getCrmTitleAndSubTitle()
        //set crm result title
        //resultTitle?.text = item.company
        
        if title.isEmpty == false {
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                resultTitle.text = title
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(title, into: resultTitle)
                resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: title, maxVisibleCharRange: maxVisibleCharRange)
            }
        }
        else {
            resultTitle.text = ""
        }
        //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
        //resultTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        resultSubtitle.text = subtitle
        //set module specific icon
        let image:UIImage? = ResultIconUtils.getIconForCRMResult(crmResult: crmResult)
        if let image = image {
            resultImageView.isHidden =  false
            textIconForResult.isHidden = true
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60)
            resultImageView.addSubview(imageView)
        }
        else {
            resultImageView.isHidden =  true
            textIconForResult.isHidden = false
            textIconForResult.text = SearchKitUtil.generateIconText(inputStr: crmResult.moduleName)
            textIconForResult.createCircularView()
        }
    }
    
    internal func setContactsResultFields() {
        let contactResult = searchResultItem as! ContactsResult
        
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = contactResult.fullName!
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(contactResult.fullName!, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: contactResult.fullName!, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
        //contactName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        resultSubtitle.text = contactResult.emailAddress
        
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
    
    internal func setWikiResultFields() {
        timeOrModule.isHidden = false
        
        let wikiResult = searchResultItem as! WikiResult
        
        if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            resultTitle.text = wikiResult.wikiName
        }
        else {
            let maxVisibleCharRange = ResultHighlighter.fit(wikiResult.wikiName, into: resultTitle)
            resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: wikiResult.wikiName, maxVisibleCharRange: maxVisibleCharRange)
        }
        
        resultSubtitle.text = wikiResult.authorDisplayName
        
        //set wiki last modified time
        timeOrModule.text = DateUtils.getDisaplayableDate(timestamp: wikiResult.lastModifiedTime)
        
        //TODO: for wiki this should happen only once when creating cell, that is awake from nib
        //one time operation for cell - as the icon is the same
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.WikiResultImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
        resultImageView.addSubview(imageView)
    }
}
extension SearchResultCell
{
    func loadDataSourcefrom(searchResultDataModal  :SearchResultCellDataModal)
    {
        
        if searchResultDataModal.ismailUnread == true
        {
            self.resultTitle.font = self.resultTitle.font.bold
        }
        
        if let title = searchResultDataModal.resultTitle
        {
            self.resultTitle.isHidden = false
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                self.resultTitle.text = title
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(title, into: resultTitle)
                resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: title, maxVisibleCharRange: maxVisibleCharRange)
            }
        }
        else
        {
            self.resultTitle.text = "---No title---"
        }
        
        if let resultImageName =  searchResultDataModal.resultImageName
        {
            self.resultImageView.loadPhotofor(imageName: resultImageName)
        }
        else if let zuid = searchResultDataModal.contactImageZUID
        {
            self.resultImageView.kfloadContactImagefor(zuid: zuid)
        }
        else if let url = searchResultDataModal.ImageURl
        {
            let imageURL = URL(string: url)!
            self.resultImageView.kfloadPhotofor(photoURL: imageURL)
        }
        if let textIcon =  searchResultDataModal.textIconForResult
        {
            self.textIconForResult.isHidden = false
            self.textIconForResult.text = textIcon
        }
        else
        {
            self.textIconForResult.isHidden = true
            
        }
        if let subtitle =  searchResultDataModal.resultSubtitle
        {
            self.resultSubtitle.isHidden = false
            self.resultSubtitle.text = subtitle
        }
        else
        {
            self.resultSubtitle.isHidden = true
            
        }
        if let time = searchResultDataModal.time
        {
            self.timeOrModule.isHidden = false
            self.timeOrModule.text = time
        }
        else
        {
            self.timeOrModule.isHidden = true
        }
//        if let moduleName = searchResultDataModal.resultModule
//        {
//            self.resultModule.isHidden = false
//            self.resultModule.text = moduleName
//        }
//        else
//        {
//            self.resultModule.isHidden = true
//        }
        if let attImageName = searchResultDataModal.attachmentImageName
        {
             self.attachmentImageView.isHidden = false
             self.attachmentImageView.frame = CGRect(x: -6, y: 0, width: 22, height: 22)
             self.attachmentImageView.layer.cornerRadius =  self.attachmentImageView.frame.size.width / 2
             self.attachmentImageView.clipsToBounds = true
             self.attachmentImageView.layer.masksToBounds = false
             let image:UIImage = UIImage(named: attImageName, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
             self.attachmentImageView.image = image.imageWithInsets(insets: UIEdgeInsetsMake(6, 6, 6, 6))
        }
        else
        {
            self.attachmentImageView.isHidden = true
        }
    }
}
