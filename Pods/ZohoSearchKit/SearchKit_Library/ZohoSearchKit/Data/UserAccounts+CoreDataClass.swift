//
//  UserAccounts+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


public class UserAccounts: NSManagedObject {
    convenience init(zuid: Int64, email: String, zoid: Int64?, displayName: String?, firstName: String?, lastName: String?, gender: String, country: String?, timezone: String?, language: String?, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "UserAccounts", in: context) {
            self.init(entity: ent, insertInto: context)
            self.zuid = zuid
            self.email = email
            if let zoid = zoid {
                self.zoid = zoid
            }
            else {
                self.zoid = -1
            }
            self.display_name = displayName
            self.first_name = firstName
            self.last_name = lastName
            self.gender = gender
            self.country = country
            self.timezone = timezone
            self.language = language
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
