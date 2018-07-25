//
//  UserApps+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

public class UserApps: NSManagedObject {
    convenience init(serviceName: String, displayName: String, isSupported: Bool, isEnabled: Bool, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "UserApps", in: context) {
            self.init(entity: ent, insertInto: context)
            self.service_name = serviceName
            self.display_name = displayName
            self.is_supported = isSupported
            self.is_enabled = isEnabled
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
