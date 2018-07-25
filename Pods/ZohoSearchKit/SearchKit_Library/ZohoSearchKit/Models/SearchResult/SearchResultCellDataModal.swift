//
//  SearchResultCellDataModal.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 13/06/18.
//

import Foundation
class SearchResultCellDataModal {
    //Set any one of this three for result ImageView
    var resultImageName: String?
    var contactImageZUID : Int64?
    var ImageURl : String?
    
    var textIconForResult: String?
    var attachmentImageName: String?
    var resultTitle: String?
    var resultSubtitle: String?
    var time: String?
    var resultModule: String?
    var ismailUnread : Bool = false
    var serviceName: String
    var searchResultItem: SearchResult
    
    init(serviceName  :String , searchResultItem : SearchResult){
        self.serviceName = serviceName
        self.searchResultItem = searchResultItem
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
    internal func setMailResultFields() {
        let mailResult = searchResultItem as! MailResult
        if mailResult.subject.isEmpty {
            resultTitle = "--- No subject available ---"
        }
        else {
            resultTitle = mailResult.subject
        }
        resultSubtitle = mailResult.fromAddress
        resultModule = mailResult.folderName
        time = DateUtils.getDisaplayableDate(timestamp: mailResult.receivedTime)
        if (mailResult.isMailUnRead) {
            ismailUnread = true
            resultImageName = SearchKitConstants.ImageNameConstants.MailUnreadImage
        }
        else {
            resultImageName = SearchKitConstants.ImageNameConstants.MailReadImage
        }
        
        if mailResult.hasAttachments! {
            attachmentImageName = SearchKitConstants.ImageNameConstants.AttachmentImage
        }
    }
    internal func setCliqResultFields() {
        
        let chatResult = self.searchResultItem as! ChatResult
        self.resultTitle = chatResult.chatTitle
        self.time = DateUtils.getDisaplayableDate(timestamp: chatResult.messageTime)
        if (chatResult.getImageZUID == -1) {
            self.resultImageName = SearchKitConstants.ImageNameConstants.CliqGroupChatImage
        }
        else {
            
            self.contactImageZUID = chatResult.getImageZUID
        }
        if (chatResult.accountID == ZohoSearchKit.sharedInstance().getCurrentUser().zuid) {
            self.resultSubtitle = "Me"
        }
        else {
            self.resultSubtitle = chatResult.chatOwnerName
        }
    }
    internal func setConnectResultFields() {
        
        let connectResult = searchResultItem as! ConnectResult
        resultTitle = connectResult.postTitle!
        resultSubtitle = connectResult.authorName
        time = DateUtils.getDisaplayableDate(timestamp: connectResult.postTime)
        if (connectResult.authorZUID == -1) {
            resultImageName = SearchKitConstants.ImageNameConstants.NoUserImage
        }
        else {
            self.contactImageZUID = connectResult.authorZUID
        }
        if connectResult.hasAttachments! {
            attachmentImageName = SearchKitConstants.ImageNameConstants.AttachmentImage
        }
    }
    internal func setPeopleResultFields() {
        let peopleResult = searchResultItem as! PeopleResult
        let empFullName = peopleResult.firstName! + " " + peopleResult.lastName!
        resultTitle = empFullName
        resultSubtitle = peopleResult.email
        resultModule = peopleResult.extn
        contactImageZUID = Int64( peopleResult.zuid!)
    }
    internal func setDocsResultFields() {
        let docsResult = searchResultItem as! DocsResult
        resultTitle = docsResult.docName
        resultSubtitle = docsResult.docAuthor
        time = DateUtils.getDisaplayableDate(timestamp: docsResult.lastModifiedTime)
        self.resultImageName = ResultIconUtils.getIconNameForDocsResult(docResult: docsResult)
    }
    internal func setDeskResultFields() {
        let supportResult = searchResultItem as! SupportResult
        resultTitle = supportResult.title!
        
        resultSubtitle = supportResult.subtitle1
        resultModule = supportResult.subtitle2
        time = DateUtils.getDisaplayableDate(timestamp: supportResult.createdTime)
        self.resultImageName = ResultIconUtils.getIconNameForDeskResult(deskResult: supportResult)
    }
    internal func setCRMResultFields() {
        let crmResult = searchResultItem as! CRMResult
        resultModule = crmResult.moduleName
        var title = ""
        var subtitle = ""
        (title , subtitle) = crmResult.getCrmTitleAndSubTitle()
        resultTitle = title
        resultSubtitle = subtitle
        resultImageName = ResultIconUtils.getIconNameForCRMResult(crmResult: crmResult)
    }
    internal func setContactsResultFields() {
        let contactResult = searchResultItem as! ContactsResult
        resultTitle = contactResult.fullName!
        resultSubtitle = contactResult.emailAddress
        if let photo = contactResult.photoURL, photo.isEmpty {
            resultImageName = SearchKitConstants.ImageNameConstants.NoUserImage
        }
        else{
            ImageURl = contactResult.photoURL
        }
    }
    internal func setWikiResultFields() {
        
        let wikiResult = searchResultItem as! WikiResult
        resultTitle = wikiResult.wikiName
        resultSubtitle = wikiResult.authorDisplayName
        time = DateUtils.getDisaplayableDate(timestamp: wikiResult.lastModifiedTime)
        resultImageName = SearchKitConstants.ImageNameConstants.WikiResultImage
    }
}
