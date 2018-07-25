//
//  DeskModules+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 22/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension DeskModules {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeskModules> {
        return NSFetchRequest<DeskModules>(entityName: "DeskModules")
    }

    @NSManaged public var module_id: Int16
    @NSManaged public var module_name: String?
    @NSManaged public var portal_id: Int64

}
