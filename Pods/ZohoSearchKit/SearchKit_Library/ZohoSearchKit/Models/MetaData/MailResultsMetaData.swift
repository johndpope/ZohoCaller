//
//  MailResultsMetaData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/04/18.
//

import Foundation

class MailResultsMetaData: SearchResultsMetaData {
    
    init(dictionary: [String:AnyObject]) {
        let emailAddr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailResultsMetaData.EmailAddress] as! String
        let displayName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.MailResultsMetaData.AccountDisplayName] as! String
        
        super.init(accountID: emailAddr, accountDisplayName: displayName)
    }
}
