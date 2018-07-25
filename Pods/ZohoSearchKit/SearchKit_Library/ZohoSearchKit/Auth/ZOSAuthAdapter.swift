//
//  ZOSAuthAdapter.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 08/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

/// Auth Adapter with default pseudo implementation to fetch oAuth token.
/// Developer of ZohoSearchKit must extend and override the two functions getOAuthToken and getCurrentUser.
/// OAuth Token generation and refresh will be managed by the App, ZohoSearchKit will request for OAuth Token when needed to interact with Zoho Search API
@objc open class ZOSAuthAdapter : NSObject {
    //public typealias TokenFetchHandler = (_ accessToken: String, _ error: Error?) -> Void
    
    public override init() {
        
    }
    
    open func getOAuthToken(_ tokenCallback: @escaping (_ token: String?, _ error: Error?) -> Void) {
        tokenCallback("", nil)
    }
    
    open func getCurrentUser() -> ZOSCurrentUser {
        return ZOSCurrentUser(zuid: "", email: "", displayName: "", photoURL: "")
    }
    
    open func getTransformedURL(_ url: String) -> String {
        return url;
    }
}
