//
//  UserWikis+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension UserWikis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserWikis> {
        return NSFetchRequest<UserWikis>(entityName: "UserWikis")
    }

    @NSManaged public var is_default: Bool
    @NSManaged public var wiki_id: Int64
    @NSManaged public var wiki_name: String?
    @NSManaged public var wiki_type: Int16
    @NSManaged public var account_zuid: Int64

}
