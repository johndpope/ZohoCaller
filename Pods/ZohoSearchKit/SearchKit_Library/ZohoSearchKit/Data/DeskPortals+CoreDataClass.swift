//
//  DeskPortals+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DeskPortals)
public class DeskPortals: NSManagedObject {
    
    convenience init(portalID: Int64, portalName: String, isDefault: Bool, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "DeskPortals", in: context) {
            self.init(entity: ent, insertInto: context)
            self.portal_id = portalID
            self.portal_name = portalName
            self.is_default = isDefault
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
