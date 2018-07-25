//
//  SearchQueryState.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/04/18.
//

import Foundation

//TODO: Will be used as unified representation of Search Query
class SearchQueryState {
    var serviceName: String = ""
    //TODO: do we need to support full search query where it stores query like -> zoho search @hemantkumar.s test
    var searchQuery: String = "" //default search query is empty, as in case of mention zuid alone query it will empty
    var trimmedSearchQuery: String = ""
    var mentionZUID: Int64 = -1 //When search query only
    //TODO: What will happen when some one renames the contact, if we store the contact name in hostory for faster lookup then it will not be in sync.
    var mentionedUserName: String? //Used to store the mentioned user name in History
    var filters: [String: FilterData] = [String: FilterData]()
    //later when we support multi select, like multiple folder search, we will make FilterData as array
    
    init?(queryString: String) {
        self.searchQuery = queryString
        self.trimmedSearchQuery = queryString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init?(queryString: String, mentionZUID: Int64, mentionedUserName: String) {
        self.searchQuery = queryString
        self.trimmedSearchQuery = queryString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.mentionZUID = mentionZUID
        self.mentionedUserName = mentionedUserName
    }
    
    func addFilter(filterName: String, filter: FilterData) {
        self.filters[filterName] = filter
    }
}
