//
//  DeskResultsMetaData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/04/18.
//

import Foundation

class DeskResultsMetaData: SearchResultsMetaData {
    let departmentID: Int
    let departmentName: String
    
    init(dictionary: [String:AnyObject]) {
        let deptIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskResultsMetaData.DepartmentID] as! String
        departmentID = Int(deptIDStr)!
        departmentName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskResultsMetaData.DepartmentName] as! String
        
        let portalID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskResultsMetaData.PortalID] as! String
        let portalName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskResultsMetaData.PortalName] as! String
        
        super.init(accountID: portalID, accountDisplayName: portalName)
    }
}
