//
//  NSObject+Reflection.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 08/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension NSObject {
    static func classForName(_ className: String) -> AnyClass! {
        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        
        /// get 'anyClass' with classname and namespace
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!;
        
        // return AnyClass!
        return cls;
    }
}
