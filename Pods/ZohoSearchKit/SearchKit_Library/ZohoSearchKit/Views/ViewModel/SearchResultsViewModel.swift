////
////  SearchResultsViewModel.swift
////  ZohoSearchAppTwo
////
////  Created by hemant kumar s. on 27/12/17.
////  Copyright © 2017 hemant kumar s. All rights reserved.
////


import Foundation
import UIKit

/*
 protocol ResultViewModelDelegate: class {
 func didFinishUpdates()
 }
 */

class SearchResultsViewModel: NSObject {
    
    static  var serviceSections = [String: ServiceResultViewModel]()
    //weak var delegate: ResultViewModelDelegate?
    static var serviceSearchStatus = [String: Date]()
    
    static   var reloadSections: ((_ section: Int) -> Void)?
    static var searchFilters : [String: AnyObject]?

    static var selected_service : Int = 0
    static var selectedService: String = ZOSSearchAPIClient.ServiceNameConstants.All
    static var UserPrefOrder : [TableViewController]  {
        get{
        var viewcontrollers = [TableViewController]()
        var serviceVsChildVC = [String: TableViewController]()
        let child_1 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.All),serviceName: ZOSSearchAPIClient.ServiceNameConstants.All))
        let child_2 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Contacts), serviceName: ZOSSearchAPIClient.ServiceNameConstants.Contacts))
        let child_3 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.People),serviceName: ZOSSearchAPIClient.ServiceNameConstants.People))
        
        let child_4 = TableViewController(style: .plain, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Mail),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Mail))
        
        let child_5 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq))
        
        let child_6 = TableViewController(style: .plain, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Connect),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Connect))
        
        let child_7 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Documents),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Documents))
        let child_8 = TableViewController(style: .grouped, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Crm),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Crm))
        
        let child_9 = TableViewController(style: .plain, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Desk),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Desk))
        
        let child_10 = TableViewController(style: .plain, itemInfo: IndicatorInfo(title: SearchKitUtil.getServiceDisplayName(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Wiki),serviceName: ZOSSearchAPIClient.ServiceNameConstants.Wiki))
        
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.All] = child_1
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Contacts] = child_2
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.People] = child_3
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Mail] = child_4
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Cliq] = child_5
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Connect] = child_6
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Documents] = child_7
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Crm] = child_8
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Desk] = child_9
        serviceVsChildVC[ZOSSearchAPIClient.ServiceNameConstants.Wiki] = child_10
        
        if let preferredServiceOrder = UserPrefManager.getOrderedServiceListForUser() {
            for service in preferredServiceOrder {
                if let vc = serviceVsChildVC[service] {
                    viewcontrollers.append(vc)
                }
            }
        }
        else {
            viewcontrollers = [child_1, child_2,child_3,child_4,child_5,child_6,child_7,child_8,child_9,child_10]
        }
        
        return viewcontrollers
        }
        set{
            
        }
    }
    override init() {
        super.init()
    }
    // contact-search
    struct QueryVC {
        static var suggestionContactName = String()
        static var suggestionPageSearchText = String()
        static var suggestionZUID : Int64? = -1
        static var isAtMensionSelected = false
        static var isNamelabledisplay : Bool = false
        
        static var isSuggestionServiceIconTapped = false
    }
    struct ResultVC {
        static var contactName = String()
        static var searchText = String()
        static var ZUID : Int64? = -1
        static  var isContactSearch = false
        static var isNamelabledisplay : Bool = false
        
        static var trimmedSearchQuery = String()
        static var isFilterEnabled = false
        static var isNewSearch = false
         static  var searchBarThreshold = 8
    }
    //    static var contact_name = String()
    //Later we will maintain search state service wise and will handle that way
    static var searchWhenLoaded = false
    static var firstTimeSearch = false
    static var isViewControllersAltered = false
    // filter information
    static var FilterSections = [FilterResultViewModel]()
}

//import Foundation
//import UIKit
//
///*
// protocol ResultViewModelDelegate: class {
// func didFinishUpdates()
// }
// */
//
//class SearchResultsViewModel: NSObject {
//    var serviceSections = [ServiceResultViewModel]()
//    //weak var delegate: ResultViewModelDelegate?
//
//    var reloadSections: ((_ section: Int) -> Void)?
//
//    override init() {
//        super.init()
//    }
//
//    /*
//     func loadData() {
//     delegate?.didFinishUpdates()
//     }
//     */
//}
//
////Extension to comply UITableViewDataSource as part of UITableView - table sections and row
//extension SearchResultsViewModel: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return serviceSections.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let item = serviceSections[section]
//        guard item.hasHiddenResults else {
//            return item.rowCount
//        }
//
//        if item.viewAllShown {
//            //number of results that need to be shown in the All page can be exported to property file
//            if (item.rowCount > 3) {
//                return 3
//            }
//            else {
////                return item.rowCount
//                return item.rowCount + 1
//            }
//        } else {
////            return item.rowCount
//            //number of results + 1 row for the last load more row.
//            //Later this will become loading icon or if end of result it will become no more results for the section
//            return item.rowCount + 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = serviceSections[indexPath.section]
//        switch item.type {
//        case .chatResult:
//            if let item = item as? ChatResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: ChatResultViewCell.identifier, for: indexPath) as? ChatResultViewCell {
//                        let chat = item.searchResults[indexPath.row]
//                        cell.searchResultItem = chat as? ChatResult
//                        return cell
//                    }
//                }
//
//            }
//            /*
//             if let item = item as? ChatResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: ChatResultViewCell.identifier, for: indexPath) as? ChatResultViewCell {
//             let chat = item.searchResults[indexPath.row]
//             cell.searchResultItem = chat as? ChatResult
//             return cell
//             }*/
//        case .mailResult:
//
//            if let item = item as? MailResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: MailResultViewCell.identifier, for: indexPath) as? MailResultViewCell {
//                        let mail = item.searchResults[indexPath.row]
//                        cell.item = mail as? MailResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? MailResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: MailResultViewCell.identifier, for: indexPath) as? MailResultViewCell {
//             let mail = item.searchResults[indexPath.row]
//             cell.item = mail as? MailResult
//             return cell
//             }
//             */
//        case .docsResult:
//
//            if let item = item as? DocsResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: DocsResultViewCell.identifier, for: indexPath) as? DocsResultViewCell  {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? DocsResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? DocsResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: DocsResultViewCell.identifier, for: indexPath) as? DocsResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? DocsResult
//             return cell
//             }
//             */
//        case .peopleResult:
//
//            if let item = item as? PeopleResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: PeopleResultViewCell.identifier, for: indexPath) as? PeopleResultViewCell {
//                        let people = item.searchResults[indexPath.row]
//                        cell.item = people as? PeopleResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? PeopleResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: PeopleResultViewCell.identifier, for: indexPath) as? PeopleResultViewCell {
//             let people = item.searchResults[indexPath.row]
//             cell.item = people as? PeopleResult
//             return cell
//             }
//             */
//        case .contactsResult:
//
//            if let item = item as? ContactsResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: ContactsResultViewCell.identifier, for: indexPath) as? ContactsResultViewCell {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? ContactsResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? ContactsResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: ContactsResultViewCell.identifier, for: indexPath) as? ContactsResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? ContactsResult
//             return cell
//             }
//             */
//        case .connectResult:
//
//            if let item = item as? ConnectResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: ConnectResultViewCell.identifier, for: indexPath) as? ConnectResultViewCell {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? ConnectResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? ConnectResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: ConnectResultViewCell.identifier, for: indexPath) as? ConnectResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? ConnectResult
//             return cell
//             }
//             */
//        case .crmResult:
//
//            if let item = item as? CRMResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: CRMResultViewCell.identifier, for: indexPath) as? CRMResultViewCell {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? CRMResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? CRMResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: CRMResultViewCell.identifier, for: indexPath) as? CRMResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? CRMResult
//             return cell
//             }
//             */
//        case .deskResult:
//
//            if let item = item as? DeskResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: DeskResultViewCell.identifier, for: indexPath) as? DeskResultViewCell {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? SupportResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? DeskResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: DeskResultViewCell.identifier, for: indexPath) as? DeskResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? SupportResult
//             return cell
//             }
//             */
//        case .wikiResult:
//
//            if let item = item as? WikiResultsViewModel {
//
//                //Make sure it must not impact the usual flow of scrolling - very very important
//                //aynchronously send request and let the current flow work
//                //load more automatically - just before 5 less results, if the user scrolls fast
//                //it will show loading icon or no more results if no more results are there.
//                /*
//                 if (indexPath.row == item.searchResults.count - 5)
//                 {
//                 if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                 self.loadMoreResults(header: footerView, section: indexPath.section)
//                 }
//                 }
//                 */
//
//                //if requesting the last cell
//                if (indexPath.row == item.searchResults.count) {
//                    if let footerView = tableView.dequeueReusableCell(withIdentifier: PseudoServiceFooterCell.identifier) as? PseudoServiceFooterCell {
//                        footerView.item = item
//                        footerView.section = indexPath.section
//                        footerView.delegate = self
//                        return footerView
//                    }
//                }
//                else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: WikiResultViewCell.identifier, for: indexPath) as? WikiResultViewCell {
//                        let doc = item.searchResults[indexPath.row]
//                        cell.item = doc as? WikiResult
//                        return cell
//                    }
//                }
//            }
//
//            /*
//             if let item = item as? WikiResultsViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: WikiResultViewCell.identifier, for: indexPath) as? WikiResultViewCell {
//             let doc = item.searchResults[indexPath.row]
//             cell.item = doc as? WikiResult
//             return cell
//             }
//             */
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = serviceSections[indexPath.section]
//        let serviceName = item.serviceName
//
//        if (serviceName == "chat") {
//            let chatResult = item.searchResults[indexPath.row] as? ChatResult
//            ZohoAppsDeepLinkUtil.openInChatApp(chatID: (chatResult?.chatID)!)
//        }
//        else if (serviceName == "connect") {
//
//            //with https it will not work
//            //https:// should be truncated from the result's url
//            //openInConnectApp(connectUrl: "https://connect.zoho.com/portal/intranet/stream/105000183773677")
//
//            //indexPath.row this will give row id in that section
//            let connectResult = item.searchResults[indexPath.row] as? ConnectResult
//            var connectFeedUrl = connectResult?.postURL
//            connectFeedUrl = connectFeedUrl?.replacingOccurrences(of: "https://", with: "", options: .literal, range: nil)
//
//            //openInConnectApp(connectUrl: "connect.zoho.com/portal/intranet/stream/105000183773677")
//            ZohoAppsDeepLinkUtil.openInConnectApp(connectUrl: connectFeedUrl!)
//        }
//        else if (serviceName == "documents") {
//            let docResult = item.searchResults[indexPath.row] as? DocsResult
//            //using web browser based redirection
//            //openInDocsApp(docsFileID: "1ss172f2215f5eda14e2588174909cb739b1c")
//            ZohoAppsDeepLinkUtil.openInDocsApp(docsFileID: (docResult?.docID)!)
//        }
//        else if (serviceName == "mails") {
//            //SnackbarUtils.showMessageWithDismiss(msg: "Mail preview is not supported!")
//            let mailResult = item.searchResults[indexPath.row] as? MailResult
//            ZohoAppsDeepLinkUtil.openInMailApp(messageID: (mailResult?.messageID)!)
//        }
//        else if (serviceName == "support") {
//            let deskResult = item.searchResults[indexPath.row] as? SupportResult
//            if (deskResult?.moduleID == 1 || deskResult?.moduleID == 3) {
//                ZohoAppsDeepLinkUtil.openInDeskApp(moduleName: (deskResult?.getModuleName())!, entityID: (deskResult?.entID)!, portalID: (deskResult?.orgID)!)
//            }
//            else {
//                SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
//            }
//        }
//        else if (serviceName == "crm") {
//            let crmResult = item.searchResults[indexPath.row] as? CRMResult
//            //Only Leads and Contacts module is supported right now
//            if (crmResult?.moduleName == "Leads" || crmResult?.moduleName == "Contacts") {
//                ZohoAppsDeepLinkUtil.openInCRMApp(moduleName: (crmResult?.moduleName)!, recordID: (crmResult?.entID)!, zuid: SearchViewController.currentUserZUID)
//            }
//            else {
//                SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
//            }
//        }
//        else if (serviceName == "people") {
//            let peopleResult = item.searchResults[indexPath.row] as? PeopleResult
//            ZohoAppsDeepLinkUtil.openInPeopleApp(emailID: (peopleResult?.email)!)
//        }
//        else if (serviceName == "personalContacts") {
//            SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
//        }
//        else if (serviceName == "wiki") {
//            SnackbarUtils.showMessageWithDismiss(msg: SearchKitUtil.getLocalizedString(i18nKey: "searchkit.snackbar.previewnotsupported", defaultValue: "Preview is not supported!"))
//        }
//
//        //deselect at the end, so that it does remain selected on app switch
//        if let index = tableView.indexPathForSelectedRow{
//            tableView.deselectRow(at: index, animated: true)
//        }
//    }
//
//}
//
////Extension to comply UITableViewDelegate as part of UITableView - Header and Footer
////header view
//extension SearchResultsViewModel: UITableViewDelegate {
//
//    //header's height
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//
//    //header view
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServiceHeaderCell.identifier) as? ServiceHeaderCell {
//            let item = serviceSections[section]
//
//            headerView.item = item
//            headerView.section = section
//            headerView.delegate = self
//            return headerView
//        }
//        return UIView()
//    }
//
//    /*
//    //footer view - we are now using actual cell as footer
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let item = serviceSections[section]
//        //so that load more is shown only when view all is expanded
//        if !item.viewAllShown {
//            return 40.0
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServiceFooterCell.identifier) as? ServiceFooterCell {
//            let item = serviceSections[section]
//
//            headerView.item = item
//            headerView.section = section
//            headerView.delegate = self
//            return headerView
//        }
//        return UIView()
//    }
//    */
//
//}
//
////view all delegate
//extension SearchResultsViewModel: HeaderViewDelegate {
//    func toggleSection(header: ServiceHeaderCell, section: Int) {
//        var item = serviceSections[section]
//        if item.hasHiddenResults {
//
//            // Toggle collapse
//            let collapsed = !item.viewAllShown
//            item.viewAllShown = collapsed
//            header.setCollapsed(collapsed: collapsed)
//
//            // Adjust the number of the rows inside the section
//            reloadSections?(section)
//        }
//    }
//}
//
////TODO: if there is no more results, we must have handling for the end of result section
////Load more is enabled only for chat right now, as we are using custom cell now
////for other services we will add later.
////load more search results for the section delegate
////extension SearchResultsViewModel: FooterViewDelegate {
//extension SearchResultsViewModel: FooterViewDelegate1 {
//
//    //func loadMoreResults(header: ServiceFooterCell, section: Int) {
//    func loadMoreResults(header: PseudoServiceFooterCell, section: Int) {
//        let numOfResultsReq = 25
//        var item = serviceSections[section]
//        var searchTask: URLSessionDataTask?
//
//        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
//            if let oAuthToken = token {
//                searchTask = ZOSSearchAPIClient.sharedInstance().loadMoreSearchResultsForService(item.searchQuery, oAuthToken: oAuthToken, serviceName: item.serviceName, startIndex: item.searchResults.count, numOfResults: numOfResultsReq) { (searchResults, error) in
//
//                    //error should be nil
//                    if error == nil {
//
//                        if let searchResults = searchResults, searchResults.count > 0 {
//                            //Add the search results to the section
//                            for searchResult in searchResults {
//                                item.searchResults.append(searchResult)
//                            }
//
//                            //We should have check whether more results are there in the server before loading
//                            //this means server have no more results
//                            if (searchResults.count < numOfResultsReq) {
//                                //hence set flag to hide load mpre by setting height to 0
//                            }
//
//                            //This could be common code
//                            // Adjust the number of the rows inside the section
//                            performUIUpdatesOnMain {
//                                self.reloadSections?(section)
//                            }
//                        }
//
//                        /*
//                         //this should be coming from the constants
//                         if (item.serviceName == "chat") {
//                         //when abstraction is used properly
//                         //this code block will become much better
//                         if let chatResults = searchResults, chatResults.count > 0 {
//                         let currentItem = item as! ChatResultsViewModel
//                         for chatResult in chatResults {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //this means server have no more results
//                         if (chatResults.count < numOfResultsReq) {
//                         //hence set flag to hide load mpre by setting height to 0
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "mails") {
//                         if let chatResults = searchResults {
//                         let chats: [MailResult] = chatResults as! [MailResult]
//                         let currentItem = item as! MailResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "documents") {
//                         if let chatResults = searchResults {
//                         let chats: [DocsResult] = chatResults as! [DocsResult]
//                         let currentItem = item as! DocsResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "personalContacts") {
//                         if let chatResults = searchResults {
//                         let chats: [ContactsResult] = chatResults as! [ContactsResult]
//                         let currentItem = item as! ContactsResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "connect") {
//                         if let chatResults = searchResults {
//                         let chats: [ConnectResult] = chatResults as! [ConnectResult]
//                         let currentItem = item as! ConnectResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "people") {
//                         if let chatResults = searchResults {
//                         let chats: [PeopleResult] = chatResults as! [PeopleResult]
//                         let currentItem = item as! PeopleResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "support") {
//                         if let chatResults = searchResults {
//                         let chats: [SupportResult] = chatResults as! [SupportResult]
//                         let currentItem = item as! DeskResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "crm") {
//                         if let chatResults = searchResults {
//                         let chats: [CRMResult] = chatResults as! [CRMResult]
//                         let currentItem = item as! CRMResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         else if (item.serviceName == "wiki") {
//                         if let chatResults = searchResults {
//                         let chats: [WikiResult] = chatResults as! [WikiResult]
//                         let currentItem = item as! WikiResultsViewModel
//                         for chatResult in chats {
//                         currentItem.searchResults.append(chatResult)
//                         }
//
//                         //This could be common code
//                         // Adjust the number of the rows inside the section
//                         performUIUpdatesOnMain {
//                         self.reloadSections?(section)
//                         }
//                         }
//                         }
//                         */
//
//                    }
//                }
//            }
//        })
//
//    }
//}

