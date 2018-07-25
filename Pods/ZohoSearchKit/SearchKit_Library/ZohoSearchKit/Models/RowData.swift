//
//  RowData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class RowData {
    var rowLabelText: String
    var rowDataText: String = "" //Value field can be nil in that case empty string will be set
    var dataType: RowDataType = RowDataType.RawData
    //RawData is displayed as it is, with not action associated with it
    
    init(withLabelText labelText: String) {
        self.rowLabelText = labelText
    }
}

enum RowDataType {
    case RawData
    case PhoneNumber
    case Email
}
