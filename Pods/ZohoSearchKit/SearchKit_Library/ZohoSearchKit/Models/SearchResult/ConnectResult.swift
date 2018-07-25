//
//  ConnectResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: - ConnectResult

class ConnectResult: SearchResult {
    
    enum ResultType: String {
        //sid is for deeplinking
        case Feeds = "sid"//Feeds is any of the STATUS, LINK or something
        case Forums = "bid"//Forum is exclusively marked as FORUMS
        case Unsupported = "notsupported"
        //later when supported will add Tasks and Manuals
    }
    
    //TODO: These will overflow, these must be stored in int64 not in Int
    //Make sure to use correct data type
    // MARK: Properties
    let postID: Int64
    let postTitle: String?
    let postedIn: String?
    let postURL: String
    let authorName: String
    let authorZUID: Int64
    let postTime: Int64
    let hasAttachments: Bool?
    let type: ResultType?
    
    // MARK: Initializers
    
    // construct a ConnectResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        let postIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamID] as? String
        postID = Int64(postIDStr!)!;
        //postID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamID] as! Int
        
        if let postTitleStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamTitle] as? String, postTitleStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            postTitle = postTitleStr.decodedHTMLEntities()
        } else {
            postTitle = ""
        }
        
        if let postedInStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.PostedInWall] as? String, postedInStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            postedIn = postedInStr.decodedHTMLEntities()
        } else {
            postedIn = ""
        }
        
        if let postTypeStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamType] as? String, postTypeStr.isEmpty == false {
            if postTypeStr == "FORUMS" {
                type = ResultType.Forums
            }
            else {
                //for now other than forums it will be feed results
                //feed itself is of multiple types like STATUS, LINK etc
                //TODO: will handle later if needed
                type = ResultType.Feeds
            }
        }
        else {
            type = ResultType.Unsupported
        }
        
        postURL = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamURL] as! String
        authorName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.StreamAuthor] as! String
        let authorZUIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.Zuid] as? String
        authorZUID = Int64(authorZUIDStr!)!;
        let postTimeStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.LastModifiedTime] as? String
        postTime = Int64(postTimeStr!)!;
        
        let hasAttachStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ConnectSearchResult.HasAttachment] as? String
        hasAttachments = Bool(hasAttachStr!)!;
        
        super.init(entityID: String(postID))
    }
    
    static func connectResultsFromResponse(_ results: [[String:AnyObject]]) -> [ConnectResult] {
        
        var connectResults = [ConnectResult]()
        
        // iterate through array of dictionaries, each ConnectResult is a dictionary
        for result in results {
            connectResults.append(ConnectResult(dictionary: result))
        }
        
        return connectResults
    }
}

// MARK: - ConnectResult: Equatable

extension ConnectResult: Equatable {}

func ==(lhs: ConnectResult, rhs: ConnectResult) -> Bool {
    return lhs.entityID == rhs.entityID
}
