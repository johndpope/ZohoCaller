//
//  DeskPortals+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension DeskPortals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeskPortals> {
        return NSFetchRequest<DeskPortals>(entityName: "DeskPortals")
    }

    @NSManaged public var is_default: Bool
    @NSManaged public var portal_id: Int64
    @NSManaged public var portal_name: String?
    @NSManaged public var account_zuid: Int64

}
