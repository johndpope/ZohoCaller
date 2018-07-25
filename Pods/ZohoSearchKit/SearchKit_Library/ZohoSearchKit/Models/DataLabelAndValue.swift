//
//  DataLabelAndValue.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 24/04/18.
//

import Foundation

class DataLabelAndValue {
    let dataLabel: String
    let dataValue: String
    
    init(labelText: String, valueText: String) {
        self.dataLabel = labelText
        self.dataValue = valueText
    }
}

extension Array where Element:DataLabelAndValue {
    func vauleFor(key : String) -> String?
    {
        for element in self
        {
            if element.dataLabel == key
            {
                return element.dataValue
            }
        }
        return nil
    }
}
