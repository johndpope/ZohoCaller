//
//  ZOSConvenience.swift
//  ZohoSearchApp
//
//  Created by hemant kumar s. on 13/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

//for better performance with images
// TODO: This one to be replaced by LRU disk + in memory image cache for better performance. Currently it is just in-memory
let imageCache = NSCache<NSString, UIImage>()

extension ZOSSearchAPIClient {
    typealias ImageDataHandler = (_ image: UIImage?, _ error: NSError?) -> Void
    typealias DataHandler = (_ image: Data?, _ error: NSError?) -> Void
   public typealias SearchRespHandler = (_ searchResults: SearchResults?, _ error: NSError?) -> Void
    typealias ServiceSearchResultsHandler = (_ serviceSearchResults: [SearchResult]?, _ error: NSError?) -> Void
    typealias WidgetDataResponseHandler = (_ widgetDataResponse: AnyObject?, _ error: NSError?) -> Void
    typealias CalloutDataResponseHandler = (_ calloutDataResponse: AnyObject?, _ error: NSError?) -> Void
    typealias ContactsResponseHandler = (_ contactsResponse: AnyObject?, _ error: NSError?) -> Void
    
    func getContactImage(_ contactID: Int64, oAuthToken: String, completionHandlerForImage: @escaping ImageDataHandler) {
        
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.FileSize] = ZOSSearchAPIClient.ContactsPhotoAPIParamValues.ContactImageFileSize.Thumb.rawValue as AnyObject
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.PhotoType] = ZOSSearchAPIClient.ContactsPhotoAPIParamValues.ContactImageType.User.rawValue as AnyObject
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.ContactID] = contactID as AnyObject
        
        let photoURL = contactsImageURLFromParameters(parameters);
        
        if let cachedImage = imageCache.object(forKey: photoURL.absoluteString as NSString) {
            completionHandlerForImage(cachedImage, nil)
        }
        else {
            //_ anonymous variable as we neither mutate or return the value
            _ = taskForGETImage(oAuthToken, imageURL: photoURL) { (data, error) in
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandlerForImage(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: photoURL.absoluteString as NSString)
                    completionHandlerForImage(image, nil)
                } else {
                    completionHandlerForImage(nil, NSError())
                }
            }
        }
    }
    
    func getImageForURL(_ photoURL: String, oAuthToken: String, completionHandlerForImage: @escaping ImageDataHandler) {
        if let cachedImage = imageCache.object(forKey: photoURL as NSString) {
            completionHandlerForImage(cachedImage, nil)
        }
        else {
            let imageURL = URL(string: photoURL)!
            //_ anonymous variable as we neither mutate or return the value
            _ = taskForGETImage(oAuthToken, imageURL: imageURL) { (data, error) in
                if let error = error {
                    completionHandlerForImage(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: photoURL as NSString)
                    completionHandlerForImage(image, nil)
                } else {
                    completionHandlerForImage(nil, NSError())
                }
            }
        }
    }
    
    func getImageDataForURL(_ photoURL: String, oAuthToken: String, completionHandlerForImage: @escaping DataHandler) {
        let imageURL = URL(string: photoURL)!
        //_ anonymous variable as we neither mutate or return the value
        _ = taskForGETImage(oAuthToken, imageURL: imageURL) { (data, error) in
            if let error = error {
                completionHandlerForImage(nil, error)
            } else if let data = data {
                completionHandlerForImage(data, nil)
            } else {
                completionHandlerForImage(nil, NSError())
            }
        }
    }
    
    // MARK: no more used, POC methods. Will be removed later.
    func getChatsForSearchString(_ searchString: String, oAuthToken: String, completionHandlerForSearchResp: @escaping (_ result: [ChatResult]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [ZOSSearchAPIClient.SearchParameterKeys.Query: searchString]
        parameters[ZOSSearchAPIClient.SearchParameterKeys.ServiceList] = "chat";
        parameters[ZOSSearchAPIClient.SearchParameterKeys.SearchType] = "all";
        parameters[ZOSSearchAPIClient.SearchParameterKeys.IsScroll] = "false";
        parameters[ZOSSearchAPIClient.SearchParameterKeys.StartIndex] = "0";
        parameters[ZOSSearchAPIClient.SearchParameterKeys.NumberOfResults] = "25";
        
        /* 2. Make the request */
        let task = taskForGETMethod(oAuthToken, method: APIPaths.Search, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSearchResp(nil, error)
            } else {
                if let response = results?["results"] as? [String: AnyObject] {
                    if let chatResp = response["chat"] as? [String:AnyObject] {
                        if let results = chatResp["results"] as? [[String:AnyObject]] {
                            let chatResults = ChatResult.chatResultsFromResponse(results)
                            completionHandlerForSearchResp(chatResults, nil)
                        } else {
                            completionHandlerForSearchResp(nil, NSError(domain: "getChatsForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse search response"]))
                        }
                    }
                }
            }
        }
        return task
    }
    
    private func isAllServiceSearch(serviceName: String) -> Bool {
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            fallthrough
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            return false
        default:
            //when multiple service is involved, then it will be searched as all
            return true
        }
    }
    
    //search and get search response
  public  func getSearchResults(_ searchString: String, mentionedZUID: Int64?, filters: [String: AnyObject]?, serviceName: String, oAuthToken: String, completionHandlerForSearchResp: @escaping SearchRespHandler) -> URLSessionDataTask? {
        let timer = SearchKitBenchmarkTimer()
        
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.SearchParameterKeys.Query] = searchString as AnyObject
        
        if serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
            //parameters[ZOSSearchAPIClient.SearchParameterKeys.ServiceList] = "chat,mails,connect,people,personalContacts,documents,support,crm,wiki" as AnyObject;
            parameters[ZOSSearchAPIClient.SearchParameterKeys.ServiceList] = UserPrefManager.getCommaSeparatedServiceList() as AnyObject;
            parameters[ZOSSearchAPIClient.SearchParameterKeys.SearchType] = serviceName as AnyObject;
        }
        else {
            parameters[ZOSSearchAPIClient.SearchParameterKeys.ServiceList] = serviceName as AnyObject;
            
            if isAllServiceSearch(serviceName: serviceName) {
                parameters[ZOSSearchAPIClient.SearchParameterKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.All as AnyObject;
            }
            else {
                parameters[ZOSSearchAPIClient.SearchParameterKeys.SearchType] = serviceName as AnyObject;
            }
        }
        
        if mentionedZUID != nil, mentionedZUID != -1 {
            parameters[ZOSSearchAPIClient.SearchParameterKeys.MentionedZUID] = "\(mentionedZUID ?? -1)" as AnyObject
        }
        
        if let searchFilters = filters {
            //create JSON from the dictionary of filters
            let filterJSON = try? JSONSerialization.data(withJSONObject: searchFilters, options: [])
            let jsonString = String(data: filterJSON!, encoding: .utf8)
            parameters[ZOSSearchAPIClient.FilterParameterKeys.Filters] = jsonString as AnyObject
        }
        
        parameters[ZOSSearchAPIClient.SearchParameterKeys.IsScroll] = "false" as AnyObject;
        parameters[ZOSSearchAPIClient.SearchParameterKeys.StartIndex] = "0" as AnyObject;
        parameters[ZOSSearchAPIClient.SearchParameterKeys.NumberOfResults] = "25" as AnyObject;
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.Search, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForSearchResp(nil, error)
            } else {
                if let response = results?["results"] as? [String: AnyObject] {
                    let searchResults = SearchResults.searchResultsFromResponse(searchString: searchString, results: response)
                    print()
                    SearchKitLogger.debugLog(message: "Total time taken for search reults: \(timer.stop())", filePath: #file, lineNumber: #line, funcName: #function)
                    completionHandlerForSearchResp(searchResults, nil)
                } else {
                    completionHandlerForSearchResp(nil, NSError(domain: "getSearchResults parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the search response"]))
                }
            }
        }
        return task
    }
    
    //Later all callout requests will be merged into one
    func getWikiCallout(oAuthToken: String, docID: Int64, wikiID: Int64, wikiCatID: Int64, wikiType: Int, clickPosition: Int, completionHandlerForCalloutDataResp: @escaping CalloutDataResponseHandler) -> URLSessionDataTask? {
        
        // Specify wiki callout request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Wiki as AnyObject
        parameters[ZOSSearchAPIClient.WikiCalloutRequestParamKeys.DocID] = docID as AnyObject
        parameters[ZOSSearchAPIClient.WikiCalloutRequestParamKeys.WikiID] = wikiID as AnyObject
        parameters[ZOSSearchAPIClient.WikiCalloutRequestParamKeys.WikiCategoryID] = wikiCatID as AnyObject
        parameters[ZOSSearchAPIClient.WikiCalloutRequestParamKeys.WikiType] = wikiType as AnyObject
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.ClickPosition] = clickPosition as AnyObject
        
        return callOutRequestTask(oAuthToken, parameters: parameters, completionHandler: completionHandlerForCalloutDataResp)
    }
    func getCRMCallout(oAuthToken: String , entityID : Int64 , crmMod : String, clickPosition: Int,  completionHandlerForCalloutDataResp: @escaping CalloutDataResponseHandler) -> URLSessionDataTask?
    {
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Crm as AnyObject
        parameters[ZOSSearchAPIClient.CRMCalloutRequestParamKeys.EntityID] = entityID as AnyObject
        parameters[ZOSSearchAPIClient.CRMCalloutRequestParamKeys.CrmModule] = crmMod as AnyObject
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.ClickPosition] = clickPosition as AnyObject
        
        return callOutRequestTask(oAuthToken, parameters: parameters, completionHandler: completionHandlerForCalloutDataResp)
    }
    func getConnectCallout(oAuthToken: String, postID: Int64, networkID: Int64, postType: String?, clickPosition: Int, completionHandlerForCalloutDataResp: @escaping CalloutDataResponseHandler) -> URLSessionDataTask? {
        
        // Specify wiki callout request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Connect as AnyObject
        parameters[ZOSSearchAPIClient.ConnectCalloutRequestParamKeys.StreamID] = postID as AnyObject
        parameters[ZOSSearchAPIClient.ConnectCalloutRequestParamKeys.NetworkID] = networkID as AnyObject
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.ClickPosition] = clickPosition as AnyObject
        
        if postType != nil {
             parameters[ZOSSearchAPIClient.ConnectCalloutRequestParamKeys.postType] = postType as AnyObject
        }
        
        return callOutRequestTask(oAuthToken, parameters: parameters, completionHandler: completionHandlerForCalloutDataResp)
    }
    
    func getMailCallout(oAuthToken: String, msgID: Int64, acntID: Int64, clickPosition: Int, completionHandlerForCalloutDataResp: @escaping CalloutDataResponseHandler) -> URLSessionDataTask? {
        
        // Specify mail callout request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Mail as AnyObject
        parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.MessageID] = msgID as AnyObject
        parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountID] = acntID as AnyObject
        
        //TODO: I think this will not be needed as when sending request, will get form result object. Pass this as well.
        parameters[ZOSSearchAPIClient.MailCalloutRequestParamKeys.AccountType] = "1" as AnyObject
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.ClickPosition] = clickPosition as AnyObject
        
        return callOutRequestTask(oAuthToken, parameters: parameters, completionHandler: completionHandlerForCalloutDataResp)
    }
    
    func getDeskCallout(oAuthToken: String, portalName: String, portalID: Int64, departmentName: String, entityID: Int64, moduleID: Int, mode: String?, clickPosition: Int, completionHandlerForCalloutDataResp: @escaping CalloutDataResponseHandler) -> URLSessionDataTask? {
        
        // Specify desk callout request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.SearchType] = ZOSSearchAPIClient.ServiceNameConstants.Desk as AnyObject
        parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.PortalName] = portalName as AnyObject
        parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.PortalID] = portalID as AnyObject
        parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.DepartmentName] = departmentName as AnyObject
        parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.EntityID] = entityID as AnyObject //id - entity id
        parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.ModuleID] = moduleID as AnyObject //module id 1 - request and 2 - KB
        parameters[ZOSSearchAPIClient.CalloutRequestParamKeys.ClickPosition] = clickPosition as AnyObject
        
        if let modeName = mode {
            parameters[ZOSSearchAPIClient.DeskCalloutRequestParamKeys.ModeName] = modeName as AnyObject //mode in case of request
        }
        
        return callOutRequestTask(oAuthToken, parameters: parameters, completionHandler: completionHandlerForCalloutDataResp)
    }
    
    private func callOutRequestTask(_ oAuthToken: String, parameters: [String:AnyObject], completionHandler: @escaping CalloutDataResponseHandler) -> URLSessionDataTask? {
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.Callout, parameters: parameters as [String:AnyObject]) { (calloutData, error) in
            
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(calloutData, nil)
            }
        }
        
        return task
    }
    
    //get widget data response
    func getWidgetData(oAuthToken: String, completionHandlerForWidgetDataResp: @escaping WidgetDataResponseHandler) -> URLSessionDataTask? {
        
        // Specify search request parameters
        let parameters = [String: AnyObject]()
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.WidgetData, parameters: parameters as [String:AnyObject]) { (widgetData, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForWidgetDataResp(nil, error)
            } else {
                completionHandlerForWidgetDataResp(widgetData, nil)
            }
        }
        return task
    }
    
    //This could be one method and all needed params can be passed so code can be merged
    func getDeskModules(oAuthToken: String, portalID: Int64, completionHandlerForWidgetDataResp: @escaping WidgetDataResponseHandler) -> URLSessionDataTask? {
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters["action"] = "fetchDeskModuleDetails" as AnyObject
        parameters["searchType"] = ZOSSearchAPIClient.ServiceNameConstants.Desk as AnyObject
        parameters["portalId"] = portalID as AnyObject
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.ServiceWidgetData, parameters: parameters as [String:AnyObject]) { (widgetData, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForWidgetDataResp(nil, error)
            } else {
                completionHandlerForWidgetDataResp(widgetData, nil)
            }
        }
        return task
    }
    
    //TODO: code to be merged
    func getMailFolders(oAuthToken: String, emailID: String, completionHandlerForWidgetDataResp: @escaping WidgetDataResponseHandler) -> URLSessionDataTask? {
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters["action"] = "fetchMailFolderDetails" as AnyObject
        parameters["searchType"] = ZOSSearchAPIClient.ServiceNameConstants.Mail as AnyObject
        parameters["emailid"] = emailID as AnyObject
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.ServiceWidgetData, parameters: parameters as [String:AnyObject]) { (widgetData, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForWidgetDataResp(nil, error)
            } else {
                completionHandlerForWidgetDataResp(widgetData, nil)
            }
        }
        return task
    }
    
    //TODO: code to be merged
    func getMailTags(oAuthToken: String, emailID: String, completionHandlerForWidgetDataResp: @escaping WidgetDataResponseHandler) -> URLSessionDataTask? {
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters["action"] = "fetchMailLabelDetails" as AnyObject
        parameters["searchType"] = ZOSSearchAPIClient.ServiceNameConstants.Mail as AnyObject
        parameters["emailid"] = emailID as AnyObject
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.ServiceWidgetData, parameters: parameters as [String:AnyObject]) { (widgetData, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForWidgetDataResp(nil, error)
            } else {
                completionHandlerForWidgetDataResp(widgetData, nil)
            }
        }
        return task
    }
    
    func getUserContacts(type: String, oAuthToken: String, start: Int16, fetchSize: Int16, completionHandlerForContactsResp: @escaping ContactsResponseHandler) -> URLSessionDataTask? {
        
        // Specify Contacts request parameters
        var parameters = [String: AnyObject]()
        parameters["action"] = type as AnyObject
        parameters["start"] = start as AnyObject
        parameters["limit"] = fetchSize as AnyObject
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.ServiceWidgetData, parameters: parameters as [String:AnyObject]) { (contacts, error) in
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForContactsResp(nil, error)
            } else {
                completionHandlerForContactsResp(contacts, nil)
            }
        }
        return task
    }
    
    /*
    //fetch contacts 500 personal and 500 org contacts
    func getUserContacts(pathExtn: String, oAuthToken: String, pageIndex: Int16, fetchSize: Int16, completionHandlerForContactsResp: @escaping ContactsResponseHandler) -> URLSessionDataTask? {
        
        // Specify Contacts request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.ContactsAPIParamKeys.PageIndex] = pageIndex as AnyObject
        parameters[ZOSSearchAPIClient.ContactsAPIParamKeys.PerPageCount] = fetchSize as AnyObject
        parameters[ZOSSearchAPIClient.ContactsAPIParamKeys.SortBy] = ZOSSearchAPIClient.ContactsAPIParamValues.SortByUsageCountDescending as AnyObject
        parameters[ZOSSearchAPIClient.ContactsAPIParamKeys.IncludeFields] = ZOSSearchAPIClient.ContactsAPIParamValues.NeededFields as AnyObject
        
        // Create the request
        let task = taskForGETContactsMethod(oAuthToken, method: pathExtn, parameters: parameters) { (contacts, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForContactsResp(nil, error)
            } else {
                completionHandlerForContactsResp(contacts, nil)
            }
        }
        return task
    }
    */
    
    //TODO: zuid must be Int64 not Int
    func getPeopleInOutStatus(oAuthToken: String, zuid: Int, completionHandlerForWidgetDataResp: @escaping WidgetDataResponseHandler) -> URLSessionDataTask? {
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters["action"] = "fetchUserAvailability" as AnyObject
        parameters["searchType"] = ZOSSearchAPIClient.ServiceNameConstants.People as AnyObject
        parameters["zuid"] = zuid as AnyObject
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.ServiceWidgetData, parameters: parameters as [String:AnyObject]) { (widgetData, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForWidgetDataResp(nil, error)
            } else {
                completionHandlerForWidgetDataResp(widgetData, nil)
            }
        }
        return task
    }
    
    
    //MARK: load more logic, later will think to merge with search method
    func loadMoreSearchResultsForService(_ searchString: String, mentionedZUID: Int64?, filters: [String: AnyObject]?, oAuthToken: String, serviceName: String, startIndex: Int, numOfResults:Int, completionHandlerForSearchResp: @escaping ServiceSearchResultsHandler) -> URLSessionDataTask? {
        
        // Specify search request parameters
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.SearchParameterKeys.Query] = searchString as AnyObject
        parameters[ZOSSearchAPIClient.SearchParameterKeys.ServiceList] = serviceName as AnyObject
        parameters[ZOSSearchAPIClient.SearchParameterKeys.SearchType] = serviceName as AnyObject
        parameters[ZOSSearchAPIClient.SearchParameterKeys.IsScroll] = "true" as AnyObject
        parameters[ZOSSearchAPIClient.SearchParameterKeys.StartIndex] = startIndex as AnyObject
        parameters[ZOSSearchAPIClient.SearchParameterKeys.NumberOfResults] = numOfResults as AnyObject
        
        if mentionedZUID != nil, mentionedZUID != -1 {
            parameters[ZOSSearchAPIClient.SearchParameterKeys.MentionedZUID] = mentionedZUID as AnyObject
        }
        
        if let searchFilters = filters {
            //create JSON from the dictionary of filters
            let filterJSON = try? JSONSerialization.data(withJSONObject: searchFilters, options: [])
            let jsonString = String(data: filterJSON!, encoding: .utf8)
            parameters[ZOSSearchAPIClient.FilterParameterKeys.Filters] = jsonString as AnyObject
        }
        
        // Create the request
        let task = taskForGETMethod(oAuthToken, method: APIPaths.Search, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            // Send the search responce or error to completion handler
            if let error = error {
                completionHandlerForSearchResp(nil, error)
            } else {
                if let response = results?[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [String: AnyObject] {
                    if let chatResp = response[serviceName] as? [String:AnyObject] {
                        if let results = chatResp[ZOSSearchAPIClient.SearchResponseJSONKeys.SearchResults] as? [[String:AnyObject]] {
                            //code will be simple with abstraction
                            var searchResults:[SearchResult]? = nil
                            //use constants for service names
                            if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Cliq) {
                                searchResults = ChatResult.chatResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail) {
                                searchResults = MailResult.mailResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect) {
                                searchResults = ConnectResult.connectResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.People) {
                                searchResults = PeopleResult.peopleResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Contacts) {
                                searchResults = ContactsResult.contactsResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Documents) {
                                searchResults = DocsResult.docsResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Crm) {
                                searchResults = CRMResult.crmResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk) {
                                searchResults = SupportResult.supportResultsFromResponse(results)
                            }
                            else if (serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
                                searchResults = WikiResult.wikiResultsFromResponse(results)
                            }
                            
                            //send search results with completion handler
                            completionHandlerForSearchResp(searchResults, nil)
                        } else {
                            completionHandlerForSearchResp(nil, NSError(domain: "getChatsForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse search response"]))
                        }
                    }
                }
            }
        }
        return task
    }
    
    // create a URL from parameters
    func contactsImageURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        //var components = URLComponents()
        //components.scheme = ZOSSearchAPIClient.ContactsPhotoAPI.ApiScheme
        //components.host = ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.contactsServerHost
        
        let transformedURL = ZohoSearchKit.sharedInstance().getTransformedURL((ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.contactsServerHost)!)
        var components = URLComponents(string: transformedURL)
        
        components?.path = ZOSSearchAPIClient.ContactsPhotoAPI.ApiPath + (withPathExtension ?? "")
        components?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components?.queryItems!.append(queryItem)
        }
        
        return (components?.url)!
    }
    
}
