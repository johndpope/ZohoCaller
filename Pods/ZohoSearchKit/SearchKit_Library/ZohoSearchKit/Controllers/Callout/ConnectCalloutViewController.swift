//
//  ConnectCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 25/04/18.
//

import UIKit

class ConnectCalloutViewController: BaseWebViewCalloutViewController {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postedInLabel: UILabel!
    @IBOutlet weak var postedInName: UILabel!
    @IBOutlet weak var metaDataStackView: UIStackView!
    @IBOutlet weak var connectContentWebView: UIWebView!
    @IBOutlet weak var postedInStackView: UIStackView!
    
    //must mark as private
    var connectCalloutDataTask: URLSessionDataTask?
    
    var calloutData: ConnectResult? {
        didSet {
            guard let _ = calloutData else {
                return
            }
        }
    }
    
    var resultMetaData: SearchResultsMetaData? {
        didSet {
            guard let _ = resultMetaData else {
                return
            }
        }
    }
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchKitConstants.ColorConstants.CalloutMetaContainerBGColor
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    static func vcInstanceFromStoryboard() -> ConnectCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: ConnectCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? ConnectCalloutViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var postTypeStr: String?
        if calloutData?.type == ConnectResult.ResultType.Feeds {
            if let postedIn = calloutData?.postedIn, postedIn.isEmpty == false {
                postedInStackView.isHidden = false
            }
        }
        else {
            postedInStackView.isHidden = true
            postTypeStr = "FORUMS"
        }
        
        //stackview background color
        pinBackground(backgroundView, to: metaDataStackView)
        
        //will be readable if commented, otherwise it will be zoomed out and will be readability issue
        connectContentWebView.scalesPageToFit = true
        connectContentWebView.backgroundColor = UIColor.white
        connectContentWebView.delegate = self
        
        postTitle.numberOfLines = 3
        postTitle.text = calloutData?.postTitle
        
        authorName.text = calloutData?.authorName
        postTime.text = DateUtils.getDisaplayableDate(timestamp: (calloutData?.postTime)!)
        
        postedInName.text = calloutData?.postedIn
        
        //set author image
        if (calloutData?.authorZUID == -1) {
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            self.authorImageView.maskCircle(anyImage: image)
        }
        else {
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            authorImageView.addSubview(imageView)
            
            //animate the image loading icon
            var loadImages: [UIImage] = []
            loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
            imageView.animate(images: loadImages)
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                //ZSSOKit.getOAuth2Token({ (token, error) in
                if let oAuthToken = token {
                    let _ = ZOSSearchAPIClient.sharedInstance().getContactImage((self.calloutData?.authorZUID)!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                        if image == nil {
                            //Only UI update need to be done on main thread. This is just loading the image from asset
                            let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                            performUIUpdatesOnMain {
                                imageView.stopAnimate()
                                imageView.image = defImage
                                self.authorImageView.maskCircle(anyImage: defImage)
                            }
                        }
                        else {
                            performUIUpdatesOnMain {
                                //stop the loading image animation
                                imageView.stopAnimate()
                                //set new downloaded image to the image view withing above created border
                                imageView.image = image
                                self.authorImageView.maskCircle(anyImage: image!)
                            }
                        }
                    })
                }
            })
        }
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                //not used so added dummy value for click position
                self.connectCalloutDataTask = ZOSSearchAPIClient.sharedInstance().getConnectCallout(oAuthToken: oAuthToken, postID: (self.calloutData?.postID)!, networkID: Int64((self.resultMetaData?.accountID)!)!, postType: postTypeStr, clickPosition: 0)
                { (calloutDataResp, error) in
                    
                    self.connectCalloutDataTask = nil
                    
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.Content] as? String {
                            performUIUpdatesOnMain {
                                self.connectContentWebView.loadHTMLString(content, baseURL: nil)
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        super.handleBackPress()
    }
    
    //stackview container background color
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
}

//super class already extends from the UIWebViewDelegate
extension ConnectCalloutViewController {
    //Retry logic will be handled in respective callout view controller, not in base
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //indicatorView.stopAnimating()
        super.activityIndicator.hideActivityIndicator(uiView: self.view)
    }
}
