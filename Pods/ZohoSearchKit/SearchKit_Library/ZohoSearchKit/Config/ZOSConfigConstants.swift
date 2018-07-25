//
//  ZOSConfigConstants.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 15/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

/// Config Constants for SDK
@objc open class ZOSConfigConstants : NSObject {
    
    //All the OAuth scopes needed for Search SDK
    @available(*, deprecated, message: "Use SearchKitConfig.getRequiredOAuthScopes method to get scopes needed for SearchKit")
    @objc public static let ZOSOAuthScopes = ["zohosearch.searchapi.READ",
                                              "zohosearch.widgetapi.READ",
                                              "zohosearch.calloutapi.READ",
                                              "zohosearch.securesearch.READ",
                                              "zohomail.accounts.READ",
                                              "zohomail.messages.READ",
                                              "zohomail.search.READ",
                                              "zohomail.tags.READ",
                                              "zohomail.folders.READ",
                                              "zohomail.settings.READ",
                                              "zohocrm.settings.modules.READ",
                                              "zohocrm.modules.search.READ",
                                              "zohocrm.modules.leads.READ",
                                              "zohocrm.modules.accounts.READ",
                                              "zohocrm.modules.contacts.READ",
                                              "zohocrm.modules.deals.READ",
                                              "zohocrm.modules.campaigns.READ",
                                              "zohocrm.modules.tasks.READ",
                                              "zohocrm.modules.events.READ",
                                              "zohocrm.modules.calls.READ",
                                              "zohocrm.modules.cases.READ",
                                              "zohocrm.modules.solutions.READ",
                                              "zohocrm.modules.products.READ",
                                              "zohocrm.modules.vendors.READ",
                                              "zohocrm.modules.pricebooks.READ",
                                              "zohocrm.modules.quotes.READ",
                                              "zohocrm.modules.salesorders.READ",
                                              "zohocrm.modules.purchaseorders.READ",
                                              "zohocrm.modules.invoices.READ",
                                              "zohocrm.modules.notes.READ",
                                              "zohocrm.modules.activities.READ",
                                              "zohocrm.modules.custom.READ",
                                              "zohopeople.employee.READ",
                                              "zohopeople.forms.READ",
                                              "zohosupport.basic.READ",
                                              "zohosupport.settings.READ",
                                              "zohosupport.tickets.READ",
                                              "zohosupport.articles.READ",
                                              "zohosupport.contacts.READ",
                                              "zohosupport.tasks.READ",
                                              "zohocontacts.userphoto.READ",
                                              "zohocontacts.contactapi.READ",
                                              "zohocontacts.photoapi.READ",
                                              "zohopulse.networklist.READ",
                                              "zohopulse.feedList.READ",
                                              "zohowiki.wikilist.READ",
                                              "zohowiki.document.READ"
    ]
    
    //configured as constants as config properties will be read
    //only after the SDK initialization and these scopes are needed even before
    //SDK is initialized
    //these can be made fileprivate
    static let SearchServiceOAuthScopes: [String] = ["zohosearch.searchapi.READ",
                                                     "zohosearch.widgetapi.READ",
                                                     "zohosearch.calloutapi.READ",
                                                     "zohosearch.securesearch.READ"]
    static let MailServiceOAuthScopes: [String] = ["zohomail.accounts.READ",
                                                   "zohomail.messages.READ",
                                                   "zohomail.search.READ",
                                                   "zohomail.tags.READ",
                                                   "zohomail.folders.READ",
                                                   "zohomail.settings.READ"]
    static let CliqServiceOAuthScopes: [String] = [String]()
    static let DocServiceOAuthScopes: [String] = [String]()
    static let ContactsServiceOAuthScopes: [String] = ["zohocontacts.userphoto.READ",
                                                       "zohocontacts.contactapi.READ",
                                                       "zohocontacts.photoapi.READ"]
    static let PeopleServiceOAuthScopes: [String] = ["zohopeople.employee.READ",
                                                     "zohopeople.forms.READ"]
    static let ConnectServiceOAuthScopes: [String] = ["zohopulse.networklist.READ",
                                                      "zohopulse.feedList.READ"]
    static let CRMServiceOAuthScopes: [String] = ["zohocrm.settings.modules.READ",
                                                  "zohocrm.modules.search.READ",
                                                  "zohocrm.modules.leads.READ",
                                                  "zohocrm.modules.accounts.READ",
                                                  "zohocrm.modules.contacts.READ",
                                                  "zohocrm.modules.deals.READ",
                                                  "zohocrm.modules.campaigns.READ",
                                                  "zohocrm.modules.tasks.READ",
                                                  "zohocrm.modules.events.READ",
                                                  "zohocrm.modules.calls.READ",
                                                  "zohocrm.modules.cases.READ",
                                                  "zohocrm.modules.solutions.READ",
                                                  "zohocrm.modules.products.READ",
                                                  "zohocrm.modules.vendors.READ",
                                                  "zohocrm.modules.pricebooks.READ",
                                                  "zohocrm.modules.quotes.READ",
                                                  "zohocrm.modules.salesorders.READ",
                                                  "zohocrm.modules.purchaseorders.READ",
                                                  "zohocrm.modules.invoices.READ",
                                                  "zohocrm.modules.notes.READ",
                                                  "zohocrm.modules.activities.READ",
                                                  "zohocrm.modules.custom.READ"]
    static let DeskServiceOAuthScopes: [String] = ["zohosupport.basic.READ",
                                                   "zohosupport.settings.READ",
                                                   "zohosupport.tickets.READ",
                                                   "zohosupport.articles.READ",
                                                   "zohosupport.contacts.READ",
                                                   "zohosupport.tasks.READ"]
    static let WikiServiceOAuthScopes: [String] = ["zohowiki.wikilist.READ",
                                                   "zohowiki.document.READ"]
    
}
