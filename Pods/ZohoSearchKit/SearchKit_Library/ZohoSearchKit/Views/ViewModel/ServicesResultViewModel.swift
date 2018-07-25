//
//  ServicesResultViewModel.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

//each will becomes one section in the all search page(UITableView)
//Cliq/Chat Result View Model Item
class ChatResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.cliq", defaultValue: "Cliq")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .chatResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Cliq
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, chatResults: [SearchResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = chatResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//Mail Result View Model Item
class MailResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.mail", defaultValue: "Mail")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .mailResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Mail
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, mailResults: [MailResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = mailResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//Docs Result View Model Item
class DocsResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.docs", defaultValue: "Docs")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .docsResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Documents
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, docsResults: [DocsResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = docsResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//People Result View Model Item
class PeopleResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.people", defaultValue: "People")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .peopleResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.People
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, peopleResults: [PeopleResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = peopleResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//People Result View Model Item
class ContactsResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.contacts", defaultValue: "Contacts")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .contactsResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Contacts
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, contactsResults: [ContactsResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = contactsResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//Connect Result View Model Item
class ConnectResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.connect", defaultValue: "Connect")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .connectResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Connect
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, connectResults: [ConnectResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = connectResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//CRM Result View Model Item
class CRMResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.crm", defaultValue: "CRM")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .crmResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Crm
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, crmResults: [CRMResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = crmResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//People Result View Model Item
class DeskResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.desk", defaultValue: "Desk")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .deskResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Desk
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, supportResults: [SupportResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = supportResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

//Wiki Result View Model Item
class WikiResultsViewModel: ServiceResultViewModel {
    
    var sectionTitle: String {
        return SearchKitUtil.getLocalizedString(i18nKey: "searchkit.servicedisplayname.wiki", defaultValue: "Wiki")
    }
    
    var rowCount: Int {
        return searchResults.count
    }
    
    var type: SearchResultsType {
        return .wikiResult
    }
    
    var serviceName: String {
        return ZOSSearchAPIClient.ServiceNameConstants.Wiki
    }
    
    var viewAllShown = true
    var searchQuery: String
    var searchResults: [SearchResult]
    var searchResultsMetaData: SearchResultsMetaData?
    var hasMoreResults: Bool = false
    
    init(searchQuery: String, wikiResults: [WikiResult], hasMoreResults: Bool, resultMetaData: SearchResultsMetaData?) {
        self.searchQuery = searchQuery
        self.searchResults = wikiResults
        self.hasMoreResults = hasMoreResults
        self.searchResultsMetaData = resultMetaData
    }
}

