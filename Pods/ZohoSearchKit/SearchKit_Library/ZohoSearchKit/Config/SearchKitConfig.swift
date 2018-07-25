//
//  SearchKitConfig.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 15/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

//could be singletone as only instance of this will exist
@objc open class SearchKitConfig : NSObject {
    private var _authAdapter: ZOSAuthAdapter?
    //private var _buildType: ZOSBuildType = .Live
    private var _searchKitCustPListFile: String = "Info.plist"
    private var snackBarActionButtonColor = SearchKitConstants.ColorConstants.SnackbarActionButtonColor
    
    private var _searchKitURLConfig: SearchKitURLConfig?
    private var _searchResultUIConfig: SearchKitResultUIConfig?
    private var _searchCalloutUIConfig: SearchKitCalloutUIConfig?
    
    var searchKitURLConfig: SearchKitURLConfig? {
        get {
            return _searchKitURLConfig
        }
        set(newValue) {
            _searchKitURLConfig = newValue
        }
    }
    
    var searchResultUIConfig: SearchKitResultUIConfig? {
        get {
            return _searchResultUIConfig
        }
        set(newValue) {
            _searchResultUIConfig = newValue
        }
    }
    
    var searchCalloutUIConfig: SearchKitCalloutUIConfig? {
        get {
            return _searchCalloutUIConfig
        }
        set(newValue) {
            _searchCalloutUIConfig = newValue
        }
    }
    
    override public init() {
        _authAdapter = nil
    }
    
    @objc public func setAuthAdapter(_ authAdapter: ZOSAuthAdapter) -> Void {
        self._authAdapter = authAdapter
    }
    
    @objc public func getAuthAdapter() -> ZOSAuthAdapter? {
        return _authAdapter
    }
    
    @objc public func setPListFileNameForSearchKit(_ pListFileName: String) -> Void {
        self._searchKitCustPListFile = pListFileName
    }
    
    @objc public func getPListFileNameForSearchKit() -> String? {
        return _searchKitCustPListFile
    }
    
    func setSnackbarActionButtonColor(color: UIColor) -> Void {
        snackBarActionButtonColor = color
    }
    
    func getSnackbarActionButtonColor() -> UIColor {
        return snackBarActionButtonColor
    }
    
    /*
     
    */
    
    //TODO: Later we will support oauth scope fetching even feature wise. So, that developer can
    //request scope needed for limited functionality or full functionality.
    //goal unwanted scopes must not be used if not needed while generating oauth scopes.
    @objc static public func getRequiredOAuthScopes(services: [String]) -> [String] {
        guard services.count > 0 else {
            fatalError("There must be atleast one service configured")
        }
        
        var searchSDKScopes = [String]()
        var resourceFileDictionary: NSDictionary?
        
        //Load content of Info.plist into resourceFileDictionary dictionary
        if let path = ZohoSearchKit.frameworkBundle.path(forResource: "ServiceScopes", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let resourceFileDictionaryContent = resourceFileDictionary {
            
            //first add search service scopes
            if let searchScopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.SearchServiceOAuthScopesKey) as? [String] {
                for scope in searchScopes {
                    searchSDKScopes.append(scope)
                }
            }
            
            var serviceList = services
            if services.count == 1, services[0].lowercased() == ZOSSearchAPIClient.ServiceNameConstants.All {
                serviceList = getSupportedServices(configDictionary: resourceFileDictionaryContent)
            }
            for service in serviceList {
                var serviceScopes =  [String]()
                switch service {
                case ZOSSearchAPIClient.ServiceNameConstants.Mail:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.MailServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.CliqServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Documents:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.DocsServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.ContactsServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.People:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.PeopleServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Connect:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.ConnectServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Crm:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.CRMServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Desk:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.DeskServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
                    if let scopes = resourceFileDictionaryContent.object(forKey: SearchKitConfigKeys.WikiServiceOAuthScopesKey) as? [String] {
                        serviceScopes = scopes
                    }
                default:
                    print("No such service configured")
                }
                
                for scope in serviceScopes {
                    searchSDKScopes.append(scope)
                }
            }
        }
        
        return searchSDKScopes
    }
    
    fileprivate static func getSupportedServices(configDictionary: NSDictionary) -> [String] {
        var supportedServices = [String]()
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Mail)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Cliq)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Documents)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Contacts)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.People)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Connect)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Crm)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Desk)
//        supportedServices.append(ZOSSearchAPIClient.ServiceNameConstants.Wiki)
        
        if let services = configDictionary.object(forKey: SearchKitConfigKeys.SearchKitSupportedServicesKey) as? [String] {
            supportedServices = services
        }
        
        return supportedServices
    }
    
    /*
     @objc public func setBuildType(_ buildType: ZOSBuildType) -> Void {
     self._buildType = buildType
     }
     
     @objc public func getBuildType() -> ZOSBuildType? {
     return _buildType
     }
     */
    
}
