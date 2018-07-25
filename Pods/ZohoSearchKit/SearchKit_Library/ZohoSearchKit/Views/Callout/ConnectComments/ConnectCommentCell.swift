//
//  ConnectCommentCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 16/05/18.
//

import UIKit

class ConnectCommentCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var commentcellHeight: NSLayoutConstraint!
    var commentData :ConnectCommentData?{
        didSet{
            if commentData != nil
            {
                loadImageFromZuID = commentData?.zuid
                nameLabel.text = commentData?.name
                time.text = commentData?.time
                webView.loadHTMLString((commentData?.content)!, baseURL: nil)
            }
        }
    }
    var loadImageFromZuID  :Int64?{
        didSet{
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            photo.maskCircle(anyImage: image)
            //            photo.addSubview(imageView)
            
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
        let activityIndicator = ActivityIndicatorUtils()
    override func prepareForReuse() {
        
        for (i,image) in photo.subviews.enumerated()
        {
            if i != 0
            {
                image.removeFromSuperview()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.showActivityIndicator(uiView: self)
//        webView.scalesPageToFit = true
        webView.scrollView.contentScaleFactor = 2.0
        webView.scrollView.contentMode = .scaleToFill
        webView.delegate = self
//        webView.isUserInteractionEnabled = false
        webView.allowsLinkPreview = true
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
extension ConnectCommentCell : UIWebViewDelegate  {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.hideActivityIndicator(uiView: self)
        //MARK:- TO update webview height after webpage is loaded
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        commentcellHeight.constant = webView.sizeThatFits(.zero).height + 40// 20 is  name label height
        performUIUpdatesOnMain{
            let commenstableview = self.superview as! UITableView
            commenstableview.beginUpdates()
            commenstableview.endUpdates()
            let superTableView : UITableView = {
                let detailedCalloutVC =  self.getParentViewController() as! DetailedCalloutViewController
                return detailedCalloutVC.tableView
            }()
            superTableView.beginUpdates()
            superTableView.endUpdates()
            superTableView.beginUpdates()
            superTableView.endUpdates()
        }
        
    }
    
}
