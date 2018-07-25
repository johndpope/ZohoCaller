//
//  Date+Timestamp.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

//Sample Usage -
//Date().millisecondsSince1970 // 1476889390939
//Date(milliseconds: 0) // "Dec 31, 1969, 4:00 PM" (PDT variant of 1970 UTC)
