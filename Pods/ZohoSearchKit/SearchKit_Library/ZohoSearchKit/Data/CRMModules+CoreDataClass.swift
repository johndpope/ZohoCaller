//
//  CRMModules+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CRMModules)
public class CRMModules: NSManagedObject {
    convenience init(moduleID: Int64, moduleName: String, moduleQueryName: String, moduleDisplayName: String, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "CRMModules", in: context) {
            self.init(entity: ent, insertInto: context)
            self.module_id = moduleID
            self.account_zuid = userAccountZUID
            self.module_name = moduleName
            self.module_query_name = moduleQueryName
            self.module_display_name = moduleDisplayName
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
