//
//  ConnectPortals+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension ConnectPortals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConnectPortals> {
        return NSFetchRequest<ConnectPortals>(entityName: "ConnectPortals")
    }

    @NSManaged public var account_zuid: Int64
    @NSManaged public var is_default: Bool
    @NSManaged public var portal_id: Int64
    @NSManaged public var portal_name: String?

}
