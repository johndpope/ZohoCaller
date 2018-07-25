//
//  SearchKitURLConfig.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class SearchKitURLConfig {
    private var _searchServerHost = ZOSSearchAPIClient.SearchAPI.ApiHost
    private var _contactsServerHost = ZOSSearchAPIClient.ContactsPhotoAPI.ApiHost
    private var _docsServerHost = ZOSSearchAPIClient.DocsResourceAPI.ApiHost
    
    var searchServerHost: String {
        get {
            return _searchServerHost
        }
        set(newValue) {
            _searchServerHost = newValue
        }
    }
    
    var contactsServerHost: String {
        get {
            return _contactsServerHost
        }
        set(newValue) {
            _contactsServerHost = newValue
        }
    }
    
    var docsServerHost: String {
        get {
            return _docsServerHost
        }
        set(newValue) {
            _docsServerHost = newValue
        }
    }
}
