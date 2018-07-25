//
//  ResultViewModelItemType.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

//Adding a new service is super easy -
//1. Just add the unique type here
//2. Add implementation of ServiceResultViewModel for the service
//3. Create table cell for the service results row.

enum SearchResultsType {
    case chatResult
    case mailResult
    case docsResult
    case peopleResult
    case contactsResult
    case connectResult
    case crmResult
    case deskResult
    case wikiResult
}
