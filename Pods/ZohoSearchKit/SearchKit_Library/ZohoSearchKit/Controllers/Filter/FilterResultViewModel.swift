//
//  FilterResultViewModel.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 05/03/18.
//

protocol FilterResultViewModel {
    var serviceName: String { get }
    var filtersCount : Int { get }
    var type: SearchResultsType { get }
    var filtersResultArray: [FilterModule] { get }
    var filterSearchQuery : [String : AnyObject]? {get set}
}
class FilterModule {
    var filterViewType : FilterType? = nil
    var filterName : String? = nil
    var filterServerKey : String? = nil
    // for dropDown list view filters
    var selectedFilterServerValue : String? = nil
    var selectedFilterName : String? = nil
    var defaultSelectionName : String? = nil
    var defaultSelectionServerValue : String? = nil
    var defaultSelectionServerValue_2 : String? = nil
    var filterServerKey_2 : String? = nil
    var selectedFilterServerValue_2 : String? = nil
    var searchResults : [String]?
    var filtersBackUp : [String]?
    var filterNameServerValuePairs : [String : String]?
    var isDropViewExpanded : Bool = false
    
    // Only used for Sort By filters
    var sortByFilterDefultIndex = 0
    var sortBYFIlterSelectedIndex = 0
    // Check Box Flag
    var CheckBoxDefaultStatus = false
    var CheckBoxSelectedStatus = false
    
}

enum FilterType {
    case dropDownView
    case segmentedView
    case flagView
}



