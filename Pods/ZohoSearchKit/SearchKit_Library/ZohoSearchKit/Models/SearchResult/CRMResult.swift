//
//  CRMResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import UIKit

// MARK: For SDK.

// MARK: - CRMResult

//TODO: View must be dumb. It should not know how to find title subtitle and all.
//All parsing must be done here in the model class.
//like which field will be title, and which one will be subtitle etc.
//html decoding, time format conversion etc.
class CRMResult: SearchResult {
    
    // MARK: Properties
    let entID: Int
    let moduleName: String
    let name: String?
    let callsTitle : String?
    let accountName: String?
    let campaignName: String?
    let solutionTitle: String?
    let caseSubject: String?
    let dealName: String?
    let eventTitle: String?
    let productName: String?
    let status: String?
    let stage: String?
    let solutionNumber: String?
    let crmType: String?
    let email: String?
    let mobile: String?
    let phone: String?
    let notesTitle : String?
    let notesContent : String?
    // MARK: Initializers
    
    // construct a CRMResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        let entIDStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.EntityID] as! String
        entID = Int(entIDStr)!
        moduleName = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.ModuleName] as! String
        
        //name = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.FullName] as? String
        if let fullNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.FullName] as? String, fullNameStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            name = fullNameStr.decodedHTMLEntities();
        } else {
            name = nil
        }
        if let fullNameStr = dictionary[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Calls.Title] as? String, fullNameStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            callsTitle = fullNameStr.decodedHTMLEntities();
        } else {
            callsTitle = "---No Title---"
        }
        if let fullNameStr = dictionary[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Notes.Title] as? String, fullNameStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            notesTitle = fullNameStr.decodedHTMLEntities();
        } else {
            notesTitle = "---No Title---"
        }
        if let fullNameStr = dictionary[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Notes.subTitle] as? String, fullNameStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            notesContent = fullNameStr.decodedHTMLEntities();
        } else {
            notesContent = "---No Content---"
        }
        if let companyStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.AccountName] as? String, companyStr.isEmpty == false {
            // MARK: Name will be HTML decoded
            accountName = companyStr.decodedHTMLEntities();
        } else {
            accountName = nil
        }
        
        if let campaignNameStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.CampaignName] as? String, campaignNameStr.isEmpty == false {
            campaignName = campaignNameStr.decodedHTMLEntities();
        }
        else {
            campaignName = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.SolutionTitle] as? String, valueStr.isEmpty == false {
            solutionTitle = valueStr.decodedHTMLEntities();
        }
        else {
            solutionTitle = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.CaseSubject] as? String, valueStr.isEmpty == false {
            caseSubject = valueStr.decodedHTMLEntities();
        }
        else {
            caseSubject = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.DealName] as? String, valueStr.isEmpty == false {
            dealName = valueStr.decodedHTMLEntities();
        }
        else {
            dealName = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.EventTitle] as? String, valueStr.isEmpty == false {
            eventTitle = valueStr.decodedHTMLEntities();
        }
        else {
            eventTitle = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.ProductName] as? String, valueStr.isEmpty == false {
            productName = valueStr.decodedHTMLEntities();
        }
        else {
            productName = nil
        }
        
        //some of the fields might not need any html entity decoding
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.Status] as? String, valueStr.isEmpty == false {
            status = valueStr.decodedHTMLEntities();
        } else {
            status = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.Stage] as? String, valueStr.isEmpty == false {
            stage = valueStr.decodedHTMLEntities();
        }
        else {
            stage = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.SolutionNumber] as? String, valueStr.isEmpty == false {
            solutionNumber = valueStr
        }
        else {
            solutionNumber = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.CRMType] as? String, valueStr.isEmpty == false {
            crmType = valueStr
        }
        else {
            crmType = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.Email] as? String, valueStr.isEmpty == false {
            email = valueStr
        }
        else {
            email = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.Mobile] as? String, valueStr.isEmpty == false {
            mobile = valueStr
        }
        else {
            mobile = nil
        }
        
        if let valueStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.CRMSearchResult.Phone] as? String, valueStr.isEmpty == false {
            phone = valueStr
        }
        else {
            phone = nil
        }
        
        super.init(entityID: String(entID))
    }
    func getCrmTitleAndSubTitle() -> (String , String)
    {
        var title = ""
        var subtitle = ""
        
        let moduleName = self.moduleName.lowercased()
        //this can be exported as separate method and constants can be exported
        switch (moduleName) {
        case "leads":
            if let titleText = name {
                title = titleText
            }
            
            if let subtitleText = email {
                subtitle = subtitleText
            }
        case "campaigns":
            if let titleText = campaignName {
                title = titleText
            }
            
            if let subtitleText = crmType {
                subtitle = subtitleText
            }
            break
        case "solutions":
            if let titleText = solutionTitle {
                title = titleText
            }
            
            if let subtitleText = solutionNumber {
                subtitle = subtitleText
            }
        case "accounts":
            if let titleText = accountName {
                title = titleText
            }
            if let subtitleText = phone {
                subtitle = subtitleText
            }
            break
        case "contacts" :
            if let titleText = name {
                title = titleText
            }
            
            if let subtitleText = email {
                subtitle = subtitleText
            }
            break
        case "deals":
            if let titleText = dealName {
                title = titleText
            }
            
            if let subtitleText = stage {
                subtitle = subtitleText
            }
            break
        case "events":
            if let titleText = eventTitle {
                title = titleText
            }
            break
        case "calls":
            if let titleText = callsTitle {
                title = titleText
            }
            break
        case "notes":
            if let titleText = notesTitle {
                title = titleText
            }
            if let subtitleText = notesContent {
                subtitle = subtitleText
            }
            
            break
        case "tasks":
            if let titleText = caseSubject {
                title = titleText
            }
            
            if let subtitleText = status {
                subtitle = subtitleText
            }
            break
        case "cases":
            if let titleText = caseSubject {
                title = titleText
            }
            
            if let subtitleText = email {
                subtitle = subtitleText
            }
            break
        case "products":
            if let titleText = productName {
                title = titleText
            }
            break
        default:
            title = ""
            subtitle = ""
        }
        return (title,subtitle)
    }
    static func crmResultsFromResponse(_ results: [[String:AnyObject]]) -> [CRMResult] {
        
        var crmResults = [CRMResult]()
        
        // iterate through array of dictionaries, each CRMResult is a dictionary
        for result in results {
            crmResults.append(CRMResult(dictionary: result))
        }
        
        return crmResults
    }
}

// MARK: - CRMResult: Equatable

extension CRMResult: Equatable {}

func ==(lhs: CRMResult, rhs: CRMResult) -> Bool {
    return lhs.entityID == rhs.entityID
}
