//
//  ServiceViceFilterViewModal.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 05/03/18.
//

import Foundation

class MailFilterResultViewModal: FilterResultViewModel {
    
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Mail
    }
    
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    var type: SearchResultsType {
        return .mailResult
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}
class CLiqFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Cliq
    }
    var type: SearchResultsType {
        return .chatResult
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}

class DocsFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Documents
    }
    var type: SearchResultsType {
        return .docsResult
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}
class WikiFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var type: SearchResultsType {
        return .wikiResult
    }
    
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Wiki
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}
class ConnectFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var type: SearchResultsType {
        return .connectResult
    }
    
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Connect
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}
class DeskFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var type: SearchResultsType {
        return .deskResult
    }
    
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Desk
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}

class CRMFilterResultViewModal: FilterResultViewModel {
    var filterSearchQuery: [String : AnyObject]? =
    {
        return [String:AnyObject]()
        
    }()
    var type: SearchResultsType {
        return .crmResult
    }
    
    var serviceName: String
    {
        return  ZOSSearchAPIClient.ServiceNameConstants.Crm
    }
    
    var filtersCount: Int {
        return filtersResultArray.count
    }
    
    var filtersResultArray: [FilterModule]
    
    init(filters : [FilterModule]) {
        self.filtersResultArray = filters
    }
}



