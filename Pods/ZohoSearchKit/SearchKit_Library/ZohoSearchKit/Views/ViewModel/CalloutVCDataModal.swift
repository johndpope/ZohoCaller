//
//  CalloutVCDataModal.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 16/05/18.
//

import Foundation
import CoreData

class CalloutMetaData {
    var serviceName : String = ""
    var photoFromMailId: String? = nil
    var photoFromZuID : Int64? = nil
}
class MailCalloutMetaData: CalloutMetaData {
    override init() {
        super.init()
          serviceName = ZOSSearchAPIClient.ServiceNameConstants.Mail
    }
  
    var fromLabelName: String? = nil
    var fromValue: String? = nil
    
    var toLabelName: String? = nil
    var toValue: String? = nil
    
    var dateValue: String? = nil
    var folderValue: String? = nil

    var moreDetail_fromLabelName: String? = nil
    var moreDetail_fromValue: String? = nil
    
    var moreDetail_toLabelName: String? = nil
    var moreDetail_toValue: String? = nil
    
    var moreDetail_CcLabelName: String? = nil
    var moreDetail_CcValue: String? = nil
    
    var moreDetail_BccLabelName: String? = nil
    var moreDetail_BccValue: String? = nil
    
    var moreDetail_Date: String? = nil
    var moreDetail_DateValue: String? = nil
    
    var moreDetail_Folder: String? = nil
    var moreDetail_FolderValue: String? = nil
}
class ConnectCalloutMetaData: CalloutMetaData {
    override init() {
        super.init()
        serviceName = ZOSSearchAPIClient.ServiceNameConstants.Connect
    }
    var postByLabelName: String? = nil
    var postByValue: String? = nil
    
    var dateValue: String? = nil
    
    var postedInLabelName : String?
    var postedIn: String? = nil
}
class DeskCalloutMetaData: CalloutMetaData {
    override init() {
        super.init()
        serviceName = ZOSSearchAPIClient.ServiceNameConstants.Desk
    }
    var fromLabelName: String? = nil
    var fromValue: String? = nil

    var assignedToLabelName: String? = nil
    var assignedToValue: String? = nil
    
    var statusValue : String? = nil
    var dateValue : String? = nil
    
}
class WikiCalloutMetaData: CalloutMetaData {
    override init() {
        super.init()
        serviceName = ZOSSearchAPIClient.ServiceNameConstants.Wiki
    }
    var createdByLabelName: String? = nil
    var createdByValue: String? = nil
    var dateValue: String? = nil
    var postedInLabelName : String?
    var postedIn: String? = nil
}


class CalloutVCData{
    var subject : String?
    var serviceName = String()
    var metaData  = CalloutMetaData()
    var hasAttachment  : Bool?
    var finalContent  = String()
    var attachedFilesData = [AttachmentData]()
    var connectComments = [ConnectCommentData]()
    let dayMonthFormate = "dd MMM"
    let dayMonthYearFormate = "dd MMM YYYY"
    var  indexPath = IndexPath()
    init(indexPath : IndexPath ,resultMetaData : SearchResultsMetaData?,servicename : String)
    {
        self.indexPath = indexPath
        self.serviceName = servicename
       
        if resultMetaData != nil
        {
            self.resultMetaData = resultMetaData
        }
        switch servicename
        {
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
         
            setUpMailCallout()
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            setUpConnectCallout()
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            setUpDeskCallout()
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            setUpWikiCallout()
        default:
            break
        }
    }
    var resultMetaData: SearchResultsMetaData?
    func setUpMailCallout()
    {
        let mailMetaData = MailCalloutMetaData()
        let item = SearchResultsViewModel.serviceSections[serviceName]!
        let calloutData = item.searchResults[indexPath.row] as! MailResult
        mailMetaData.fromLabelName = "from "
        mailMetaData.fromValue = calloutData.fromAddress
        
        mailMetaData.toLabelName = "to "
        mailMetaData.moreDetail_CcLabelName = "Cc "
        mailMetaData.moreDetail_BccLabelName = "Bcc "
        mailMetaData.moreDetail_fromLabelName = "From "
        mailMetaData.moreDetail_toLabelName = "To "
        mailMetaData.moreDetail_fromValue = calloutData.fromAddress
        
        
        
        mailMetaData.dateValue = self.convertMillisecTODate(milliSec: calloutData.receivedTime, dateFormate: self.dayMonthFormate)
        mailMetaData.folderValue = calloutData.folderName
        
        mailMetaData.photoFromMailId = calloutData.fromAddress
        
        self.subject = calloutData.subject
        self.hasAttachment = calloutData.hasAttachments
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                _ = ZOSSearchAPIClient.sharedInstance().getMailCallout(oAuthToken: oAuthToken, msgID: (calloutData.messageID), acntID: (calloutData.accountID), clickPosition: self.indexPath.row) { (calloutDataResp, error) in
                    //                    mailCalloutDataTask = nil
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.MailContent] as? String {
                            performUIUpdatesOnMain {
                                self.finalContent = self.finalContent + content
                                self.finalContent = self.finalContent.replacingOccurrences(of: "ImageDisplay", with: "ImageDisplayForMobile")
                            }
                        }
                        
                        if let to = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.ToField] as? String {
                            performUIUpdatesOnMain {
                                let tovalues = to.decodedHTMLEntities()
                                mailMetaData.toValue = self.formStringfrom(array: self.SplitStringintoArray(str: tovalues))
                                mailMetaData.moreDetail_toValue = self.formStringfrom(array: self.SplitStringintoArray(str: tovalues))
//                                self.toaddress = self.SplitStringintoArray(str: tovalues)
                            }
                        }
                        
                        if let cCValue = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.CC] as? String {
                            performUIUpdatesOnMain {
                                let ccValues = cCValue.decodedHTMLEntities()
                                mailMetaData.moreDetail_CcValue = self.formStringfrom(array: self.SplitStringintoArray(str: ccValues))
//                                self.ccAddress = self.SplitStringintoArray(str: ccValues)
                            }
                        }
                        if let BccValue = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.BCC] as? String {
                            performUIUpdatesOnMain {
                                let BccValues = BccValue.decodedHTMLEntities()
                                mailMetaData.moreDetail_BccValue = self.formStringfrom(array: self.SplitStringintoArray(str: BccValues))
                                
                            }
                        }
                        if let attachments  = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.AttachmentInfo] as? [[String: String]] {
                            performUIUpdatesOnMain {
                                self.attachedFilesData = self.createAttachmentFiles(attachments: attachments, msgID: calloutData.messageID, accID: calloutData.accountID)
                            }
                        }
                        //reloading callout VC after we get data from server request
                        NotificationCenter.default.post(name: .reloadCalloutVC, object: nil)
                    }
                }
                
            } // callout data request
            else {
                //add error subview to the webview and show error message and
                //if possible a way to retry loading the callout - retry
            }
            
        })
        
        self.metaData = mailMetaData
    }
    
    func setUpConnectCallout()
    {
        let item = SearchResultsViewModel.serviceSections[serviceName]!
        let calloutData = item.searchResults[indexPath.row] as! ConnectResult
        self.subject = calloutData.postTitle
        let connectMetaData =  ConnectCalloutMetaData()
        
        connectMetaData.photoFromZuID = calloutData.authorZUID
        connectMetaData.postedInLabelName = "Posted In"
        connectMetaData.postByLabelName =  "Posted By :"
        connectMetaData.postByValue =  calloutData.authorName
        connectMetaData.dateValue = convertMillisecTODate(milliSec: calloutData.postTime, dateFormate: self.dayMonthFormate)
        connectMetaData.postedInLabelName = "In :"
        connectMetaData.postedIn = calloutData.postedIn

        self.hasAttachment = calloutData.hasAttachments
        var postTypeStr: String?
        if calloutData.type == ConnectResult.ResultType.Feeds
        {
            if let postedIn = calloutData.postedIn, postedIn.isEmpty == false
            {
                connectMetaData.postedIn = calloutData.postedIn
            }
            else
            {
                connectMetaData.postedIn = nil
            }
        }
        else {
            connectMetaData.postedIn = nil
            postTypeStr = "FORUMS"
        }
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                _ = ZOSSearchAPIClient.sharedInstance().getConnectCallout(oAuthToken: oAuthToken, postID: (calloutData.postID), networkID: Int64((self.resultMetaData?.accountID)!)!, postType: postTypeStr, clickPosition: self.indexPath.row)
                { (calloutDataResp, error) in
                    
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.Content] as? String {
                            self.finalContent = content
                            
                        }
                        if let attachments  = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.Attachments] as? [[String: String]] ,attachments.isEmpty == false{
                            performUIUpdatesOnMain {
                                let files = self.createAttachmentFiles(attachments: attachments, msgID: calloutData.postID, accID: Int64((self.resultMetaData?.accountID)!)!)
                                self.attachedFilesData.append(contentsOf: files)
                            }
                        }
                        if let images  = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.Images] as? [[String: String]] ,images.isEmpty == false{
                            performUIUpdatesOnMain {
                                let imgFiles = self.createAttachmentFiles(attachments: images, msgID: calloutData.postID, accID: Int64((self.resultMetaData?.accountID)!)!)
                                self.hasAttachment = true
                                self.attachedFilesData.append(contentsOf: imgFiles)
                            }
                        }
                        if let comments = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.Comments] as? [[String: String]] ,comments.isEmpty == false{
                            performUIUpdatesOnMain {
                                
                                self.connectComments = self.createCommentsDataModal(comments: comments)
                            }
                        }
                        
                        //reloading callout VC after we get data from server request
                        NotificationCenter.default.post(name: .reloadCalloutVC, object: nil)
                    }
                }
            }
        })
        
        self.metaData = connectMetaData
    }
    func setUpDeskCallout()
    {
        let item = SearchResultsViewModel.serviceSections[serviceName]!
        let calloutData = item.searchResults[indexPath.row] as! SupportResult

        let deskMetaData = DeskCalloutMetaData()
        if calloutData.moduleID == 1
        {
            deskMetaData.fromLabelName = "From :"
            
            deskMetaData.assignedToLabelName = "Assigned To :"

        }
        else
        {
            deskMetaData.fromLabelName = "Created By :"
            deskMetaData.assignedToLabelName = "In Department : "

        }
        deskMetaData.fromValue = calloutData.subtitle1 // created by
        deskMetaData.dateValue =  convertMillisecTODate(milliSec: calloutData.createdTime, dateFormate: self.dayMonthFormate)
        deskMetaData.statusValue = calloutData.subtitle2 // Status
        deskMetaData.photoFromZuID =  -1
        self.subject = calloutData.title
        self.hasAttachment = false
        let coreDataStack = CoreDataStack(modelName: SearchKitConstants.CoreDataStackConstants.CoreDataModelName)
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
            let deptLists = fetchDeskDepartmentsForEntity(SearchKitConstants.CoreDataStackConstants.DeskDepartmentsTable, portalID: (calloutData.orgID), departmentID: (calloutData.departmentID)!, inManagedObjectContext: managedObjectContext!)
            
            if let listRecord = deptLists.first {
                let deptNameAttribute = #keyPath(DeskDepartments.dept_name)
                departmentName = listRecord.value(forKey: deptNameAttribute) as! String
            }
        }
        
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                _ = ZOSSearchAPIClient.sharedInstance().getDeskCallout(oAuthToken: oAuthToken, portalName: portalName!, portalID: (calloutData.orgID), departmentName: departmentName, entityID: Int64((calloutData.entityID))!, moduleID: (calloutData.moduleID), mode: calloutData.mode, clickPosition: self.indexPath.row)
                { (calloutDataResp, error) in
                    
                    if let calloutDataResp = calloutDataResp {
                        if calloutData.moduleID == 1 {
                            //for request this is the key
                            if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ActualContent] as? String {
                                performUIUpdatesOnMain {
                                    self.finalContent = content
                                }
                            }
                            
                            if let resp = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Result] as? [String: AnyObject] {
                                if let owner = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.CaseOwner] as? String {
                                    performUIUpdatesOnMain {
//                                        self.metaData.feild3Value = owner
                                        deskMetaData.assignedToValue = owner
                                    }
                                }
                            }
                        }
                        
                        if calloutData.moduleID == 2 {
                            //for solution this is the key
                            if let resp = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Result] as? [String: AnyObject] {
                                if let content = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.Answer] as? String {
                                    performUIUpdatesOnMain {
                                        self.finalContent = content
                                    }
                                }
                                
                                if let createdBy = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.CreatedBy] as? String {
                                    performUIUpdatesOnMain {
                                        deskMetaData.fromValue = createdBy
                                    }
                                }
                                
                                if let department = resp[ZOSSearchAPIClient.CalloutResponseJSONKeys.DeskCallout.DepartmentName] as? String {
                                    performUIUpdatesOnMain {
                                        deskMetaData.assignedToValue = department
                                    }
                                }
                            }
                            
                        }
                        //reloading callout VC after we get data from server request
                        NotificationCenter.default.post(name: .reloadCalloutVC, object: nil)
                    }
                }
            }
        })
        self.metaData = deskMetaData
        
    }
    func setUpWikiCallout()
    {
        let item = SearchResultsViewModel.serviceSections[serviceName]!
        let calloutData = item.searchResults[indexPath.row] as! WikiResult
        self.subject = calloutData.wikiName
        let wikiMetaData = WikiCalloutMetaData()
        wikiMetaData.photoFromZuID = calloutData.authorZUID
        wikiMetaData.createdByLabelName =  "Created By:"
        wikiMetaData.postedInLabelName = "In :"
        wikiMetaData.createdByValue = calloutData.authorDisplayName
        wikiMetaData.dateValue = convertMillisecTODate(milliSec: calloutData.lastModifiedTime, dateFormate: self.dayMonthFormate)
        self.hasAttachment = false
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                
                _ = ZOSSearchAPIClient.sharedInstance().getWikiCallout(oAuthToken: oAuthToken, docID: (calloutData.wikiDocID), wikiID: (calloutData.wikiID), wikiCatID: (calloutData.wilkiCatID), wikiType: (calloutData.wikiType), clickPosition: self.indexPath.row)
                {
                    (calloutDataResp, error) in
                    
                    if let calloutDataResp = calloutDataResp {
                        if let content = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.ActualContent] as? String {
                            performUIUpdatesOnMain {
                                self.finalContent = content
                                
                            }
                        }
                    }
                    if let calloutDataResp = calloutDataResp {
                        if let wsname = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.WSName] as? String {
                            performUIUpdatesOnMain {
//                                self.metaData.feild2Value = wsname
                                wikiMetaData.postedIn = wsname
                            }
                        }
                    }
                    performUIUpdatesOnMain {
                        //reloading callout VC after we get data from server request
                        NotificationCenter.default.post(name: .reloadCalloutVC, object: nil)
                    }
                }
            }
        })
        
        self.metaData = wikiMetaData
    }
}
extension CalloutVCData{
    func createCommentsDataModal(comments  : [[String : String]]) -> [ConnectCommentData]
    {
        var commentsData = [ConnectCommentData]()
        for comment in comments
        {
            let commentData = ConnectCommentData()
            for key in comment.keys
            {
                switch key
                {
                case ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.CommentData.Content:
                    commentData.content = comment[key]!
                case ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.CommentData.ID:
                    commentData.id = Int64(comment[key]!)!
                case ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.CommentData.Name:
                    commentData.name = comment[key]!
                case ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.CommentData.Time:
                    commentData.time = comment[key]!
                case ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.CommentData.Zuid:
                    commentData.zuid = Int64(comment[key]!)!
                default :
                    break
                    
                }
            }
            commentsData.append(commentData)
        }
        return commentsData
    }
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
            if let records = records as? [NSManagedObject]
            {
                result = records
            }
        }
        catch
        {
            
            SearchKitLogger.errorLog(message: "Unable to fetch managed objects for entity \(entity).", filePath: #file, lineNumber: #line, funcName: #function)
        }
        return result
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
    func formStringfrom(array : [String]) -> String
    {
        let array = array
        if array.count > 1
        {
            return array.joined(separator: "\n")
        }
        return array[0] + ""
    }
    func convertMillisecTODate(milliSec:Int64 , dateFormate : String)->String
    {
        
        let date = Date(milliseconds: milliSec)
        let dateformate = DateFormatter()
        if date.day == Date().day
        {
            dateformate.timeStyle = .short
            return  dateformate.string(from: date)
        }
        else
        {
            dateformate.dateFormat = dateFormate
            return  dateformate.string(from: date)
        }
    }
    func createAttachmentFiles(attachments : [[String: String]] , msgID : Int64 ,accID : Int64) -> [AttachmentData]
    {
        var name = String()
        var size = String()
        var index = String()
        if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail
        {
            name = ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.AttactmentData.name
            size = ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.AttactmentData.size
            index = ZOSSearchAPIClient.CalloutResponseJSONKeys.MailCallout.AttactmentData.index
        }
        else if serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect
        {
            name = ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.AttactmentData.name
            size = ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.AttactmentData.size
            index = ZOSSearchAPIClient.CalloutResponseJSONKeys.ConnectCallout.AttactmentData.index
        }
        var attFiles = [AttachmentData]()
        for attach in attachments
        {
            let attData = AttachmentData()
            for key in attach.keys
            {
                switch key
                {
                case name:
                    attData.name = attach[key]!
                    let type = attData.name.components(separatedBy: ".").last!
                    switch type{
                    case "png","PNG","jpeg","gif","jpg":
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
                    case "mp4":
                        attData.type = .videos
                    case "ppt":
                        attData.type = .presentations
                    case "xlsx","xml":
                        attData.type = .spreadSheets
                    default:
                        attData.type = .others
                    }
                case index:
                    attData.index = Int(attach[key]!)!
                case size:
                    attData.size = attach[key]!
                default:
                    break
                }
            }
            // creating file URL parameters
            var parameters = [String: AnyObject]()
            parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Mail as AnyObject
            parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.MessageID] = msgID as AnyObject
            parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountID] = accID as AnyObject
            parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountType] = "1" as AnyObject
            parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.attName] = attData.name as AnyObject
            parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.attIndex] = attData.index as AnyObject
            attData.attURLParameters = parameters
            attFiles.append(attData)
        }
        return attFiles
    }
}
