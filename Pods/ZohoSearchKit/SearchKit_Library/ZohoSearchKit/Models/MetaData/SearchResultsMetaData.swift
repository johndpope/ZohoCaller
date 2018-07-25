//
//  SearchResultsMetaData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/04/18.
//

import Foundation

class SearchResultsMetaData {
    //string as some services has string as account id like mail service is using email address
    let accountID: String
    let accountDisplayName: String
    
    init(accountID: String, accountDisplayName: String) {
        self.accountID = accountID
        self.accountDisplayName = accountDisplayName
    }
}
