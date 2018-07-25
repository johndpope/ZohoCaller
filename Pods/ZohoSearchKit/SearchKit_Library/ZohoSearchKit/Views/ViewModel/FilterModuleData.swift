//
//  FilterModuleData.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/05/18.
//

import Foundation
import CoreData

extension String
{
    func  getLastSubString(separator : String) -> String
    {
        return self.components(separatedBy: separator).last ?? ""
    }
    func createI18NKeyByAppendingNew(feild  : String) ->String
    {
        return ( self + "." + feild)
    }
}
class FilterModuleData {
    var filters : [FilterModule] = [FilterModule]()
    init(servicename : String) {
        switch servicename {
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            createMailFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            createCliqtFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            createConnectFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            createDocsFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            createCrmFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            createDeskFilterData()
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            createWikiFilterData()
        default:
            break
        }
    }
    func  createWikiFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            
            if let deskDataDictionary : [String : Any] = FilterConstants.Values.Wiki.WikiDataDictionary
            {
                var currentSelectedWikiTypeIndex = -1 //MARK:- -1 means there are no wikis
                for i18Nkey in FilterConstants.i18NKeys.wiki.moduleOrder
                {
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    switch i18Nkey{
                    case FilterConstants.i18NKeys.wiki.Modules.wikitype:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Wiki.loadPlistfile(withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Wiki.MY_WIKI)
                        // MARK:- If mywiki or subscribed wiki dont have any portals then we no need to show it in wikitypes
                        let beforeDeletionFilterCount = filterNames.count
                        for (index ,wikiname) in filterNames.enumerated()
                        {
                            let wikitypeIndex = Int(filterNameServerValuePairs[wikiname]!)! // eg :- 0-mywiki,1-subscribed wiki
                            if let mywikiPortals = ResultVCSearchBar.fetchWikiPortals(wikiType: wikitypeIndex)
                            {
                                if mywikiPortals.count == 0
                                {
                                    if beforeDeletionFilterCount == filterNames.count
                                    {
                                        filterNames.remove(at: index)
                                        filterNameServerValuePairs.removeValue(forKey: wikiname)
                                    }
                                    else
                                    {
                                        let numberOfDeletions = beforeDeletionFilterCount - filterNames.count
                                        filterNames.remove(at: index - numberOfDeletions)
                                        filterNameServerValuePairs.removeValue(forKey: wikiname)
                                    }
                                }
                            }
                        }
                        //MARK:- we have to change the default selectin index becauses we are deleting some values in wikis
                        if let _ = filterNames.first{
                            defaultName = filterNames.first!
                            defaultValue = filterNameServerValuePairs[defaultName]!
                            if let wikitypeId = Int(defaultValue)
                            {
                                currentSelectedWikiTypeIndex = wikitypeId
                            }
                        }
                        else
                        {
                            defaultName = "No Wikis"
                            currentSelectedWikiTypeIndex = -1 // -1 means there are no wikis
                        }
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.WikiModules.Wiki_Types)
                        let moduleKey :String? = nil //MARK:- we dont send it to server, If it's marked as nil
                        // Creating Filter module
                        let  wikiFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(wikiFilter)
                        
                    case FilterConstants.i18NKeys.wiki.Modules.portals:
                        
                        // portals doesn't have any data in plist file
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Wiki.loadPlistfile(withModulei18Nkey: FilterConstants.i18NKeys.wiki.Modules.portals, defaulti18NName: FilterConstants.DisPlayValues.Wiki.MY_WIKI)
                        //0 - my wiki and 1 - subscribed wiki
                        //At first my Wiki will be selected in wiki type
                        // In portal we have to check my wiki is available or not?
                        // If it's not available then we have to deselect my wiki in wiki type and select subscribed wikis
                        // MARK:- fetching my wiki from data base
                        if currentSelectedWikiTypeIndex == -1
                        {
                            defaultName = "No Portals"
                        }
                        else if let mywikiPortals = ResultVCSearchBar.fetchWikiPortals(wikiType: currentSelectedWikiTypeIndex) {
                            if mywikiPortals.count != 0 // if no my wiki skip My Wiki and make Subscribe wiki as default one
                            {
                                for portal in mywikiPortals {
                                    filterNames.append(portal.wiki_name!)
                                    filterNameServerValuePairs[portal.wiki_name!] =
                                        String(portal.wiki_id)
                                    if portal.is_default {
                                        defaultName = portal.wiki_name!
                                        defaultValue = String(portal.wiki_id)
                                    }
                                }
                            }
                        }
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.Modules.portals, defaultValue: FilterConstants.Module.WikiModules.Portals)
                        let moduleKey :String? = FilterConstants.i18NKeys.wiki.Modules.portals.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  portalwikiFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(portalwikiFilter)
                        
                    case FilterConstants.i18NKeys.wiki.Modules.sort:
                        filters.append(createSortByFilter())
                    case FilterConstants.i18NKeys.wiki.Modules.date:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Wiki.loadPlistfile(withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Date.ALL_DAYS)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.WikiModules.DATE)
                        let moduleKey :String? = nil //MARK:- we dont send it to server if it is all days
                        // Creating Filter module
                        let  dateFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(dateFilter)
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    func createDeskFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            var defaultPortslId : Int64?
            if let deskDataDictionary : [String : Any] = FilterConstants.Values.Desk.DeskDataDictionary
            {
                for i18Nkey in FilterConstants.i18NKeys.desk.moduleOrder
                {
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    
                    switch i18Nkey{
                    case FilterConstants.i18NKeys.desk.Modules.portals:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Desk.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Desk.All_MODULES)
                        
                        if let deskPortals = ResultVCSearchBar.fetchDeskPortals() {
                            for portal in deskPortals {
                                filterNames.append(portal.portal_name!)
                                filterNameServerValuePairs[portal.portal_name!] =
                                    String(portal.portal_id)
                                
                                if portal.is_default {
                                    defaultName = portal.portal_name!
                                    defaultValue = String(portal.portal_id)
                                    defaultPortslId = portal.portal_id
                                }
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.DeskModules.PORTAL)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  moduleFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(moduleFilter)
                    case FilterConstants.i18NKeys.desk.Modules.department:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Desk.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Desk.All_MODULES)
                        
                        if let deskDepartments = ResultVCSearchBar.fetchDeskDepartmentsForPortal(portalID: defaultPortslId!) {
                            for department in deskDepartments {
                                filterNames.append(department.dept_name!)
                                filterNameServerValuePairs[department.dept_name!] =
                                    String(department.dept_id)
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.DeskModules.DEPARTMENT)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  moduleFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(moduleFilter)
                    case FilterConstants.i18NKeys.desk.Modules.modules:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Desk.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Desk.All_MODULES)
                        
                        if let deskModules = ResultVCSearchBar.fetchDeskModulesForPortal(portalID: defaultPortslId!) {
                            for module in deskModules {
                                filterNames.append(module.module_name!)
                                filterNameServerValuePairs[module.module_name!] =
                                    String(module.module_id)
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.DeskModules.MODULES)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  moduleFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(moduleFilter)
                    case FilterConstants.i18NKeys.desk.Modules.sort:
                        //MARK:- Sort By FIlter
                        filters.append(createSortByFilter())
                    default:
                        break
                    }
                }
            }
        }
        
    }
    func createCrmFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            if let docsDataDictionary : [String : Any] = FilterConstants.Values.Crm.CrmDataDictionary
            {
                for i18Nkey in FilterConstants.i18NKeys.crm.moduleOrder
                {
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    switch i18Nkey{
                    case FilterConstants.i18NKeys.crm.Modules.modules:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Crm.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.CRM.All_MODULES)
                        
                        //fetching Modules from data base
                        if let crmModules = ResultVCSearchBar.fetchCRMModules() {
                            for module in crmModules {
                                filterNames.append(module.module_display_name!)
                                filterNameServerValuePairs[module.module_display_name!] =
                                    module.module_query_name
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.CRMModules.MODULES)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  moduleFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(moduleFilter)
                    default:
                        break
                    }
                }
            }
        }
    }
    func createDocsFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            if let docsDataDictionary : [String : Any] = FilterConstants.Values.Docs.docsDataDictionary
            {
                for i18Nkey in FilterConstants.i18NKeys.docs.moduleOrder
                {
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    switch i18Nkey{
                    case FilterConstants.i18NKeys.docs.Modules.ownertype:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Docs.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Docs.Types.ALL_FILES)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.DocsModules.OWN_TYPE)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  searchInFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(searchInFilter)
                    case FilterConstants.i18NKeys.docs.Modules.searchin:
                        // All the details are loaded from plist file
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Docs.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Docs.SearchIn.ALL_TYPES)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.DocsModules.SEARCH_IN)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  searchInFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(searchInFilter)
                    case FilterConstants.i18NKeys.docs.Modules.sort:
                        //MARK:- Sort By FIlter
                        filters.append(createSortByFilter())
                    default:
                        break
                    }
                }
                
            }
        }
    }
    func createConnectFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            if let connectDataDictionary : [String : Any] = FilterConstants.Values.Connect.connectDataDictionary
            {
                for i18Nkey in FilterConstants.i18NKeys.connect.moduleOrder
                {
                    
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    switch i18Nkey {
                    case FilterConstants.i18NKeys.connect.Modules.portals:
                        if   let connectPortals = ResultVCSearchBar.fetchConnectPortals()
                        {
                            for portal in connectPortals
                            {
                                filterNames.append(portal.portal_name!)
                                filterNameServerValuePairs[portal.portal_name!] =
                                    String(portal.portal_id)
                                if (portal.is_default) {
                                    defaultName = portal.portal_name!
                                    defaultValue = String(portal.portal_id)
                                    
                                }
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.ConnectModules.PORTAL)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating account  Filter module
                        let  connectFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(connectFilter)
                    case  FilterConstants.i18NKeys.connect.Modules.searchin:
                        // All the details are loaded from plist file
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Connect.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Connect.FEEDS)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.ConnectModules.SEARCH_IN)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  searchInFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(searchInFilter)
                    case FilterConstants.i18NKeys.connect.Modules.sort:
                        //MARK:- Sort By FIlter
                        filters.append(createSortByFilter())
                    case FilterConstants.i18NKeys.connect.Modules.date:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Connect.loadPlistfile(withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Date.ALL_DAYS)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.CliqModules.DATE)
                        let moduleKey :String? = nil //MARK:- we dont send it to server if it is all days
                        // Creating Filter module
                        let  dateFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(dateFilter)
                    default:
                        break
                        
                    }
                }
            }
        }
        
    }
    func createCliqtFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            if let cliqDataDictionary : [String : Any] = FilterConstants.Values.Cliq.cliqDataDictionary
            {
                for i18Nkey in FilterConstants.i18NKeys.cliq.moduleOrder
                {
                    //MARK:- Date Filters for Cliq
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    switch i18Nkey {
                    case FilterConstants.i18NKeys.cliq.Modules.sort:
                        //MARK:- Sort By FIlter
                        filters.append(createSortByFilter())
                    case FilterConstants.i18NKeys.cliq.Modules.date:
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Cliq.loadPlistfile(withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Date.ALL_DAYS)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.CliqModules.DATE)
                        let moduleKey :String? = nil //MARK:- we dont send it to server if it is all days
                        // Creating Filter module
                        let  dateFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(dateFilter)
                    default:
                        break
                        
                    }
                }
                
            }
        }
    }
    func createMailFilterData()
    {
        if let _ = FilterConstants.Values.resourceFileDictionary
        {
            if let mailDataDictionary : [String : Any] = FilterConstants.Values.Mail.mailDataDictionary
            {
                var defaultAccountEmailId :Int64 = {
                    if   let mailAccounts = ResultVCSearchBar.fetchMailAccounts()
                    {
                        for mailAccount in mailAccounts
                        {
                            if (mailAccount.is_default)
                            {
                                return mailAccount.account_id
                            }
                        }
                    }
                    return 0
                }()
                for i18Nkey in FilterConstants.i18NKeys.mail.moduleOrder
                {
                    var defaultName = String()
                    var defaultValue = String()
                    var filterNames = [String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            
                            if  filterNames.count > 0 && defaultName == String()// to get the first value
                            {
                                defaultName = filterNames.first!
                            }
                        }
                    }
                    var filterNameServerValuePairs = [String : String]()
                    {
                        // assuming :- First value in filternames is default one
                        didSet{
                            if filterNames.count > 0 && defaultValue == String()
                            {
                                defaultValue =  filterNameServerValuePairs[filterNames.first!]!
                            }
                        }
                    }
                    
                    switch i18Nkey
                    {
                    case FilterConstants.i18NKeys.mail.Modules.account:
                        // we dont have data in plist file ,if you added any .use loadplist() function to get it.
                        if   let mailAccounts = ResultVCSearchBar.fetchMailAccounts()
                        {
                            for mailAccount in mailAccounts
                            {
                                //MARK:- For mail filterName Server Value pair will contrain filter name and account id.
                                //server value for account id email id only, but if user changes account we have to restore folders and tags based on account id.So,we can use server value to restore others
                                filterNames.append(mailAccount.email_address!)
                                filterNameServerValuePairs[mailAccount.email_address!] =
                                    String(mailAccount.account_id)
                                if (mailAccount.is_default) {
                                    defaultName = mailAccount.email_address!
                                    defaultValue = String(mailAccount.email_address!)
                                    defaultAccountEmailId = mailAccount.account_id
                                }
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.ACCOUNT)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating account  Filter module
                        let  accountsFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(accountsFilter)
                    case FilterConstants.i18NKeys.mail.Modules.folder:
                        //All Folders is default value in folders
                        //Loading plist file data and server end keys
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Mail.ALL_FOLDERS)
                        //fetching folder from data base
                        if let mailAcntFolders = ResultVCSearchBar.fetchMailFoldersForAccount(mailAccountID: defaultAccountEmailId) {
                            for folder in mailAcntFolders {
                                filterNames.append(folder.folder_name!)
                                filterNameServerValuePairs[folder.folder_name!] =
                                    String(folder.folder_id)
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.FOLDERS)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  folderFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(folderFilter)
                        
                    case FilterConstants.i18NKeys.mail.Modules.tags:
                        //All tags is default one and we are loading it from plist file
                        //Loading plist file data and server end keys
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Mail.ALL_TAGS)
                        // fetching tags from data base
                        if let tags = ResultVCSearchBar.fetchMailTagsForAccount(mailAccountID: defaultAccountEmailId) {
                            for tag in tags {
                                filterNames.append(tag.tag_name!)
                                filterNameServerValuePairs[tag.tag_name!] =
                                    String(tag.tag_id)
                            }
                        }
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.TAGS)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  tagFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(tagFilter)
                        
                    case FilterConstants.i18NKeys.mail.Modules.searchin:
                        // All the details are loaded from plist file
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile( withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Mail.ENTIRE_MESSAGE)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.SEARCH_IN)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        // Creating Filter module
                        let  searchInFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(searchInFilter)
                        
                    case FilterConstants.i18NKeys.mail.Modules.date:
                        // All the details are loaded from plist file
                        (filterNames,filterNameServerValuePairs) = FilterConstants.Values.Mail.loadPlistfile(withModulei18Nkey: i18Nkey, defaulti18NName: FilterConstants.DisPlayValues.Date.ALL_DAYS)
                        // loading filter name and key from localized string
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.DATE)
                        let moduleKey :String? = nil //MARK:- we dont send it to server if it is all days
                        // Creating Filter module
                        let  dateFilter =  createDropDownFilterWith(filtername: filtername, key: moduleKey, defaultName: defaultName, defaultValue: defaultValue, filterNames: filterNames, filternamevaluepairs: filterNameServerValuePairs)
                        filters.append(dateFilter)
                    case FilterConstants.i18NKeys.mail.Modules.hasAttachments:
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.HAS_ATTACHMENT)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        filters.append(createFlagHeaderWith(key: moduleKey, name: filtername))
                        break
                    case FilterConstants.i18NKeys.mail.Modules.hasFlag:
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.HAS_FLAG)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        filters.append(createFlagHeaderWith(key: moduleKey, name: filtername))
                    case FilterConstants.i18NKeys.mail.Modules.hasReplies:
                        let filtername =  SearchKitUtil.getLocalizedString(i18nKey: i18Nkey, defaultValue: FilterConstants.Module.MailModules.HAS_REPLIES)
                        let moduleKey = i18Nkey.getLastSubString(separator: ".")
                        filters.append(createFlagHeaderWith(key: moduleKey, name: filtername))
                    default:
                        break
                    }
                }
            }
        }
    }
}
extension FilterModuleData{
    func createDropDownFilterWith(filtername : String ,key : String? , defaultName : String , defaultValue : String , filterNames : [String],filternamevaluepairs : [String : String]) ->FilterModule
    {
        let filterModule : FilterModule = FilterModule()
        filterModule.filterName = filtername
        filterModule.filterServerKey = key
        filterModule.defaultSelectionName = defaultName
        filterModule.selectedFilterServerValue = defaultValue
        filterModule.defaultSelectionServerValue =  defaultValue
        filterModule.selectedFilterName = filterModule.defaultSelectionName
        filterModule.filterViewType = .dropDownView
        filterModule.isDropViewExpanded = false
        filterModule.searchResults = filterNames
        filterModule.filterNameServerValuePairs = filternamevaluepairs
        filterModule.filtersBackUp = filterModule.searchResults
        return filterModule
    }
    func createSortByFilter() -> FilterModule
    {
        let sortFilter :FilterModule = FilterModule()
        sortFilter.filterName = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.cliq.Modules.sort, defaultValue: FilterConstants.DisPlayValues.SORT_BY)///Display Name same for all service
        sortFilter.filterServerKey = FilterConstants.Keys.SORTBY
        //MARK:- sortby filter is generic for all service ,
        sortFilter.sortByFilterDefultIndex = 0
        sortFilter.sortBYFIlterSelectedIndex = 0
        sortFilter.filterViewType = .segmentedView
        return sortFilter
    }
    func createFlagHeaderWith(key : String , name : String) -> FilterModule
    {
        let flagFilter :FilterModule = FilterModule()
        flagFilter.CheckBoxSelectedStatus = false
        flagFilter.CheckBoxDefaultStatus = false
        flagFilter.filterServerKey  = key
        flagFilter.filterName = name //Display Name same for all service
        //MARK:- sortby filter is generic for all service ,
        flagFilter.filterViewType = .flagView
        return flagFilter
    }
    static func fetchMailAccounts() -> [MailAccounts]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate to handle multiple accounts
        let predicate = NSPredicate(format: #keyPath(MailAccounts.account_zuid) + " == " + SearchKitConstants.FormatStringConstants.String, ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAccounts]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchMailFoldersForAccount(mailAccountID: Int64) -> [MailAcntFolders]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsFolderTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntFolders.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntFolders]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    static func fetchMailTagsForAccount(mailAccountID: Int64) -> [MailAcntTags]? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: SearchKitConstants.CoreDataStackConstants.MailAccountsTagTable, in: (ZohoSearchKit.sharedInstance().coreDataStack?.context)!)
        
        // Add Predicate
        let predicate = NSPredicate(format: #keyPath(MailAcntTags.account_id) + " == " + SearchKitConstants.FormatStringConstants.LongLongUnsignedInt, mailAccountID)
        fetchRequest.predicate = predicate
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try ZohoSearchKit.sharedInstance().coreDataStack?.context.fetch(fetchRequest) as? [MailAcntTags]
            return result
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
}
