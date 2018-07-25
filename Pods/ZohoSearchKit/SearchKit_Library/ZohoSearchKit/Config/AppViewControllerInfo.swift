//
//  AppViewControllerInfo.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

@objc open class AppViewControllerInfo : NSObject {
    private var _storyBoardName: String? = "Main"
    private var _viewControllerIdentifier: String?
    
    @objc public var storyBoardName: String? {
        get {
            return _storyBoardName
        }
        set(newValue) {
            _storyBoardName = newValue
        }
    }
    
    @objc public var viewControllerIdentifier: String? {
        get {
            return _viewControllerIdentifier
        }
        set(newValue) {
            _viewControllerIdentifier = newValue
        }
    }
}
