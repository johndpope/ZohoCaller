//
//  SearchQueryDataUtil.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/04/18.
//

import Foundation

class SearchQueryDataUtil {
    
    fileprivate struct JSONKeyConstants {
        static let SearchQuery = "query"
        static let MentionZUID = "mentionZUID"
        static let MentionUserName = "mentionUserName"
        static let Filters = "filters"
        static let FilterType = "type"
        static let FilterValue = "value"
        static let FromDate = "from_date"
        static let ToDate = "to_date"
    }
    
    //SearchQuery can be one object where we store the full state
    class func getSearchQueryStateAsJSON(searchQueryState: SearchQueryState) -> String {
        
        var jsonDictionary = [String: AnyObject]()
        //no need to store the search query if it is empty, while decoding empty query will be returned if not set
        if searchQueryState.searchQuery.isEmpty == false {
            jsonDictionary[JSONKeyConstants.SearchQuery] = searchQueryState.searchQuery as AnyObject
        }
        
        if searchQueryState.mentionZUID != -1 {
            jsonDictionary[JSONKeyConstants.MentionZUID] = searchQueryState.mentionZUID as AnyObject
            jsonDictionary[JSONKeyConstants.MentionUserName] = searchQueryState.mentionedUserName as AnyObject
        }
        
        //sort info is also stored and passed as filter only
        if searchQueryState.filters.count != 0 {
            var filterArray = [[String: String]]()
            //only in case of date range we have to read extra info
            for (filterName, filter) in searchQueryState.filters {
                var filterJSON = [String: String]()
                filterJSON[JSONKeyConstants.FilterType] = filterName
                filterJSON[JSONKeyConstants.FilterValue] = filter.filterKey
                
                if filterName == "date_range" {
                    if filter.filterKey == "specific_date" || filter.filterKey == "custom_date_range" {
                        filterJSON[JSONKeyConstants.FromDate] =  filter.extraInfo?[JSONKeyConstants.FromDate]
                        filterJSON[JSONKeyConstants.ToDate] = filter.extraInfo?[JSONKeyConstants.ToDate]
                    }
                }
                
                filterArray.append(filterJSON)
            }
            
            jsonDictionary[JSONKeyConstants.Filters] = filterArray as AnyObject
        }
        
        let filterJSONSerialized = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        let jsonString = String(data: filterJSONSerialized!, encoding: .utf8)
        
        return jsonString!
    }
    
    class func getSearchQueryStateFromJSON() -> SearchQueryState {
        
        //temp code
        return SearchQueryState(queryString: "hi")!
    }
}
