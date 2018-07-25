//
//  CalloutURLProtocol.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 21/06/18.
//

import Foundation

var loadingURLs = Set<String>()

class CalloutURLProtocol: URLProtocol {
    
    class func clearURLs() {
        loadingURLs.removeAll()
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        let absoluteURL = request.url?.absoluteString
        if !loadingURLs.contains(absoluteURL!) {
            if (isTrustedURL(url: absoluteURL!)) {
                loadingURLs.insert(absoluteURL!)
                return true
            }
        }
        
        return false
    }
    
    private class func isTrustedURL(url: String) -> Bool {
        var isTrustd: Bool = false
        //don't check contains with, it will create security hole
        //And add only trusted service urls, otherwise oAuth token will be sent to unknown services
        //added as separate conditional check for known service for readability and maintenance
        
        //connect
        if url.hasPrefix("https://connect.zoho.com/pulse/viewFileApi.do?") || url.hasPrefix("https://connect.zoho.eu/pulse/viewFileApi.do?") {
            isTrustd = true
        }
        //mail
        else if url.hasPrefix("https://zmail.zoho.com/mail/ImageDisplayForMobile?") || url.hasPrefix("https://zmail.zoho.eu/mail/ImageDisplayForMobile?") {
            isTrustd = true
        }
        
        return isTrustd
    }
    
    override func startLoading() {
        // custom response
        let response = URLResponse(url: request.url!, mimeType: "image/png", expectedContentLength: -1, textEncodingName: nil)
        
        if let client = self.client {
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                if let oAuthToken = token {
                    let _ = ZOSSearchAPIClient.sharedInstance().getImageDataForURL((self.request.url?.absoluteString)!, oAuthToken: oAuthToken, completionHandlerForImage: { (data, error) in
                        if let data = data {
                            //send response with image data
                            client.urlProtocol(self, didLoad: data)
                            client.urlProtocolDidFinishLoading(self)
                        }
                        else {
                            client.urlProtocol(self, didFailWithError: error!)
                        }
                    })
                }
            })
        }
    }
    
    override func stopLoading() {
        self.client?.urlProtocolDidFinishLoading(self)
    }
}
