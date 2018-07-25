//
//  UserWikis+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserWikis)
public class UserWikis: NSManagedObject {
    
    convenience init(wikiID: Int64, wikiType: Int16, wikiName: String, isDefault: Bool, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "UserWikis", in: context) {
            self.init(entity: ent, insertInto: context)
            self.wiki_id = wikiID
            self.wiki_type = wikiType
            self.wiki_name = wikiName
            self.is_default = isDefault
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
