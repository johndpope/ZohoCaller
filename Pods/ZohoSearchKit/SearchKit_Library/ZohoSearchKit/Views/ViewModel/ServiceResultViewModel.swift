//
//  ServiceResultViewModel.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

protocol ServiceResultViewModel {
    var type: SearchResultsType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
    var serviceName: String { get }
    //later will be moved to common state not to service state
    var searchQuery: String { get }
    
    var searchResults: [SearchResult] { get set }
    var searchResultsMetaData: SearchResultsMetaData? { get set }
    var hasMoreResults: Bool { get set }
    
    //not needed will be removed later - both
    var hasHiddenResults: Bool { get }
    var viewAllShown: Bool { get set }
}

extension ServiceResultViewModel {
    var rowCount: Int {
        return 1
    }
    
    //not needed will be removed later
    var hasHiddenResults: Bool {
        return true
    }
}

