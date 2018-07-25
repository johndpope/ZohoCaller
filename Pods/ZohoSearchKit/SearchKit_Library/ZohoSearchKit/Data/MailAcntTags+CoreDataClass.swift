//
//  MailAcntTags+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 13/04/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MailAcntTags)
public class MailAcntTags: NSManagedObject {
    convenience init(tagID: Int64, tagName: String, accountID: Int64, tagColor: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "MailAcntTags", in: context) {
            self.init(entity: ent, insertInto: context)
            self.account_id = accountID
            self.tag_id = tagID
            self.tag_name = tagName
            self.tag_color = tagColor
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
