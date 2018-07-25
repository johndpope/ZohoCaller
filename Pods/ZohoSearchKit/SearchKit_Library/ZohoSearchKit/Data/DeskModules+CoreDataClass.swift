//
//  DeskModules+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 22/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DeskModules)
public class DeskModules: NSManagedObject {
    convenience init(moduleID: Int16, moduleName: String, portalID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "DeskModules", in: context) {
            self.init(entity: ent, insertInto: context)
            self.module_id = moduleID
            self.module_name = moduleName
            self.portal_id = portalID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
