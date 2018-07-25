//
//  DeskDepartments+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DeskDepartments)
public class DeskDepartments: NSManagedObject {
    
    convenience init(deptID: Int64, deptName: String, isDefault: Bool, portalID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "DeskDepartments", in: context) {
            self.init(entity: ent, insertInto: context)
            self.dept_id = deptID
            self.dept_name = deptName
            self.is_default = isDefault
            self.portal_id = portalID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
