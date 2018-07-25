//
//  BaseResult.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 18/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

public class SearchResult {
    
    // MARK: Properties
    //Currently entity id is marked as String, as some services creates issue with long alone
    //Specially docs results are encrypted one.
    let entityID: String
    
    init(entityID: String) {
        self.entityID = entityID;
    }
}
