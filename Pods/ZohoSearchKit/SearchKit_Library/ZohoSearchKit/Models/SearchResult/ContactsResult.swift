//
//  ContactsResult.swift
//  ZohoSearchApp
//
//  Created by hemant kumar s. on 14/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

// MARK: For SDK.

// MARK: - ContactsResult

class ContactsResult: SearchResult {
    
    // MARK: Properties
    let contactsID: Int64
    let accountID: Int64
    let fullName: String?
    let emailAddress: String?
    let mobileNumber: String?
    let serviceName: String
    let contactsType: String
    let photoURL: String?
    let usageCount: Int?
    let stampURL: String?
    
    // MARK: Initializers
    
    // construct a ContactsResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        let contactsIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.ContactID] as! String
        contactsID = Int64(contactsIDStr)!
        let accountIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.AccountID] as! String
        accountID = Int64(accountIDStr)!
        let usageCountStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.UsageCount] as? String
        usageCount = Int(usageCountStr!)
        photoURL = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.PhotoURL] as? String
        stampURL = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.StampURL] as? String
        serviceName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.ServiceName] as! String
        contactsType = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.ContactsType] as! String
        
        if let fullNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.FullName] as? String, fullNameStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            fullName = fullNameStr.decodedHTMLEntities();
        } else {
            fullName = ""
        }
        
        //Duplicated code could be a simple method, which check for the value, decodes html and sets the value
        //to the property passed
        if let mobileNumberStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.MobileNumber] as? String, mobileNumberStr.isEmpty == false {
            mobileNumber = mobileNumberStr;
        } else {
            mobileNumber = ""
        }
        
        if let emailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.EmailAddress] as? String, emailStr.isEmpty == false {
            emailAddress = emailStr;
        } else {
            emailAddress = ""
        }
        
        super.init(entityID: String(contactsID))
        
    }
    
    static func contactsResultsFromResponse(_ results: [[String:AnyObject]]) -> [ContactsResult] {
        
        var contactsResults = [ContactsResult]()
        
        // iterate through array of dictionaries, each ContactsResult is a dictionary
        for result in results {
            contactsResults.append(ContactsResult(dictionary: result))
        }
        
        return contactsResults
    }
}

// MARK: - ContactsResult: Equatable

extension ContactsResult: Equatable {}

func ==(lhs: ContactsResult, rhs: ContactsResult) -> Bool {
    return lhs.contactsID == rhs.contactsID
}
