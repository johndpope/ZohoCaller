//
//  UserContacts+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 22/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension UserContacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContacts> {
        return NSFetchRequest<UserContacts>(entityName: "UserContacts")
    }

    @NSManaged public var account_zuid: Int64
    @NSManaged public var contact_zuid: Int64
    @NSManaged public var email_address: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var nick_name: String?
    @NSManaged public var usage_count: Int32

}
