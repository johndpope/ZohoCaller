//
//  CRMModules+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension CRMModules {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CRMModules> {
        return NSFetchRequest<CRMModules>(entityName: "CRMModules")
    }

    @NSManaged public var module_display_name: String?
    @NSManaged public var module_name: String?
    @NSManaged public var module_query_name: String?
    @NSManaged public var account_zuid: Int64
    @NSManaged public var module_id: Int64

}
