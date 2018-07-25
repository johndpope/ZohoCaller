//
//  MailAcntFolders+CoreDataProperties.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 30/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData


extension MailAcntFolders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MailAcntFolders> {
        return NSFetchRequest<MailAcntFolders>(entityName: "MailAcntFolders")
    }

    @NSManaged public var folder_id: Int64
    @NSManaged public var folder_name: String?
    @NSManaged public var account_id: Int64

}
