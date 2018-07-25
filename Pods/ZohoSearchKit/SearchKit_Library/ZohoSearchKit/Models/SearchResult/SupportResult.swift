//
//  SupportResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - SupportResult

class SupportResult: SearchResult {
    
    // MARK: Properties
    let entID: Int64
    let orgID: Int64
    let moduleID: Int
    let createdTime: Int64
    let departmentID: Int64?
    let title: String?
    let subtitle1: String?
    let subtitle2: String?
    let phone: String?
    let mobile: String?
    let email: String?
    let mode: String?
    
    // MARK: Initializers
    
    // construct a ConnectResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        entID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.EntityID] as! Int64
        
        let orgIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.OrgID] as! String
        orgID = Int64(orgIDStr)!
        let moduleIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.ModuleID] as! String
        moduleID = Int(moduleIDStr)!
        //TODO:- for some result createdTime is nil .we have to handle it.
        let createdTimeStr :String = {
            if dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.CreatedTime] != nil
            {
                return (dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.CreatedTime] as! String)
            }
            else
            {
                return "0"
            }
        }()
        createdTime =  Int64(createdTimeStr)!
        if let depIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.DepartmentID] as? String {
            departmentID = Int64(depIDStr)
        }
        else {
            departmentID = nil
        }
        
        //TODO: Some fields like solution name title and all should be HTML decoded
        if moduleID == 1 {
            if let titleStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.CaseSubject] as? String, titleStr.isEmpty == false {
                title = titleStr;
            } else {
                title = ""
            }
            
            if let contactNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.ContactName] as? String, contactNameStr.isEmpty == false {
                subtitle1 = contactNameStr;
            } else {
                subtitle1 = ""
            }
            
            if let statusStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Status] as? String, statusStr.isEmpty == false {
                subtitle2 = statusStr;
            } else {
                subtitle2 = ""
            }
        }
        else if moduleID == 2 {
            if let titleStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.SolutionTitle] as? String, titleStr.isEmpty == false {
                title = titleStr;
            } else {
                title = ""
            }
            
            if let topicNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.TopicName] as? String, topicNameStr.isEmpty == false {
                subtitle1 = topicNameStr;
            } else {
                subtitle1 = ""
            }
            
            if let statusStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Status] as? String, statusStr.isEmpty == false {
                subtitle2 = statusStr;
            } else {
                subtitle2 = ""
            }
        }
        else if moduleID == 3 {
            if let contactNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.ContactName] as? String, contactNameStr.isEmpty == false {
                title = contactNameStr;
            } else {
                title = ""
            }
            
            if let emailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Email] as? String, emailStr.isEmpty == false {
                subtitle1 = emailStr;
            } else {
                subtitle1 = ""
            }
            
            if let phoneStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Phone] as? String, phoneStr.isEmpty == false {
                subtitle2 = phoneStr;
            } else {
                subtitle2 = ""
            }
        }
        else if moduleID == 4 {
            if let accountNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.AccountName] as? String, accountNameStr.isEmpty == false {
                title = accountNameStr;
            } else {
                title = ""
            }
            
            if let emailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Email] as? String, emailStr.isEmpty == false {
                subtitle1 = emailStr;
            } else {
                subtitle1 = ""
            }
            
            if let phoneStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Phone] as? String, phoneStr.isEmpty == false {
                subtitle2 = phoneStr;
            } else {
                subtitle2 = ""
            }
        }
        else {
            title = ""
            subtitle1 = ""
            subtitle2 = ""
        }
        
        //Duplicated code could be a simple method, which check for the value, decodes html and sets the value
        //to the property passed
        if let mobileNumberStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.MobileNumber] as? String, mobileNumberStr.isEmpty == false {
            mobile = mobileNumberStr;
        } else {
            mobile = ""
        }
        
        //mobile number itself
        if let phoneNumberStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.MobileNumber] as? String, phoneNumberStr.isEmpty == false {
            phone = phoneNumberStr;
        } else {
            phone = ""
        }
        
        if let emailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ContactsSearchResult.EmailAddress] as? String, emailStr.isEmpty == false {
            email = emailStr;
        } else {
            email = ""
        }
        
        if let modeName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.DeskSearchResult.Mode] as? String, modeName.isEmpty == false {
            mode = modeName
        }
        else {
            mode = nil
        }
        
        super.init(entityID: String(entID))
    }
    
    static func supportResultsFromResponse(_ results: [[String:AnyObject]]) -> [SupportResult] {
        
        var supportResults = [SupportResult]()
        
        // iterate through array of dictionaries, each SupportResult is a dictionary
        for result in results {
            supportResults.append(SupportResult(dictionary: result))
        }
        
        return supportResults
    }
}

//to translate the module id to module name that to be used
extension SupportResult {
    func getModuleName() -> String {
        switch moduleID {
        case 1:
            return "tickets"
        case 2:
            return "solutions"
        case 3:
            return "contacts"
        case 4:
            return "accounts"
        default:
            return ""
        }
    }
}

// MARK: - SupportResult: Equatable

extension SupportResult: Equatable {}

func ==(lhs: SupportResult, rhs: SupportResult) -> Bool {
    return lhs.entityID == rhs.entityID
}

