//
//  MailCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/02/18.
//

import UIKit
import CoreData

class MailCalloutViewController: BaseWebViewCalloutViewController {
    
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mailSubject: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    fileprivate var toValueAddreses  = [String]()
    fileprivate var ccAdresses = [String]()
    fileprivate var messageTime = String()
//    fileprivate var metaDataContainerSV: UIStackView = UIStackView()
    fileprivate    var finalContent = ""
    fileprivate var mailCalloutDataTask: URLSessionDataTask?
    fileprivate  var attachedFilesData = [AttachmentData]()
    fileprivate var contentHeights : [Int : CGFloat] = [1 : 0.0]
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    //stackview can not have some background color as it is layout view not a real view
    //Meta container stack view background color
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchKitConstants.ColorConstants.CalloutMetaContainerBGColor
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    var calloutData: MailResult? {
        didSet {
            guard let _ = calloutData else {
                return
            }
        }
    }
    
    static func vcInstanceFromStoryboard() -> MailCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: MailCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? MailCalloutViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        separator1.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        separator2.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.register(MailCalloutMetaDataTableViewCell.nib, forCellReuseIdentifier: MailCalloutMetaDataTableViewCell.identifier)
        tableView.register(CalloutWebViewCell.nib, forCellReuseIdentifier: CalloutWebViewCell.identifier)
        tableView.register(AttachmentsTableViewCell.nib, forCellReuseIdentifier: AttachmentsTableViewCell.identifier)
        //        //stackview background color
//        pinBackground(backgroundView, to: metaDataContainerSV)
        //maximum number of lines for the subject field before it gets truncated.
        //allow the user of the SDK to customize, that's why it is better to use from the code. The same can be set in the Storyboard
        mailSubject.numberOfLines = 3
        mailSubject.superview?.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        mailSubject.layer.cornerRadius = 6
        mailSubject.clipsToBounds = true
        errorMessage.isHidden = true
        retryButton.isHidden = true
        retryButton.isEnabled = true
        //this will cause subsequent request to use even the Application requests
        //CustomURLProtocol.enable()
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                self.mailCalloutDataTask = ZOSSearchAPIClient.sharedInstance().getMailCallout(oAuthToken: oAuthToken, msgID: (self.calloutData?.messageID)!, acntID: (self.calloutData?.accountID)!, clickPosition: 0) { (calloutDataResp, error) in
                    self.mailCalloutDataTask = nil
                    
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.MailContent] as? String {
                            performUIUpdatesOnMain {
                                //let finalContent = "<html><head><title>" + (self.calloutData?.subject)! + "</title><meta name=\"viewport\" content=\"width=320\"/></head><body>" + content + "</body></html>";
                                //                                var finalContent = ""
                                
                                /*
                                 finalContent = finalContent + "<!DOCTYPE html>"
                                 finalContent = finalContent + "<html>"
                                 finalContent = finalContent + "<head id=\"headId\">"
                                 finalContent = finalContent + "<meta name=\"viewport\" content=\"user-scalable=yes, width=1, initial-scale=1\">"
                                 finalContent = finalContent + "<meta http-equiv=\"Content-Type\" content=\"text/html charset=utf-8\">"
                                 finalContent = finalContent + "<style type=\"text/css\">"
                                 finalContent = finalContent + "</style>"
                                 finalContent = finalContent + "</head>"
                                 //play with margin and all
                                 finalContent = finalContent + "<body style='visibility: visible; display: block; direction: ltr; position: relative; margin: 8; padding: 8;'>"
                                 finalContent = finalContent + "<div id='mailcontentid'"
                                 finalContent = finalContent + "style='display: block; position: relative; background-color: white; padding: 8px; marign-top: 1px'"
                                 finalContent = finalContent + "class=\"content\">" + content + "</div>"
                                 finalContent = finalContent + "<div id=\"blockcontent\""
                                 finalContent = finalContent + "style='display: block;'>"
                                 finalContent = finalContent + "</div>"
                                 finalContent = finalContent + "</br>"
                                 finalContent = finalContent + "</body>"
                                 finalContent = finalContent + "</html>"
                                 */
                                
                                self.finalContent = self.finalContent + content
                                self.self.finalContent = self.finalContent.replacingOccurrences(of: "ImageDisplay", with: "ImageDisplayForMobile")
                                
                                //                                self.mailContentWebView.loadHTMLString(self.finalContent, baseURL: nil)
                                
                                
                            }
                        }
                        if let to = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.ToField] as? String {
                            performUIUpdatesOnMain {
                                let tovalues = to.decodedHTMLEntities()
                                
                                self.toValueAddreses = self.SplitStringintoArray(str: tovalues)
                            }
                        }
                        
                        if let milliSec = self.calloutData?.receivedTime {
                            performUIUpdatesOnMain {
                                let date = Date(milliseconds: milliSec)
                                let dateformate = DateFormatter()
                                if date.day == Date().day
                                {
                                    dateformate.timeStyle = .short
                                    self.messageTime =  dateformate.string(from: date)
                                }
                                else
                                {
                                    dateformate.dateFormat = "dd MMM"
                                    self.messageTime =  dateformate.string(from: date)
                                }
                            }
                        }
                        if let cCValue = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.CC] as? String {
                            performUIUpdatesOnMain {
                                let ccValues = cCValue.decodedHTMLEntities()
                                self.ccAdresses = self.SplitStringintoArray(str: ccValues)
                            }
                        }
                        if let attachments  = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.AttachmentInfo] as? [[String: String]] {
                            for attach in attachments
                            {
                                let attData = AttachmentData()
                                for key in attach.keys
                                {
                                    switch key{
                                    case "n":
                                        attData.name = attach[key]!
                                        let type = attData.name.components(separatedBy: ".").last!
                                        switch type{
                                        case "png","PNG","jpeg","gif":
                                            attData.type = .pictures
                                        case "pdf":
                                            attData.type = .pdf
                                        case "zip","Zip":
                                            attData.type = .zip
                                        case "docx","doc":
                                            attData.type = .documents
                                        case "txt":
                                            attData.type = .text
                                        case "mp3":
                                            attData.type = .musics
                                        case ".mp4":
                                            attData.type = .videos
                                        case "ppt":
                                            attData.type = .presentations
                                        case "xlsx":
                                            attData.type = .spreadSheets
                                        default:
                                            attData.type = .others
                                        }
                                    case "i":
                                        attData.index = Int(attach[key]!)!
                                    case "s":
                                        attData.size = attach[key]!
                                    default:
                                        break
                                    }
                                }
                                // creating file URL parameters
                                var parameters = [String: AnyObject]()
                                parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Mail as AnyObject
                                parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.MessageID] = self.calloutData?.messageID as AnyObject
                                parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountID] = self.calloutData?.accountID as AnyObject
                                parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountType] = "1" as AnyObject
                                parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.attName] = attData.name as AnyObject
                                parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.attIndex] = attData.index as AnyObject
                                attData.attURLParameters = parameters
                                self.attachedFilesData.append(attData)
                            }
                        }
                        //MARK:- should reload the tableview ,because of token call back
                        performUIUpdatesOnMain {
                            self.tableView.reloadSections([0], with: .none)
                        }
                    }
                }
            }
            else {
                //add error subview to the webview and show error message and
                //if possible a way to retry loading the callout - retry
            }
        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func SplitStringintoArray(str : String) -> [String]
    {
        var toArray  = str.components(separatedBy: ",")
        
        for (i,toAddr) in toArray.enumerated()
        {
            toArray[i] = toAddr.components(separatedBy: "\"").last!
            toArray[i] = toArray[i].trimmingCharacters(in: .whitespaces)
            let trimkey1 = CharacterSet.init(charactersIn: "<")
            let trimkey2 = CharacterSet.init(charactersIn: ">")
            toArray[i] = toArray[i].trimmingCharacters(in: trimkey1)
            toArray[i] = toArray[i].trimmingCharacters(in: trimkey2)
        }
        return toArray
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
}
//super class already extends from the UIWebViewDelegate
extension MailCalloutViewController : UIScrollViewDelegate  {
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
        //MARK:- TO update webview height after webpage is loaded
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        let webViewThresholdHeight = self.tableView.frame.height - contentHeights[0]!
        if webViewThresholdHeight > webView.sizeThatFits(.zero).height
        {
            contentHeights[webView.tag] = webViewThresholdHeight
            webView.frame.size.height = webViewThresholdHeight
        }
        else
        {
            contentHeights[webView.tag] = webView.sizeThatFits(.zero).height
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension MailCalloutViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if calloutData?.hasAttachments == true
        {
            return 3 // 1 cell for meta data and 1 for webView , 1 for attachments
        }
        else
        {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: MailCalloutMetaDataTableViewCell.identifier) as! MailCalloutMetaDataTableViewCell
            mailSubject.text = calloutData?.subject
            cell.LoadImageForMailID = calloutData?.fromAddress
            cell.fromValueLabel.text = calloutData?.fromAddress
            cell.toAddreses = self.toValueAddreses
            cell.ccAddress = self.ccAdresses
            cell.folderNameLabel.text = calloutData?.folderName
            cell.messageTime.text = messageTime
            contentHeights[indexPath.row] = cell.frame.height
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CalloutWebViewCell.identifier) as! CalloutWebViewCell
            
            cell.CalloutWebView.loadHTMLString(finalContent, baseURL: nil)
            cell.CalloutWebView.scalesPageToFit = true
            cell.CalloutWebView.scrollView.isScrollEnabled = false
            cell.CalloutWebView.tag = indexPath.row
            cell.CalloutWebView.allowsLinkPreview = true
            cell.CalloutWebView.delegate = self
            //MARK:- TO hide the black line in Webview
            cell.CalloutWebView.isOpaque = false
            cell.CalloutWebView.backgroundColor = .clear
            return cell
        }
        else
        {
            if  self.attachedFilesData.isEmpty == false
            {
                AttachmentsTableViewCell.attachedFiles = self.attachedFilesData
                let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentsTableViewCell.identifier) as! AttachmentsTableViewCell
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
        return 100
    }
}
