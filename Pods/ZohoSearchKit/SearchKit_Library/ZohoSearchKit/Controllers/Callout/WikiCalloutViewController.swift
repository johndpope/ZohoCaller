//
//  WikiCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/02/18.
//

import UIKit

class WikiCalloutViewController: BaseWebViewCalloutViewController {
    
    @IBOutlet weak var wikiNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorNameValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var metaDataStackView: UIStackView!
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchKitConstants.ColorConstants.CalloutMetaContainerBGColor
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    @IBOutlet weak var wikiContentWebView: UIWebView!
    
    //must mark as private
    var wikiCalloutDataTask: URLSessionDataTask?
    
    var calloutData: WikiResult? {
        didSet {
            guard let _ = calloutData else {
                return
            }
        }
    }
    
    static func vcInstanceFromStoryboard() -> WikiCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: WikiCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? WikiCalloutViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stackview background color
        pinBackground(backgroundView, to: metaDataStackView)
        
        //maximum number of lines for the subject field before it gets truncated.
        //allow the user of the SDK to customize, that's why it is better to use from the code. The same can be set in the Storyboard
        wikiNameLabel.numberOfLines = 3
        
        //will be readable if commented, otherwise it will be zoomed out and will be readability issue
        wikiContentWebView.scalesPageToFit = true
        wikiContentWebView.backgroundColor = UIColor.white
        wikiContentWebView.delegate = self
        
        wikiNameLabel.text = calloutData?.wikiName
        authorNameValueLabel.text = calloutData?.wikiAuthor
        timeValueLabel.text = DateUtils.getDisaplayableDate(timestamp: (calloutData?.lastModifiedTime)!)
        
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
        //so that after failure of image loading also image will be circular
        imageView.maskCircle(anyImage: image)
        authorImageView.addSubview(imageView)
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                self.wikiCalloutDataTask = ZOSSearchAPIClient.sharedInstance().getWikiCallout(oAuthToken: oAuthToken, docID: (self.calloutData?.wikiDocID)!, wikiID: (self.calloutData?.wikiID)!, wikiCatID: (self.calloutData?.wilkiCatID)!, wikiType: (self.calloutData?.wikiType)!, clickPosition: 0)
                { (calloutDataResp, error) in
                    
                    self.wikiCalloutDataTask = nil
                    
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ActualContent] as? String {
                            performUIUpdatesOnMain {
                                self.wikiContentWebView.loadHTMLString(content, baseURL: nil)
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
extension WikiCalloutViewController {
    //Retry logic will be handled in respective callout view controller, not in base
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //indicatorView.stopAnimating()
        super.activityIndicator.hideActivityIndicator(uiView: self.view)
    }
}
