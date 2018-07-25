//
//  MailAcntTags+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 13/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension MailAcntTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MailAcntTags> {
        return NSFetchRequest<MailAcntTags>(entityName: "MailAcntTags")
    }

    @NSManaged public var account_id: Int64
    @NSManaged public var tag_color: String?
    @NSManaged public var tag_name: String?
    @NSManaged public var tag_id: Int64

}
