//
//  DeskDepartments+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension DeskDepartments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeskDepartments> {
        return NSFetchRequest<DeskDepartments>(entityName: "DeskDepartments")
    }

    @NSManaged public var dept_id: Int64
    @NSManaged public var dept_name: String?
    @NSManaged public var is_default: Bool
    @NSManaged public var portal_id: Int64

}
