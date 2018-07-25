//
//  ZOSCurrentUser.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 08/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

/// Current logged in user details like zuid, email, display name and photo url.
/// Developers must provide these details by extending AuthAdapter
open class ZOSCurrentUser {
    
    //for now this is string
    let zuid: String
    let email: String
    let displayName: String
    let photoURL: String?
    
    public init(zuid: String, email: String, displayName: String, photoURL: String ) {
        self.zuid = zuid
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }
    
}
