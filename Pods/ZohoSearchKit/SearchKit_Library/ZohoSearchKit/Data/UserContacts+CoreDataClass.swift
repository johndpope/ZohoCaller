//
//  UserContacts+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 22/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserContacts)
public class UserContacts: NSManagedObject {
    convenience init(contactZUID: Int64, emailAddress: String, firstName: String, lastName: String, nickName: String, usageCount: Int32, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "UserContacts", in: context) {
            self.init(entity: ent, insertInto: context)
            self.contact_zuid = contactZUID
            self.email_address = emailAddress
            self.first_name = firstName
            self.last_name = lastName
            self.nick_name = nickName
            self.usage_count = usageCount
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
