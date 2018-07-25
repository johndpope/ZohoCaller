//
//  SearchHistory+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 14/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var account_zuid: Int64
    @NSManaged public var mention_zuid: Int64
    @NSManaged public var result_count: Int32
    @NSManaged public var search_query: String?
    @NSManaged public var search_type: String?
    @NSManaged public var timestamp: Int64
    @NSManaged public var mention_contact_name: String?

}
