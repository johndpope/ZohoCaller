//
//  FilterSearchUtil.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 03/04/18.
//

import Foundation

extension FilterViewController : UITextFieldDelegate ,FilterSelectionDelegate
{
    //TODO: Add the search Logic here
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacementString = string
        var newString = String()
        performUIUpdatesOnMain {
            if replacementString == ""
            {
                //Dont use substring it is deprecated in swift 4
                newString = {
                    var str = String()
                    for (index , char) in textField.text!.enumerated()
                    {
                        if index != (textField.text!.endIndex).encodedOffset
                        {
                            str.append(char)
                        }
                    }
                    return str
                }()
            }
            else
            {
                newString = NSString(string: textField.text!).replacingCharacters(in: range, with: replacementString)
            }
            let section = (textField as! FilterSearchBar).section!
            let (oldCount ,newCount) =  self.UpdateSearchResults(newString: newString, section: section)
            self.tableView.reloadRowsInSection(section: section, oldCount: oldCount, newCount: newCount)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performUIUpdatesOnMain {
            let section = (textField as! FilterSearchBar).section!
            let (oldCount ,newCount) =  self.UpdateSearchResults(newString: textField.text!, section: section)
            self.tableView.reloadRowsInSection(section: section, oldCount: oldCount, newCount: newCount)
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        performUIUpdatesOnMain {
            let section = (textField as! FilterSearchBar).section!
            let (oldCount ,newCount) =  self.UpdateSearchResults(newString: "", section: section)
            self.tableView.reloadRowsInSection(section: section, oldCount: oldCount, newCount: newCount)
        }
        return true
    }
    func UpdateSearchResults(newString : String ,section : Int) ->(oldCount : Int , newCount : Int)
    {
        if newString == ""
        {
            searchText = ""
            isSearchBarEmpty = true
        }
        else
        {
            searchText = ""
            searchText = newString
            isSearchBarEmpty = false
        }
        var oldCount : Int = 0
        var newCount : Int = 0
        if currentFilter.filtersResultArray[section].filterViewType == .dropDownView
        {
            if currentFilter.filtersResultArray[section].isDropViewExpanded == true
            {
                if (currentFilter.filtersResultArray[section].filtersBackUp?.count)! > SearchResultsViewModel.ResultVC.searchBarThreshold// TO insert searchbar in filter list
                {
                    oldCount = (currentFilter.filtersResultArray[section].searchResults?.count)!
                    
                    if newString == ""
                    {
                        currentFilter.filtersResultArray[section].searchResults = currentFilter.filtersResultArray[section].filtersBackUp
                    }
                    else
                    {
                        currentFilter.filtersResultArray[section].searchResults = currentFilter.filtersResultArray[section].filtersBackUp?.filter({
                            name -> Bool in
                            if newString.isEmpty{ return false}
                            return name.lowercased().contains(newString.lowercased())
                        })
                        currentFilter.filtersResultArray[section].searchResults = currentFilter.filtersResultArray[section].searchResults?.sorted(by:
                            { (s1: String, s2: String) -> Bool in return s1.lowercased().first == newString.lowercased().first})
                    }
                    newCount = (currentFilter.filtersResultArray[section].searchResults?.count)!
                }
            }
        }
        return (oldCount , newCount)
    }
    
}


