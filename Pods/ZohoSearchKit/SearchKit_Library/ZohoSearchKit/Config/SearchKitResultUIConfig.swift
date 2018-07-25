//
//  SearchKitResultUIConfig.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 18/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

//Currently we have all services search result title as black and all other fields as dark gray.
//we are separating each result fields for each service, so that if the developer wants to customize the color
//they can easily customize for the intended services as they prefer

//could be singletone as only instance of this will exist
class SearchKitResultUIConfig {
    
    private var _serviceNameVsResultUIConfig: [String: ServiceResultUIConfig] = [:]
    
    var serviceNameVsResultUIConfig: [String : ServiceResultUIConfig] {
        get {
            return _serviceNameVsResultUIConfig
        }
        set(newValue) {
            _serviceNameVsResultUIConfig = newValue
        }
    }
    
    func addServiceUIConfig(serviceName: String, fieldUIConfig: ServiceResultUIConfig) -> Void{
        self._serviceNameVsResultUIConfig[serviceName] = fieldUIConfig
    }
    
    func getServiceUIConfig(forServiceName: String) -> ServiceResultUIConfig? {
        return self._serviceNameVsResultUIConfig[forServiceName]
    }
    
}
