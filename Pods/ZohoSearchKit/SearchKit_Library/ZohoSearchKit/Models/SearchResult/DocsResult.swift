//
//  DocsResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - DocsResult

class DocsResult: SearchResult {
    
    // MARK: Properties
    let docID: String
    let docName: String
    let docAuthor: String
    let docType: String?
    let docFileExtn: String?
    let serviceName: String
    let lastModifiedTime: Int64
    
    // MARK: Initializers
    
    // construct a DocsResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        docID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.DocumentID] as! String
        
        //docName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.DocumentName] as! String
        if let docNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.DocumentName] as? String, docNameStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            docName = docNameStr.decodedHTMLEntities()
        } else {
            docName = ""
        }
        
        docAuthor = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.Author] as! String
        //docType = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.DocumentType] as! String
        
        if let docTypeStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.DocumentType] as? String, docTypeStr.isEmpty == false {
            docType = docTypeStr
        }
        else {
            docType = ""
        }
        
        serviceName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.ServiceName] as! String
        if let fileExt = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.FileExtension] as? String, fileExt.isEmpty == false {
            docFileExtn = fileExt
        } else {
            if serviceName == "explorer" {
                docFileExtn = serviceName
            }
            else {
                docFileExtn = "unknown"
            }
        }
        
        lastModifiedTime = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DocsSearchResult.LastModifiedTime] as! Int64
        
        super.init(entityID: docID)
    }
    
    static func docsResultsFromResponse(_ results: [[String:AnyObject]]) -> [DocsResult] {
        
        var docsResults = [DocsResult]()
        
        // iterate through array of dictionaries, each DocsResult is a dictionary
        for result in results {
            docsResults.append(DocsResult(dictionary: result))
        }
        
        return docsResults
    }
}

// MARK: - DocsResult: Equatable

extension DocsResult: Equatable {}

func ==(lhs: DocsResult, rhs: DocsResult) -> Bool {
    return lhs.docID == rhs.docID
}
