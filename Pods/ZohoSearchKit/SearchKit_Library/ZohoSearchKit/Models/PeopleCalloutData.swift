//
//  PeopleCalloutData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class PeopleCalloutData {
    var openInAppSupported: Bool? = false
    var imageURL: String?
    var imageName: String?
    var title: String
    var keyValuePairs = [RowData]()
    var openInAppData = [String : String]()
    var openInAppType: PeopleOpenInAppTypes?
    
    init(withTitle title: String) {
        self.title = title
    }
}

enum PeopleOpenInAppTypes {
    case People
}

