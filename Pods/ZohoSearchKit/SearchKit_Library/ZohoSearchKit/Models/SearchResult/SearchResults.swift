//
//  SearchResults.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 18/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

public class SearchResults {
    let query: String
    //TODO: This will be put into one class later - ServiceSearchResults
    var serviceToResultsMap: Dictionary<String, [SearchResult]>
    var serviceToMetaDataMap: Dictionary<String, SearchResultsMetaData>
    
    init(query: String) {
        self.query = query
        self.serviceToResultsMap = [String: [SearchResult]]()
        self.serviceToMetaDataMap = [String: SearchResultsMetaData]()
    }
    
    func setMetaDataForService(serviceName: String, resultMetaData: SearchResultsMetaData?) {
        serviceToMetaDataMap[serviceName] = resultMetaData
    }
    
    func addResultsForService(serviceName: String, searchResults: [SearchResult] ) -> Void {
        //some services can return empty results and some might return error state,
        //in that case dictionary will have no entry for such service.
        serviceToResultsMap[serviceName] = searchResults
    }
    
    static func searchResultsFromResponse(searchString: String, results: [String:AnyObject]) -> SearchResults {
        SearchKitLogger.debugLog(message: "Going to parse search reponse and create result objects", filePath: #file, lineNumber: #line, funcName: #function)
        
        //get and set the query, for which the results has been obtained.
        let searchResults = SearchResults(query: searchString)
        
        for (serviceName, searchRes) in results {
            
            switch serviceName {
            // MARK: Mail Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                if let mailResp = searchRes as? [String:AnyObject] {
                    //meta data
                    if let metaData = mailResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResultMetaData] as? [String: AnyObject] {
                        if let mailAccountMeta = metaData[ZOSSearchAPIClient.SearchResponseJSONKeys.MailResultsMetaData.MailAccount] as? [String: AnyObject] {
                            let resultsMetaData = MailResultsMetaData(dictionary: mailAccountMeta)
                            searchResults.setMetaDataForService(serviceName: serviceName, resultMetaData: resultsMetaData)
                        }
                    }
                    
                    //search results
                    if let results = mailResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let mailResults = MailResult.mailResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: mailResults)
                    }
                    else {
                        //handle
                    }
                    
                }
                else {
                    //handle
                }
                
            // MARK: Chat/Cliq Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                if let chatResp = searchRes as? [String:AnyObject] {
                    if let results = chatResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let chatResults = ChatResult.chatResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: chatResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Mail Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                if let connectResp = searchRes as? [String:AnyObject] {
                    //meta data
                    if let metaData = connectResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResultMetaData] as? [String: AnyObject] {
                        let resultsMetaData = ConnectResultsMetaData(dictionary: metaData)
                        searchResults.setMetaDataForService(serviceName: serviceName, resultMetaData: resultsMetaData)
                    }
                    
                    if let results = connectResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let connectResults = ConnectResult.connectResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: connectResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Contacts Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
                if let contactsResp = searchRes as? [String:AnyObject] {
                    if let results = contactsResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let contactsResults = ContactsResult.contactsResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: contactsResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: People Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.People:
                if let peopleResp = searchRes as? [String:AnyObject] {
                    if let results = peopleResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let peopleResults = PeopleResult.peopleResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: peopleResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Documents Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                if let docsResp = searchRes as? [String:AnyObject] {
                    if let results = docsResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let docResults = DocsResult.docsResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: docResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Mail Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                if let supportResp = searchRes as? [String:AnyObject] {
                    
                    //meta data
                    if let metaData = supportResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResultMetaData] as? [String: AnyObject] {
                        let resultsMetaData = DeskResultsMetaData(dictionary: metaData)
                        searchResults.setMetaDataForService(serviceName: serviceName, resultMetaData: resultsMetaData)
                    }
                    
                    if let results = supportResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let supResults = SupportResult.supportResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: supResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Mail Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                if let crmResp = searchRes as? [String:AnyObject] {
                    if let results = crmResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let crmResults = CRMResult.crmResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: crmResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            // MARK: Mail Service parsing and result object creation
            case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                if let wikiResp = searchRes as? [String:AnyObject] {
                    
                    //meta data
                    if let metaData = wikiResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResultMetaData] as? [String: AnyObject] {
                        let resultsMetaData = WikiResultsMetaData(dictionary: metaData)
                        searchResults.setMetaDataForService(serviceName: serviceName, resultMetaData: resultsMetaData)
                    }
                    
                    if let results = wikiResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                        let wikiResults = WikiResult.wikiResultsFromResponse(results)
                        searchResults.addResultsForService(serviceName: serviceName, searchResults: wikiResults)
                    }
                    else {
                        //handle
                    }
                }
                else {
                    //handle
                }
                
            default:
                SearchKitLogger.warningLog(message: "Unknown service encountered, service name: \(serviceName)", filePath: #file, lineNumber: #line, funcName: #function)
            }
        }
        
        SearchKitLogger.debugLog(message: "Parsing search reponse completed.", filePath: #file, lineNumber: #line, funcName: #function)
        return searchResults
    }
}
