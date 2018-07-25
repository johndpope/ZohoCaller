//
//  MailResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - MailResult

class MailResult: SearchResult {
    
    // MARK: Properties
    let messageID: Int64
    let subject: String
    let senderName: String
    let folderName: String
    let fromAddress: String
    let mailSummary: String
    let receivedTime: Int64
    let accountID: Int64
    let isMailUnRead: Bool
    let hasAttachments: Bool?
    
    // MARK: Initializers
    
    // construct a ConnectResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        let msgIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MessageID] as? String
        messageID = Int64(msgIDStr!)!;
        //messageID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MessageID] as! Int
        
        //subject = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MailSubject] as! String
        if let subjectStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MailSubject] as? String, subjectStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            subject = subjectStr.decodedHTMLEntities()
        } else {
            subject = ""
        }
        
        //Should folder name, from address, to address should be HTML decoded
        senderName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.SenderName] as! String
        folderName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.FolderName] as! String
        fromAddress = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.FromAddress] as! String
        
        //mailSummary = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MailSummary] as! String
        if let summaryStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.MailSummary] as? String, summaryStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            mailSummary = summaryStr.decodedHTMLEntities()
        } else {
            mailSummary = ""
        }
        
        receivedTime = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.RecievedTime] as! Int64
        //as message id is obtained as string from mail response.
        let acntIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.AccountID] as? String
        accountID = Int64(acntIDStr!)!;
        //accountID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.AccountID] as! Int
        isMailUnRead = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.IsMailUnread] as! Bool
        hasAttachments = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailSearchResult.HasAttachment] as? Bool
        
        super.init(entityID: String(messageID))
    }
    
    static func mailResultsFromResponse(_ results: [[String:AnyObject]]) -> [MailResult] {
        
        var mailResults = [MailResult]()
        
        // iterate through array of dictionaries, each MailResult is a dictionary
        for result in results {
            mailResults.append(MailResult(dictionary: result))
        }
        
        return mailResults
    }
}

// MARK: - MailResult: Equatable

extension MailResult: Equatable {}

func ==(lhs: MailResult, rhs: MailResult) -> Bool {
    return lhs.messageID == rhs.messageID
}
