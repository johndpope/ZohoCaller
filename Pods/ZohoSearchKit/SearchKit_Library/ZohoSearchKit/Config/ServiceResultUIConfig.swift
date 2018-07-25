//
//  ServiceResultUIConfig.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class ServiceResultUIConfig {
    var _fieldVsUIConfig: [String : FieldUIConfig] = [:]
    
    var fieldsUIConfig: [String : FieldUIConfig] {
        get {
            return _fieldVsUIConfig
        }
        set(newValue) {
            _fieldVsUIConfig = newValue
        }
    }
    
    func addFieldUIConfig(fieldName: String, fieldUIConfig: FieldUIConfig) -> Void{
        self._fieldVsUIConfig[fieldName] = fieldUIConfig
    }
    
    func getFieldUIConfig(withIdentifier: String) -> FieldUIConfig? {
        return self._fieldVsUIConfig[withIdentifier]
    }
}
