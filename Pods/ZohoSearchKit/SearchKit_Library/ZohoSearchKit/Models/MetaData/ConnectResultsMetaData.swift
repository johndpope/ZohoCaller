//
//  ConnectResultsMetaData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/04/18.
//

import Foundation

class ConnectResultsMetaData: SearchResultsMetaData {
    init(dictionary: [String:AnyObject]) {
        let networkID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectResultsMetaData.NetworkID] as! String
        let networkName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectResultsMetaData.NetworkName] as! String
        
        super.init(accountID: networkID, accountDisplayName: networkName)
    }
}
