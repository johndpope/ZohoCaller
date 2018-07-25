//
//  SearchHistory+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 14/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SearchHistory)
public class SearchHistory: NSManagedObject {
    convenience init(mentionedZUID: Int64, contactName: String?, resultCount: Int32, searchQuery: String, searchType: String, timestamp: Int64, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "SearchHistory", in: context) {
            self.init(entity: ent, insertInto: context)
            self.mention_zuid = mentionedZUID
            self.mention_contact_name = contactName
            self.result_count = resultCount
            self.search_query = searchQuery
            self.search_type = searchType
            self.timestamp = timestamp
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
