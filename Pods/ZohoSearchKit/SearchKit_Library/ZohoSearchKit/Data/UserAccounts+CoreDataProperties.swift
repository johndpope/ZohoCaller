//
//  UserAccounts+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension UserAccounts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAccounts> {
        return NSFetchRequest<UserAccounts>(entityName: "UserAccounts")
    }

    @NSManaged public var country: String?
    @NSManaged public var display_name: String?
    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var language: String?
    @NSManaged public var last_name: String?
    @NSManaged public var timezone: String?
    @NSManaged public var zoid: Int64
    @NSManaged public var zuid: Int64
    @NSManaged public var gender: String?

}
