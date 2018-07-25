//
//  SearchKitUtil.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 10/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class SearchKitUtil {
    static func getLocalizedString(i18nKey: String, defaultValue: String) -> String {
        //ZohoSearchKit is the name of .strings file. If that file name changes, make sure to update here as well
        return NSLocalizedString(i18nKey, tableName: "ZohoSearchKit", bundle: ZohoSearchKit.frameworkBundle, value: defaultValue, comment: defaultValue)
    }
    static func getServiceDisplayName(serviceName: String) -> String {
        var serviceDisplayName = ""
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.All:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.all", defaultValue: "All")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.mails", defaultValue: "Mail")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.chat", defaultValue: "Cliq")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.personalContacts", defaultValue: "Contacts")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.people", defaultValue: "People")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.connect", defaultValue: "Connect")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.documents", defaultValue: "Docs")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.crm", defaultValue: "CRM")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.support", defaultValue: "Desk")
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.wiki", defaultValue: "Wiki")
        case ZOSSearchAPIClient.ServiceNameConstants.Reports:
            serviceDisplayName = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.reports", defaultValue: "Reports")
            break
        default:
            serviceDisplayName = ""
        }
        return serviceDisplayName
    }
    
    static func getServiceNameForCell(cell: UITableViewCell) -> String {
        var serviceName = ""
        if cell is ChatResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Cliq
        }
        else if cell is MailResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Mail
        }
        else if cell is ContactsResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Contacts
        }
        else if cell is PeopleResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.People
        }
        else if cell is ConnectResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Connect
        }
        else if cell is DocsResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Documents
        }
        else if cell is DeskResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Desk
        }
        else if cell is CRMResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Crm
        }
        else if cell is WikiResultViewCell {
            serviceName = ZOSSearchAPIClient.ServiceNameConstants.Wiki
        }
        
        return serviceName
    }
    
    static func generateIconText(inputStr: String) -> String {
        var iconText = ""
        let words = inputStr.components(separatedBy: " ")
        if (words.count > 1) {
            iconText = String(words[0].prefix(1)) + String(words[1].prefix(1))
        }
        else {
            //first two chars
            iconText = String(words[0].prefix(2))
        }
        //icons text will be uppercased
        return iconText.uppercased()
    }
}
//filters
//extension SearchKitUtil
//{
//    static func getMailSearchInFilters() -> [String]
//    {
//        let FilterDataDictionary :[String : Any] = GetFilterPropertylistData.getFilterData()
//        let searchFilter_i18nKeys : [String] = FilterDataDictionary["searchkit_mail_filter"] as! [String]
//        var SearchInFilters : [String] = [String]()
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: searchFilter_i18nKeys[0], defaultValue: "Entire Message"))
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Mail.Module.SUBJECT", defaultValue: "Subject"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Mail.CONTENT", defaultValue: "Content"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Mail.ATTACHMENT_NAME", defaultValue: "Attachment Name"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Mail.ATTACHMENT_CONTENT", defaultValue: "Attachment Content"))
//
//
//        return SearchInFilters
//    }
//    static func getSortByFilters() -> [String]
//    {
//        var SearchInFilters : [String] = [String]()
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Sort.SORT_BY_TIME", defaultValue: "Time"))
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.Sort.SORT_BY_RELAVANCE", defaultValue: "Relavance"))
//        return SearchInFilters
//    }
//    static func getDateFilterRanges() -> [String]
//    {
//        var SearchInFilters : [String] = [String]()
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.ALLDAYS", defaultValue: "All Days"))
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.TODAY", defaultValue: "Today"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.YESTERDAY", defaultValue: "Yesterday"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.LAST_7_DAYS", defaultValue: "Last 7 Days"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.THIS_MONTH", defaultValue: "This month"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.THIS_YEAR", defaultValue: "This year"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.SPECIFIC_DATE", defaultValue: "Specific date"))
//
//        SearchInFilters.append(SearchKitUtil.getLocalizedString(i18nKey: "searchkit.Filters.DateRange.CUSTOM_DATE", defaultValue: "Custom date"))
//        return SearchInFilters
//    }
//
//}
