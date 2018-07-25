//
//  PeopleResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - PeopleResult

class PeopleResult: SearchResult {
    
    // MARK: Properties
    let peopleID: String
    let empID: String
    let zuid: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let extn: String?
    let photoURL: String
//    let gender: String?
    let mobile: String?
    let departmentName: String?
    let location: String?
    let designation: String?
    var isSameOrg: Bool? = false
    var reportingTo : String?
    let teamMailID : String?
    // MARK: Initializers
    
    // construct a ConnectResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        peopleID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.PeopleID] as! String
        empID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.EmployeedID] as! String
        let zuidStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.Zuid] as? String
        zuid = Int(zuidStr!)
        photoURL = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.PhotoURL] as! String
        if let isSameOrgStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.IsSameOrg] as? String {
            isSameOrg = Bool(isSameOrgStr)
        }
        
        //Some fields has to be HTML decoded
        if let firstNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.FirstName] as? String, firstNameStr.isEmpty == false {
            firstName = firstNameStr.decodedHTMLEntities();
        } else {
            firstName = ""
        }
        
        //Duplicated code could be a simple method, which check for the value, decodes html and sets the value
        //to the property passed
        if let lastNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.LastName] as? String, lastNameStr.isEmpty == false {
            lastName = lastNameStr.decodedHTMLEntities();
        } else {
            lastName = ""
        }
        
        if let emailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.EmailAddress] as? String, emailStr.isEmpty == false {
            email = emailStr;
        } else {
            email = ""
        }
        
        if let extnStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.Extension] as? String, extnStr.isEmpty == false {
            extn = extnStr;
        } else {
            extn = ""
        }
        //MARK :- Gender value is removed from search response
//
//        if let genderStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.Gender] as? String, genderStr.isEmpty == false {
//            gender = genderStr;
//        } else {
//            gender = ""
//        }
//
        if let mobileStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.MobileNumber] as? String, mobileStr.isEmpty == false {
            mobile = mobileStr;
        } else {
            mobile = ""
        }
        
        if let departmentNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.DepartmentName] as? String, departmentNameStr.isEmpty == false {
            departmentName = departmentNameStr.decodedHTMLEntities();
        } else {
            departmentName = ""
        }
        
        if let locationStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.Location] as? String, locationStr.isEmpty == false {
            location = locationStr;
        } else {
            location = ""
        }
        
        if let designationStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.DesignationName] as? String, designationStr.isEmpty == false {
            designation = designationStr.decodedHTMLEntities();
        } else {
            designation = ""
        }
        if let reportingToFname = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.ReportingFirstName] as? String, reportingToFname.isEmpty == false
        {
            self.reportingTo = reportingToFname
             if let reportingToLname = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.ReportingLastName] as? String, reportingToLname.isEmpty == false
             {
                self.reportingTo = reportingTo! + " " + (reportingToLname)
             }
        }
        else if let reportingToLname = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.ReportingLastName] as? String, reportingToLname.isEmpty == false
        {
            self.reportingTo = reportingToLname
        }
        else
        {
            self.reportingTo = ""
        }
        if let teamMail = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.PeopleSearchResult.TeamMailID] as? String, teamMail.isEmpty == false
        {
            teamMailID = teamMail
        }
        else
        {
            teamMailID = ""
        }
        super.init(entityID: peopleID)
        
    }
    
    static func peopleResultsFromResponse(_ results: [[String:AnyObject]]) -> [PeopleResult] {
        
        var peopleResults = [PeopleResult]()
        
        // iterate through array of dictionaries, each PeopleResult is a dictionary
        for result in results {
            peopleResults.append(PeopleResult(dictionary: result))
        }
        
        return peopleResults
    }
}

// MARK: - PeopleResult: Equatable

extension PeopleResult: Equatable {}

func ==(lhs: PeopleResult, rhs: PeopleResult) -> Bool {
    return lhs.peopleID == rhs.peopleID
}

