//
//  FilterData.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/04/18.
//

import Foundation

class FilterData {
    //internal key and display value
    var isSelected: Bool = false
    var filterKey: String //as in some cases it is not just integer like allfolders, alltags etc
    var filterValue: String
    var extraInfo: [String: String]? //in case of date range filter this will be used to store from and to value
    
    init?(filterKey: String, filterValue: String) {
        self.filterKey = filterKey
        self.filterValue = filterValue
    }
    
    init?(filterKey: String, filterValue: String, isSelected: Bool) {
        self.filterKey = filterKey
        self.filterValue = filterValue
        self.isSelected = isSelected
    }
    
    init?(filterKey: String, extraInfo: [String: String]) {
        self.filterKey = filterKey
        self.filterValue = filterKey //in this case filterkey and value will have the same value
        self.extraInfo = extraInfo
    }
    
    init?(filterKey: String, extraInfo: [String: String], isSelected: Bool) {
        self.filterKey = filterKey
        self.filterValue = filterKey //in this case filterkey and value will have the same value
        self.extraInfo = extraInfo
        self.isSelected = isSelected
    }
    
}
