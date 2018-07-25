//
//  DetailedCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 14/05/18.
//

import Foundation


import UIKit

extension NSNotification.Name{
    static let reloadCalloutVC = Notification.Name("reloadCalloutVC")
}
class DetailedCalloutViewController: BaseWebViewCalloutViewController {
    
    @IBOutlet weak var errorMessageContainerView: UIView!
    @IBOutlet weak var mailSubjectContainerView: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mailSubject: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    fileprivate var contentHeights : [Int : CGFloat] = [1 : 0.0]
    var searchResult : SearchResult?
    var calloutVCData : CalloutVCData?
    {
        didSet{
            guard let _ = self.calloutVCData else {
                return
            }
        }
    }
    var serviceName = String()
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    //stackview can not have some background color as it is layout view not a real view
    //Meta container stack view background color
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchKitConstants.ColorConstants.CalloutMetaContainerBGColor
        view.layer.cornerRadius = 6.0
        return view
    }()
    static func vcInstanceFromStoryboard() -> DetailedCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: DetailedCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? DetailedCalloutViewController
    }
    @objc  func reloadTableView(notification: NSNotification)
    {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //TO reload TableView because when we do token callback it takes some delay during generation of calloutVCData(),so callback data will be  nil.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(notification:)), name: .reloadCalloutVC, object: nil)
        self.mailSubject.text = calloutVCData?.subject
        tableView.allowsSelection = false
        separator1.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        separator2.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        tableView.separatorInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.register(CalloutVCMetaDataCell.nib, forCellReuseIdentifier: CalloutVCMetaDataCell.identifier)
            tableView.register(newMailCalloutMetaDataCell.nib, forCellReuseIdentifier: newMailCalloutMetaDataCell.identifier)
        tableView.register(CalloutWebViewCell.nib, forCellReuseIdentifier: CalloutWebViewCell.identifier)
        tableView.register(AttachmentsTableViewCell.nib, forCellReuseIdentifier: AttachmentsTableViewCell.identifier)
        tableView.register(ConnectCommentsTableViewCell.nib, forCellReuseIdentifier: ConnectCommentsTableViewCell.identifier)
        //        //stackview background color
        //        pinBackground(backgroundView, to: metaDataContainerSV)
        //maximum number of lines for the subject field before it gets truncated.
        //allow the user of the SDK to customize, that's why it is better to use from the code. The same can be set in the Storyboard
        mailSubject.numberOfLines = 3
        mailSubject.superview?.backgroundColor = SearchKitConstants.ColorConstants.CalloutVC_HeaderView_BackgroundColor
        mailSubject.layer.cornerRadius = 6
        mailSubject.clipsToBounds = true
        errorMessage.isHidden = true
        retryButton.isHidden = true
        retryButton.isEnabled = true
        //this will cause subsequent request to use even the Application requests
        //CustomURLProtocol.enable()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction func didPressBack(_ sender: UIButton) {
        super.handleBackPress()
    }
    @IBAction func didPressRetry(_ sender: UIButton) {
        SearchKitLogger.warningLog(message: "Retry loading the web view", filePath: #file, lineNumber: #line, funcName: #function)
    }
    //stackview container background color
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    @objc  func moreButtonPressed(sender : UINavigationItem)
    {
        OpenServiceWithNativeApp.sharedInstance().selectedResultCellServiceName = serviceName
        OpenServiceWithNativeApp.sharedInstance().selectedServiceResult = self.searchResult
        OpenServiceWithNativeApp.sharedInstance().didPressMoreActionsOption(sender, currentViewcontroller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let rightButtonItem = UIBarButtonItem.init(
            title: nil,
            style: .done,
            target: self,
            action: #selector(moreButtonPressed)
        )
        rightButtonItem.image = UIImage(named: "searchsdk-more", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
}
//super class already extends from the UIWebViewDelegate
extension DetailedCalloutViewController : UIScrollViewDelegate  {
    //Retry logic will be handled in respective callout view controller, not in base
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //indicatorView.stopAnimating()
        activityIndicator.hideActivityIndicator(uiView: self.view)
        errorMessage.text = "Failed to load the Mail Content"
        errorMessage.isHidden = false
        retryButton.isHidden = false
        retryButton.isEnabled = true
    }
    //but only first request is intercepted
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .other {
            
        }
        return true
    }
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        
        //loading css
//        do {
//            //guard let path = Bundle.main.path(forResource: "styles", ofType: "css") else { return }
//            let path = ZohoSearchKit.frameworkBundle.path(forResource: "callout", ofType: "css")
//            let cssContent = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue);
//            let javaScrStr = "var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)"
//            let JavaScrWithCSS = NSString(format: javaScrStr as NSString, cssContent)
//            webView.stringByEvaluatingJavaScript(from: JavaScrWithCSS as String)
//            
//        }
//        catch let error as NSError {
//            print(error);
//        }
        
        //MARK:- TO update webview height after webpage is loaded
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        let webViewThresholdHeight = self.tableView.frame.height - contentHeights[0]!
        if webViewThresholdHeight > webView.sizeThatFits(.zero).height && self.tableView(self.tableView, numberOfRowsInSection: 0) <= 2
        {
            contentHeights[webView.tag] = webViewThresholdHeight
            webView.frame.size.height = webViewThresholdHeight
        }
        else
        {
            contentHeights[webView.tag] = webView.sizeThatFits(.zero).height + 20
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension DetailedCalloutViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 2 // 1 cell for meta data and 1 for webView
        if calloutVCData?.hasAttachment == true
        {
            count = count + 1  // +1 for attachments
        }
        if let comments =  calloutVCData?.connectComments , comments.isEmpty == false
        {
            count = count + 1 // +1 for comments
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 //MetaData Cell
        {
            if self.calloutVCData?.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: newMailCalloutMetaDataCell.identifier) as! newMailCalloutMetaDataCell
                cell.calloutMetaData = calloutVCData?.metaData
                contentHeights[indexPath.row] = cell.frame.height
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CalloutVCMetaDataCell.identifier) as! CalloutVCMetaDataCell
                cell.calloutMetaData = calloutVCData?.metaData
                contentHeights[indexPath.row] = cell.frame.height
                return cell
            }
            
        }
        else if indexPath.row == 1 // WebView cell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CalloutWebViewCell.identifier) as! CalloutWebViewCell
            cell.CalloutWebView.loadHTMLString((self.calloutVCData?.finalContent)!, baseURL: nil)
//            cell.CalloutWebView.scalesPageToFit = true
//            cell.CalloutWebView.scrollView.isScrollEnabled = false
            cell.CalloutWebView.scrollView.isScrollEnabled = false
            cell.CalloutWebView.tag = indexPath.row
            cell.CalloutWebView.allowsLinkPreview = true
            cell.CalloutWebView.delegate = self
            //MARK:- TO hide the black line in Webview
            cell.CalloutWebView.isOpaque = false
            cell.CalloutWebView.backgroundColor = .clear
            return cell
        }
        else if indexPath.row == 2// attachments Cell
        {
            if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect //if connect may be ( att or comments)
            {
                if let _ = calloutVCData?.hasAttachment ,self.calloutVCData?.attachedFilesData.isEmpty == false
                {
                    AttachmentsTableViewCell.attachedFiles = (self.calloutVCData?.attachedFilesData)!
                    let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.identifier) as! AttachmentsTableViewCell
                    return cell
                }
                else if  let _ = self.calloutVCData?.connectComments, self.calloutVCData?.connectComments.isEmpty == false// If there is no att in connect post row to will be commects
                {
                    ConnectCommentsTableViewCell.commentsData = (self.calloutVCData?.connectComments)!
                    let cell = tableView.dequeueReusableCell(withIdentifier: ConnectCommentsTableViewCell.identifier) as! ConnectCommentsTableViewCell
                    return cell
                }
                else
                {
                    return UITableViewCell()
                }
            }
           else if  self.calloutVCData?.attachedFilesData.isEmpty == false
            {
                AttachmentsTableViewCell.attachedFiles = (self.calloutVCData?.attachedFilesData)!
                let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.identifier) as! AttachmentsTableViewCell
                return cell
            }
            else
            {
                return UITableViewCell()
            }
        }
        else //if indexPath.row == 3 // connect comments
        {
            if  self.calloutVCData?.connectComments.isEmpty == false
            {
                ConnectCommentsTableViewCell.commentsData = (self.calloutVCData?.connectComments)!
                let cell = tableView.dequeueReusableCell(withIdentifier: ConnectCommentsTableViewCell.identifier) as! ConnectCommentsTableViewCell
                return cell
            }
            else
            {
                return UITableViewCell()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 
        {
            return contentHeights[indexPath.row]! + 20
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
