//
//  UserApps+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension UserApps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserApps> {
        return NSFetchRequest<UserApps>(entityName: "UserApps")
    }

    @NSManaged public var display_name: String?
    @NSManaged public var is_enabled: Bool
    @NSManaged public var is_supported: Bool
    @NSManaged public var service_name: String?
    @NSManaged public var account_zuid: Int64

}
