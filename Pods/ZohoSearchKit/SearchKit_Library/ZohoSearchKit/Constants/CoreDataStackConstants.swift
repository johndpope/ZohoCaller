//
//  CoreDataStackConstants.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 09/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension SearchKitConstants {
    struct CoreDataStackConstants {
        static let CoreDataModelName = "ZohoSearchKitModel"
        
        //TODO: any better alternative to hatrdcoding the entity name. Can we use reflection or description or anything
        //because if we change name in Model editor it will not reflect here.
        static let ConnectPortalsTable = "ConnectPortals"
        static let CRMModulesTable = "CRMModules"
        static let DeskPortalsTable = "DeskPortals"
        static let DeskDepartmentsTable = "DeskDepartments"
        static let DeskModulesTable = "DeskModules"
        static let UserWikisTable = "UserWikis"
        static let UserContactsTable = "UserContacts"
        static let UserAppsTable = "UserApps"
        static let UserAccountsTable = "UserAccounts"
        static let SearchHistoryTable = "SearchHistory"
        static let SavedSearchesTable = "SavedSearches"
        static let MailAccountsTable = "MailAccounts"
        static let MailAccountsFolderTable = "MailAcntFolders"
        static let MailAccountsTagTable = "MailAcntTags"

    }
    
    //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
    struct FormatStringConstants {
        static let String = "%@"
        static let Character = "%c"
        static let FloatValue = "%f"
        static let SignedShortInt = "%hd"
        static let UnsignedShortInt = "%hu"
        static let SignedInt = "%d"
        static let UnsignedInt = "%u"
        static let LongSignedInt = "%ld"
        static let LongUnsignedInt = "%lu"
        static let LongLongSignedInt = "%lld"
        static let LongLongUnsignedInt = "%llu"
        //static let
    }
    
    struct CustomNotificationNames {
        static let WidgetDataDownloadComplete = "widgetdatadownloadcomplete"
    }
}
