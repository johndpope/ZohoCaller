//
//  BuildType.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 15/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

// MARK: For SDK.

/// Zoho Search SDK Build Type, used to point to the correct server url.
///
/// - Local: When set Localzoho urls will be used for the API communications
/// - Live: When set IDC urls will be used for the API communications
enum ZOSBuildType {
    case Local
    case Live
}

@objc public enum SearchKitBuildType: Int {
    case AutoDebug
    case Debug
    case Release
}
