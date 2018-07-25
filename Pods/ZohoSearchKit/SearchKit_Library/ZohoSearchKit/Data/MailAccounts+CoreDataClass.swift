//
//  MailAccounts+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 02/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MailAccounts)
public class MailAccounts: NSManagedObject {
    convenience init(accountID: Int64, accountType: Int32, displayName: String, emailAddress:String, isDefault: Bool, userAccountZUID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "MailAccounts", in: context) {
            self.init(entity: ent, insertInto: context)
            self.account_id = accountID
            self.account_type = accountType
            self.display_name = displayName
            self.email_address = emailAddress
            self.is_default = isDefault
            self.account_zuid = userAccountZUID
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
