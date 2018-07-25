//
//  SavedSearches+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedSearches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSearches> {
        return NSFetchRequest<SavedSearches>(entityName: "SavedSearches")
    }

    @NSManaged public var account_zuid: Int64
    @NSManaged public var query_state_json: String?
    @NSManaged public var saved_search_name: String?
    @NSManaged public var service_name: String?
    @NSManaged public var lmtime: Int64

}
