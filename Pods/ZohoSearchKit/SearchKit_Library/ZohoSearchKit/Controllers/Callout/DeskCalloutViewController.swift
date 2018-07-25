//
//  DeskCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/02/18.
//

import UIKit
import CoreData

class DeskCalloutViewController: BaseWebViewCalloutViewController {
    
    @IBOutlet weak var deskTitleLabel: UILabel!
    @IBOutlet weak var senderOrAuthorImageView: UIImageView!
    @IBOutlet weak var firstRowLabel: UILabel!
    @IBOutlet weak var firstRowValue: UILabel!
    @IBOutlet weak var secondRowLable: UILabel!
    @IBOutlet weak var secondRowValue: UILabel!
    @IBOutlet weak var creationTime: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //Request
    //From: Sender Name
    //Assigned To: Owner Name
    //Date, Status
    
    //Solution -
    //Created By: Author Name
    //Department: Department Name
    //Date, Solution status
    
    //for some background to the stackview
    @IBOutlet weak var metaDataStackView: UIStackView!
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SearchKitConstants.ColorConstants.CalloutMetaContainerBGColor
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    @IBOutlet weak var deskContentWebView: UIWebView!
    
    //must mark as private
    var deskCalloutDataTask: URLSessionDataTask?
    //let activityIndicator = ActivityIndicatorUtils()
    
    let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
    
    var calloutData: SupportResult? {
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
    
    static func vcInstanceFromStoryboard() -> DeskCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: DeskCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? DeskCalloutViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stackview background color
        pinBackground(backgroundView, to: metaDataStackView)
        
        //maximum number of lines for the subject field before it gets truncated.
        //allow the user of the SDK to customize, that's why it is better to use from the code. The same can be set in the Storyboard
        deskTitleLabel.numberOfLines = 3
        
        //deskContentWebView.scalesPageToFit = true
        deskContentWebView.backgroundColor = UIColor.white
        deskContentWebView.delegate = self
        
        //activityIndicator.showActivityIndicator(uiView: self.view)
        
        deskTitleLabel.text = calloutData?.title
        
        if calloutData?.moduleID == 1 {
            firstRowLabel.text = "From:"
            secondRowLable.text = "Assigned To:"
            firstRowValue.text = calloutData?.subtitle1
            secondRowValue.text = ""
        }
        else {
            //solution because only for these two modules callout request will come
            firstRowLabel.text = "Created By:"
            secondRowLable.text = "In Department:"
            
            firstRowValue.text = ""
            secondRowValue.text = ""
        }
        
        creationTime.text = DateUtils.getDisaplayableDate(timestamp: (calloutData?.createdTime)!)
        statusLabel.text = calloutData?.subtitle2 //status in both the cases
        
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
        //so that after failure of image loading also image will be circular
        imageView.maskCircle(anyImage: image)
        senderOrAuthorImageView.addSubview(imageView)
        
        let managedObjectContext = coreDataStack?.context
        
        var portalName = resultMetaData?.accountDisplayName
        
        if portalName == nil || portalName?.isEmpty == true {
            // Fetch List Records
            let lists = fetchRecordsForEntity(SearchKitConstants.CoreDataStackConstants.DeskPortalsTable, portalID: Int64((resultMetaData?.accountID)!)!, inManagedObjectContext: managedObjectContext!)
            
            if let listRecord = lists.first {
                //field name using keyPath/reflection instead of hardcoding it. We might rename in data model file, it will automatically reflect.
                //#keyPath(DeskPortals.portal_name)
                let portalNameAttribute = #keyPath(DeskPortals.portal_name)
                portalName = listRecord.value(forKey: portalNameAttribute) as? String
            }
        }
        
        //TODO: In case of all departments search department id will be returned as 0
        //so in that case we should find the department ids, From server itself we can send
        //department ids and make sure to correctly map result to department ids
        var departmentName = ""
        if let resultMeta = resultMetaData as? DeskResultsMetaData, resultMeta.departmentID != 0 {
            departmentName = resultMeta.departmentName
        }
        else {
            let deptLists = fetchDeskDepartmentsForEntity(SearchKitConstants.CoreDataStackConstants.DeskDepartmentsTable, portalID: (calloutData?.orgID)!, departmentID: (calloutData?.departmentID)!, inManagedObjectContext: managedObjectContext!)
            
            if let listRecord = deptLists.first {
                let deptNameAttribute = #keyPath(DeskDepartments.dept_name)
                departmentName = listRecord.value(forKey: deptNameAttribute) as! String
            }
        }
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                self.deskCalloutDataTask = ZOSSearchAPIClient.sharedInstance().getDeskCallout(oAuthToken: oAuthToken, portalName: portalName!, portalID: (self.calloutData?.orgID)!, departmentName: departmentName, entityID: Int64((self.calloutData?.entityID)!)!, moduleID: (self.calloutData?.moduleID)!, mode: self.calloutData?.mode, clickPosition: 0)
                { (calloutDataResp, error) in
                    
                    self.deskCalloutDataTask = nil
                    
                    if let calloutDataResp = calloutDataResp {
                        if self.calloutData?.moduleID == 1 {
                            //for request this is the key
                            if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ActualContent] as? String {
                                performUIUpdatesOnMain {
                                    self.deskContentWebView.loadHTMLString(content, baseURL: nil)
                                }
                            }
                            
                            if let resp = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Result] as? [String: AnyObject] {
                                if let owner = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.CaseOwner] as? String {
                                    performUIUpdatesOnMain {
                                        self.secondRowValue.text = owner
                                    }
                                }
                            }
                        }
                        
                        if self.calloutData?.moduleID == 2 {
                            //for solution this is the key
                            if let resp = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Result] as? [String: AnyObject] {
                                if let content = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Answer] as? String {
                                    performUIUpdatesOnMain {
                                        self.deskContentWebView.loadHTMLString(content, baseURL: nil)
                                    }
                                }
                                
                                if let createdBy = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.CreatedBy] as? String {
                                    performUIUpdatesOnMain {
                                        self.firstRowValue.text = createdBy
                                    }
                                }
                                
                                if let department = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.DepartmentName] as? String {
                                    performUIUpdatesOnMain {
                                        self.secondRowValue.text = department
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        })
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        SearchResultsViewModel.searchWhenLoaded = false
    //    }
    
    private func fetchRecordsForEntity(_ entity: String, portalID: Int64, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let portalPredicate = NSPredicate(format: #keyPath(DeskPortals.portal_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, portalID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.predicate = portalPredicate
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            SearchKitLogger.errorLog(message: "Unable to fetch managed objects for entity \(entity).", filePath: #file, lineNumber: #line, funcName: #function)
            
        }
        
        return result
    }
    
    private func fetchDeskDepartmentsForEntity(_ entity: String, portalID: Int64, departmentID: Int64, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Create Fetch Request
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let portalPredicate = NSPredicate(format: #keyPath(DeskDepartments.portal_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt + " AND " + #keyPath(DeskDepartments.dept_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, argumentArray: [portalID, departmentID])
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.predicate = portalPredicate
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            
            SearchKitLogger.errorLog(message: "Unable to fetch managed objects for entity \(entity).", filePath: #file, lineNumber: #line, funcName: #function)
            
        }
        
        return result
    }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        super.handleBackPress()
    }
    
    @IBAction func didPressOpenInApp(_ sender: UIButton) {
        ZohoAppsDeepLinkUtil.openInDeskApp(moduleName: (calloutData?.getModuleName())!, entityID: (calloutData?.entID)!, portalID: (calloutData?.orgID)!)
    }
    
    //stackview container background color
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
}

//super class already extends from the UIWebViewDelegate
extension DeskCalloutViewController {
    //Retry logic will be handled in respective callout view controller, not in base
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //indicatorView.stopAnimating()
        super.activityIndicator.hideActivityIndicator(uiView: self.view)
    }
}

