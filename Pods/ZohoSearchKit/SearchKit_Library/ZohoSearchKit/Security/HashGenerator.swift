//
//  HashGenerator.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 28/06/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import CryptoSwift

class HashGenerator {
    static func getMD5(_ string: String) -> String {
        return string.md5()
    }
}
