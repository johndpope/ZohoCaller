//
//  SearchAPIClient.swift
//  ZohoSearchApp
//
//  Created by hemant kumar s. on 13/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

public class ZOSSearchAPIClient : NSObject {
    typealias HTTPGetRespHandler = (_ response: AnyObject?, _ error: NSError?) -> Void
    typealias ImageRespHandler = (_ imageData: Data?, _ error: NSError?) -> Void
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // configuration object
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: HTTP GET
    
    func taskForGETMethod(_ oAuthToken: String, method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping HTTPGetRespHandler) -> URLSessionDataTask {
        
        var requestParameters = parameters
        //Append extra parameters - these are stats params, every API endpoint accepts it.
        requestParameters[ZOSSearchAPIClient.AppInfoParamKeys.AppPlatform] = ZOSSearchAPIClient.AppInfoParamValues.AppPlatform as String? as AnyObject
        requestParameters[ZOSSearchAPIClient.AppInfoParamKeys.AppPackage] = ZOSSearchAPIClient.AppInfoParamValues.AppBundleID as String? as AnyObject
        
        //create the mutable request with given parameters and api path
        let request = NSMutableURLRequest(url: searchAPIURLFromParameters(requestParameters, withPathExtension: method))
        
        //MARK: set oAuth token in the header
        request.addValue(ZOSSearchAPIClient.OAuthHeader.OAuthTokenPrefix + oAuthToken, forHTTPHeaderField: ZOSSearchAPIClient.OAuthHeader.AuthHeaderName)
        
        //send the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: HTTP GET
    //This GET can be merged with above, just URL mutating is the difference, contacts does not accept usual extra params we send to the Search API
    
    func taskForGETContactsMethod(_ oAuthToken: String, method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping HTTPGetRespHandler) -> URLSessionDataTask {
        
        //create the mutable request with given parameters and api path
        let request = NSMutableURLRequest(url: contactsAPIURLFromParameters(parameters, withPathExtension: method))
        
        //MARK: set oAuth token in the header
        request.addValue(ZOSSearchAPIClient.OAuthHeader.OAuthTokenPrefix + oAuthToken, forHTTPHeaderField: ZOSSearchAPIClient.OAuthHeader.AuthHeaderName)
        
        //send the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETImage(_ oAuthToken: String, imageURL: URL, completionHandlerForImage: @escaping ImageRespHandler) -> URLSessionTask {
        let request = NSMutableURLRequest(url: imageURL)
        
        //MARK: set oAuth token in the header
       request.addValue(ZOSSearchAPIClient.OAuthHeader.OAuthTokenPrefix + oAuthToken, forHTTPHeaderField: ZOSSearchAPIClient.OAuthHeader.AuthHeaderName)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: HTTPGetRespHandler) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            //print("Search Response \(parsedResult)")
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //old implementation of constructing URL components - search
    /*
    // create a URL from parameters
    private func searchAPIURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ZOSSearchAPIClient.SearchAPI.ApiScheme
        components.host = ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.searchServerHost //ZOSSearchAPIClient.SearchAPI.ApiHost
        components.path = ZOSSearchAPIClient.SearchAPI.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    */
    
    /*
    //old implementation of constructing URL components - contacts
    //here path extension will be either zuid or zoid: https://contacts.zoho.com/api/v1/accounts/123/contacts
    private func contactsAPIURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ZOSSearchAPIClient.ContactsAPI.ApiScheme
        components.host = ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.contactsServerHost
        components.path = ZOSSearchAPIClient.ContactsAPI.ApiPathPrefix + (withPathExtension ?? "") + ZOSSearchAPIClient.ContactsAPI.ApiPathSuffix
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    */
    
    // create a URL from parameters
    private func searchAPIURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        //var components = URLComponents()
        //transformed url will have scheme by default
        //components.scheme = ZOSSearchAPIClient.SearchAPI.ApiScheme
        //components.host = ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.searchServerHost //ZOSSearchAPIClient.SearchAPI.ApiHost
        
        //set host as per user DC
        let transformedURL = ZohoSearchKit.sharedInstance().getTransformedURL((ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.searchServerHost)!)
        var components = URLComponents(string: transformedURL)
        
        components?.path = ZOSSearchAPIClient.SearchAPI.ApiPath + (withPathExtension ?? "")
        components?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components?.queryItems!.append(queryItem)
        }
        
        return components!.url!
    }
    
    //here path extension will be either zuid or zoid: https://contacts.zoho.com/api/v1/accounts/123/contacts
    private func contactsAPIURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        //var components = URLComponents()
        //transformed url will have scheme by default
        //components.scheme = ZOSSearchAPIClient.ContactsAPI.ApiScheme
        //components.host = ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.contactsServerHost
        
        //set host as per the user DC
        let transformedURL = ZohoSearchKit.sharedInstance().getTransformedURL((ZohoSearchKit.sharedInstance().searchKitConfig?.searchKitURLConfig?.contactsServerHost)!)
        var components = URLComponents(string: transformedURL)
        components?.path = ZOSSearchAPIClient.ContactsAPI.ApiPathPrefix + (withPathExtension ?? "") + ZOSSearchAPIClient.ContactsAPI.ApiPathSuffix
        components?.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components?.queryItems!.append(queryItem)
        }
        return (components?.url!)!
    }
    
    // MARK: Shared Instance
    
   public  class func sharedInstance() -> ZOSSearchAPIClient {
        struct Singleton {
            static var sharedInstance = ZOSSearchAPIClient()
        }
        return Singleton.sharedInstance
    }
}
