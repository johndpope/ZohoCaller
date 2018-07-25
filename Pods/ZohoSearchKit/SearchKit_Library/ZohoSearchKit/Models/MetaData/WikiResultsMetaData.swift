//
//  WikiResultsMetaData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/04/18.
//

import Foundation

class WikiResultsMetaData: SearchResultsMetaData {
    init(dictionary: [String:AnyObject]) {
        let wikiID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiResultsMetaData.WikiID] ?? Int(0) as AnyObject
        let wikiName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiResultsMetaData.WikiName] as! String
        super.init(accountID: String(wikiID as! Int), accountDisplayName: wikiName)
    }
}

