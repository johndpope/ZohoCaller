//
//  WikiResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - WikiResult

class WikiResult: SearchResult {
    
    // MARK: Properties
    let wikiID: Int64
    let wikiDocID: Int64
    let wikiName: String
    let wikiAuthor: String
    let lastModifiedTime: Int64
    let wikiType: Int
    let wilkiCatID: Int64
    let authorZUID: Int64
    let authorDisplayName: String
    let lmAuthorDisplayName: String
    
    // MARK: Initializers
    
    // construct a WikiResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        let wikiIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.WikiID] as! String
        wikiID = Int64(wikiIDStr)!
        
        let wikiDocIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.WikiDocID] as! String
        wikiDocID = Int64(wikiDocIDStr)!
        authorZUID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.WikiAuthorZUID] as! Int64
        
        //wikiName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.PageTitle] as! String
        if let wikiNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.PageTitle] as? String, wikiNameStr.isEmpty == false {
            //MARK: Decoded(HTML tags) wiki name
            wikiName = wikiNameStr.decodedHTMLEntities()
        } else {
            wikiName = ""
        }
        
        if let wikiAuthorDispNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.AuthorDisplayName] as? String, wikiAuthorDispNameStr.isEmpty == false {
            //MARK: Decoded(HTML tags) wiki name
            authorDisplayName = wikiAuthorDispNameStr.decodedHTMLEntities()
        } else {
            authorDisplayName = ""
        }
        
        if let wikiLMAuthorNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.LMAuthorDisplayName] as? String, wikiLMAuthorNameStr.isEmpty == false {
            //MARK: Decoded(HTML tags) wiki name
            lmAuthorDisplayName = wikiLMAuthorNameStr.decodedHTMLEntities()
        } else {
            lmAuthorDisplayName = ""
        }
        
        wikiAuthor = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.AuthorName] as! String
        lastModifiedTime = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.LastModifiedTime] as! Int64
        
        let wikiCatIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.WikiCategoryID] as! String
        wilkiCatID = Int64(wikiCatIDStr)!
        
        let wikiTypeStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.WikiSearchResult.WikiType] as! String
        wikiType = Int(wikiTypeStr)!
        
        super.init(entityID: String(wikiID))
    }
    
    static func wikiResultsFromResponse(_ results: [[String:AnyObject]]) -> [WikiResult] {
        
        var wikiResults = [WikiResult]()
        
        // iterate through array of dictionaries, each WikiResult is a dictionary
        for result in results {
            wikiResults.append(WikiResult(dictionary: result))
        }
        
        return wikiResults
    }
}

// MARK: - ChatResult: Equatable

extension WikiResult: Equatable {}

func ==(lhs: WikiResult, rhs: WikiResult) -> Bool {
    return lhs.wikiID == rhs.wikiID
}
