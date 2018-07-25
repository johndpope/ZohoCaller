//
//  SavedSearches+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SavedSearches)
public class SavedSearches: NSManagedObject {
    convenience init(savedSearchName: String, serviceName:String, fullQueryStateJSON: String, lmtime: Int64, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "SavedSearches", in: context) {
            self.init(entity: ent, insertInto: context)
            self.saved_search_name = savedSearchName
            self.service_name = serviceName
            self.query_state_json = fullQueryStateJSON
            self.lmtime = lmtime
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
