//
//  ConnectPortals+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ConnectPortals)
public class ConnectPortals: NSManagedObject {
    convenience init(portalID: Int64, portalName: String, isDefault: Bool, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "ConnectPortals", in: context) {
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
