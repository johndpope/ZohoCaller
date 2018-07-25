//
//  MailAccounts+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 02/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension MailAccounts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MailAccounts> {
        return NSFetchRequest<MailAccounts>(entityName: "MailAccounts")
    }

    @NSManaged public var account_id: Int64
    @NSManaged public var account_type: Int32
    @NSManaged public var account_zuid: Int64
    @NSManaged public var display_name: String?
    @NSManaged public var email_address: String?
    @NSManaged public var is_default: Bool

}
