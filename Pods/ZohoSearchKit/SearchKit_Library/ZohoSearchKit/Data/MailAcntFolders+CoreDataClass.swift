//
//  MailAcntFolders+CoreDataClass.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 30/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MailAcntFolders)
public class MailAcntFolders: NSManagedObject {
    
    convenience init(folderID: Int64, folderName: String, accountID: Int64, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "MailAcntFolders", in: context) {
            self.init(entity: ent, insertInto: context)
            self.account_id = accountID
            self.folder_id = folderID
            self.folder_name = folderName
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
