//
//  FilterConstants.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 29/03/18.
//

import UIKit
class FilterConstants
{
    static func getFilterPListFileData() -> [String : Any]
    {
        if let path =  ZohoSearchKit.frameworkBundle.path(forResource: "FilterProperties", ofType: "plist") {
            
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dic
            }
        }
        return [String : Any]()
    }
    struct i18NKeys{
        struct mail {
            struct Modules {
                static  let account = "searchkit.filters.mail.account.emailId"
                static  let folder = "searchkit.filters.mail.folder.folderId"
                static  let searchin = "searchkit.filters.mail.searchin"
                static  let date = FilterConstants.i18NKeys.date.dateModuleName
                static  let tags = "searchkit.filters.mail.tags.labelId"
                static  let hasAttachments = "searchkit.filters.mail.checkList.hasAtt"
                static  let hasFlag = "searchkit.filters.mail.checkList.hasFlg"
                static  let hasReplies = "searchkit.filters.mail.checkList.hasResp"
            }
            static  let  moduleOrder : [String] =  {
                return [Modules.account,Modules.folder,Modules.searchin,Modules.date,Modules.tags,Modules.hasAttachments,Modules.hasFlag,Modules.hasReplies]
            }()
            struct SearchIn {
                static  let entireMessage = "searchkit.filters.mail.searchin.entire"
                static  let subject = "searchkit.filters.mail.searchin.subject"
                static  let content = "searchkit.filters.mail.searchin.content"
                static  let attName = "searchkit.filters.mail.searchin.attname"
                static  let attContent = "searchkit.filters.mail.searchin.attcontent"
            }
            struct Tags {
                 static  let allTags = "searchkit.filters.mail.tags.labelId.alltags"
            }
            struct Folders {
                static  let allFolders = "searchkit.filters.mail.folder.folderId.allfolders"
            }
        }
        struct cliq {
            struct Modules {
                static  let date = FilterConstants.i18NKeys.date.dateModuleName
                static  let sort = FilterConstants.i18NKeys.sort.sortModuleName
            }
          
            static  let  moduleOrder : [String] =  {
                return [Modules.sort,Modules.date]
            }()
        }
        struct connect {
            struct Modules {
                static  let portals = "searchkit.filters.connect.portals.connectId"
                static  let searchin = "searchkit.filters.connect.searchin"
                static  let date = FilterConstants.i18NKeys.date.dateModuleName
                static  let sort = FilterConstants.i18NKeys.sort.sortModuleName
            }
            static  let  moduleOrder : [String] =  {
                return [Modules.portals,Modules.searchin,Modules.sort,Modules.date]
            }()
            struct SearchIn {
                static  let feeds = "searchkit.filters.connect.searchin.feeds"
                static  let forums = "searchkit.filters.connect.searchin.forums"
            }
        }
        struct docs {
            struct Modules {
                static  let ownertype = "searchkit.filters.docs.ownerType"
                static  let searchin = "searchkit.filters.docs.searchin"
                static  let sort = FilterConstants.i18NKeys.sort.sortModuleName
            }
            static  let  moduleOrder : [String] =  {
                return [Modules.ownertype,Modules.searchin,Modules.sort]
            }()
            struct OwnerShipType {
                static let allFiles = "searchkit.filters.docs.ownerType.allfiles"
                static let ownedByMe = "searchkit.filters.docs.ownerType.mydocs"
                static let sharedWithMe = "searchkit.filters.docs.ownerType.sharedtome"
                static let sharedByMe = "searchkit.filters.docs.ownerType.sharedbyme"
            }
            struct FileTypes {
                static let allTypes = "searchkit.filters.docs.searchin.alltypes"
                static let writer = "searchkit.filters.docs.searchin.writer"
                static let sheet = "searchkit.filters.docs.searchin.sheet"
                static let show = "searchkit.filters.docs.searchin.show"
                static let pdf = "searchkit.filters.docs.searchin.pdf"
                static let image = "searchkit.filters.docs.searchin.image"
                static let music = "searchkit.filters.docs.searchin.music"
                static let video = "searchkit.filters.docs.searchin.video"
                static let zip = "searchkit.filters.docs.searchin.zip"
            }
        }
        struct crm {
            struct Modules {
                  static  let modules = "searchkit.filters.crm.moduleName"
            }
            static  let  moduleOrder : [String] =  {
                return [Modules.modules]
            }()
            struct Module {
                static let allModules = "searchkit.filters.crm.moduleName.all_crm_mod"
            }
        }
        struct desk {
            struct Modules {
                static  let portals = "searchkit.filters.desk.portalId"
                static  let department = "searchkit.filters.desk.deptId"
                static  let modules = "searchkit.filters.desk.moduleId"
                static  let sort = FilterConstants.i18NKeys.sort.sortModuleName
            }
            static  let  moduleOrder : [String] =  {
                return [ Modules.portals,Modules.department,Modules.modules,Modules.sort]
                }()
            struct Module {
                static let allModules = "searchkit.filters.desk.moduleId.0"
            }
        }
        struct wiki {
            struct Modules {
                static  let wikitype = "searchkit.filters.wiki.wikitype"
                static  let portals = "searchkit.filters.wiki.wikiId"
                static  let sort = FilterConstants.i18NKeys.sort.sortModuleName
                static  let date = FilterConstants.i18NKeys.date.dateModuleName
            }
            static  let  moduleOrder : [String] =  {
                return [Modules.wikitype,Modules.portals,Modules.sort,Modules.date]
            }()
            struct WikiTypes {
                static let myWIki = "searchkit.filters.wiki.wikitype.0"
                static let subscribedWiki = "searchkit.filters.wiki.wikitype.1"
            }
        }
        struct date {
            static let dateModuleName = "searchkit.filters.daterange"
            static let alldays = "searchkit.filters.daterange.alldays"
            static let today = "searchkit.filters.daterange.today"
            static let yesterday = "searchkit.filters.daterange.yesterday"
            static let last7days = "searchkit.filters.daterange.last7days"
            static let thisMonth = "searchkit.filters.daterange.thismonth"
            static let thisYear = "searchkit.filters.daterange.thisyear"
            static let specificDate = "searchkit.filters.daterange.specificdate"
            static let customRange = "searchkit.filters.daterange.customdate"
        }
        struct sort {
            static let sortModuleName = "searchkit.filters.sort"
            static let sortByTime = "searchkit.filters.sort.sorttime"
            static let sortByRelevance = "searchkit.filters.sort.sortrelv"
        }
    }
    struct DisPlayValues
    {
        static let SORT_BY = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.sort.sortModuleName, defaultValue: "Sort By")
        static let DATE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.dateModuleName, defaultValue: "Date")
        struct Date {
            static let ALL_DAYS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.alldays, defaultValue: "All Days")
            static let TODAY = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.today, defaultValue: "Today")
            static let YESTERDAY = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.yesterday, defaultValue: "Yesterday")
            static let LAST_7_DAYS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.last7days, defaultValue: "Last 7 days")
            static let THIS_MONTH = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.thisMonth, defaultValue: "This month")
            static let SPECIFIC_DATE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.specificDate, defaultValue: "Specific date")
            static let THISYEAR = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.thisYear, defaultValue: "This year")
            static let CUSTOM_RANGE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.customRange, defaultValue: "Custom range")
        }
        struct Docs{
            struct Types {
                static let ALL_FILES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.OwnerShipType.allFiles, defaultValue: "All Files")
                static let OWNED_BY_ME = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.OwnerShipType.ownedByMe, defaultValue: "Owned by Me")
                static let SHARED_TO_ME = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.OwnerShipType.sharedWithMe, defaultValue: "Shared with Me")
                static let SHARED_BY_ME = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.OwnerShipType.sharedByMe, defaultValue: "Shared by Me")
            }
            
            struct SearchIn {
                static let ALL_TYPES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.allTypes, defaultValue: "All Types")
                static let WRITER = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.writer, defaultValue: "Document")
                static let SHEET = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.sheet, defaultValue: "Spreadsheets")
                static let SHOW = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.show, defaultValue: "Presentation")
                static let PDF = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.pdf, defaultValue: "PDF")
                static let IMAGE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.image, defaultValue: "Pictures")
                static let MUSIC = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.music, defaultValue: "Music")
                static let VIDEO = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.video, defaultValue: "Videos")
                static let ZIP = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.FileTypes.zip, defaultValue: "ZIP")
            }
        }
        struct Desk {
            static let All_MODULES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.desk.Module.allModules, defaultValue: "All Modules")
        }
        struct Wiki {
            static let MY_WIKI = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.WikiTypes.myWIki, defaultValue: "My Wikis")
            static let SUBSCRIBED_WIKI = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.WikiTypes.subscribedWiki, defaultValue: "Subscribed Wikis")
        }
        struct Connect {
            static let FEEDS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.connect.SearchIn.feeds, defaultValue: "Feeds")
            static let FORUMS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.connect.SearchIn.forums, defaultValue: "Forums")
        }
        struct Mail {
            static let ALL_FOLDERS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Folders.allFolders, defaultValue: "All Folders")
            static let ALL_TAGS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Tags.allTags, defaultValue: "All Tags")
            
            static let ENTIRE_MESSAGE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.SearchIn.entireMessage, defaultValue: "Entire Message")
            static let SUBJECT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.SearchIn.subject, defaultValue: "Subject")
            static let CONTENT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.SearchIn.content, defaultValue: "Content")
            static let ATTACHMENT_NAME = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.SearchIn.attName, defaultValue: "Attachment Name")
            static let ATTACHMENT_CONTENT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.SearchIn.attContent, defaultValue: "Attachment Content")
        }
        struct CRM {
            static let All_MODULES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.crm.Module.allModules, defaultValue: "All Modules")
        }
        
    }
    struct Module
    {
        struct MailModules {
            static let ACCOUNT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.account, defaultValue: "Accounts")
            static let FOLDERS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.folder, defaultValue: "Folders")
            static let SEARCH_IN = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.searchin, defaultValue: "Folders")
            static let DATE = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.date.dateModuleName, defaultValue: "Date")
            static let TAGS = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.tags, defaultValue: "Tags")
            static let HAS_ATTACHMENT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.hasAttachments, defaultValue: "With Attachments")
            static let HAS_FLAG = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.hasFlag, defaultValue: "Flagged")
            static let HAS_REPLIES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.mail.Modules.hasReplies, defaultValue: "With Replies")
        }
        struct CliqModules{
            static let SORT_BY = FilterConstants.DisPlayValues.SORT_BY
            static let DATE =  FilterConstants.DisPlayValues.DATE
        }
        struct ConnectModules{
            static let PORTAL = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.connect.Modules.portals, defaultValue: "Portals")
            static let SEARCH_IN = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.connect.Modules.searchin, defaultValue: "Search In")
            static let SORT_BY = FilterConstants.DisPlayValues.SORT_BY
            static let DATE = FilterConstants.DisPlayValues.DATE
            
        }
        struct DocsModules{
            static let OWN_TYPE =  SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.Modules.ownertype, defaultValue: "Ownership Type")
            static let SEARCH_IN = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.docs.Modules.searchin, defaultValue: "File Types")
            static let SORT_BY = FilterConstants.DisPlayValues.SORT_BY
            
        }
        struct CRMModules{
            static let MODULES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.crm.Modules.modules, defaultValue: "Modules")
        }
        
        struct DeskModules{
            static let PORTAL = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.desk.Modules.portals, defaultValue: "Portals")
            static let DEPARTMENT = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.desk.Modules.department, defaultValue: "Departments")
            static let MODULES = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.desk.Modules.modules, defaultValue: "Modules")
            static let SORT_BY = FilterConstants.DisPlayValues.SORT_BY
        }
        struct WikiModules{
            static let Wiki_Types = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.Modules.wikitype, defaultValue: "Wiki Type")
            static let Portals = SearchKitUtil.getLocalizedString(i18nKey: FilterConstants.i18NKeys.wiki.Modules.portals, defaultValue: "Portals")
            static let SORT_BY = FilterConstants.DisPlayValues.SORT_BY
            static let DATE = FilterConstants.DisPlayValues.DATE
            
        }
    }
    struct Keys {
        static let SORTBY = "sort"
        
        struct DateFilterKeys {
            static   let FROM_DATE = "fromdate";
            static   let TO_DATE = "todate";
        }
        struct MailFilterKeys {
            static let EMAIL_ID = "emailId";
            static let FOLDER_ID = "folderId";
            static let FROM_DATE = "fromdate";
            static let TO_DATE = "todate";
            static let LABEL_ID = "labelId";
            static let HAS_ATTACHMENT = "hasAtt";
            static let HAS_FLAG = "hasFlg";
            static let HAS_REPLIES = "hasResp";
            static let SERACH_IN = "searchin";
        }
        struct DocsFilterKeys {
            static let SEARCH_IN = "searchin";
            static let OWNER_TYPE = "ownerType";
        }
        struct ChatFilterKeys {
            static   let FROM_DATE = "fromdate";
            static   let TO_DATE = "todate";
            static   let CHAT_TYPE = "chatType";
        }
        
        struct CrmFilterKeys {
            static   let MODULE_NAME = "moduleName";
        }
        
        struct WikiFilterKeys {
            static   let WIKIID = "wikiId";
        }
        
        struct ConnectFilterKeys {
            static   let CONNECTID = "connectId";
            static   let FROM_DATE = "fromdate";
            static   let TO_DATE = "todate";
            static   let SERACH_IN = "searchin";
        }
        struct DeskFilterKeys {
            static   let PORTALID = "portalId";
            static   let DEPARTMENT_ID = "deptId";
            static   let MODULE_ID = "moduleId";
        }
        
    }
    struct Values{
        struct Sortby{
            static let TIME = "sorttime"
            static let RELAVANCE = "sortrelv"
        }
        
        static let resourceFileDictionary: [String  :Any]? = {
            if let path = ZohoSearchKit.frameworkBundle.path(forResource: "FilterProperties", ofType: "plist") {
                return NSDictionary(contentsOfFile: path) as? [String  : Any]
            }
            return nil
        }()
        static  func loadPlistfile(dataDictionary : [String : Any], withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
        {
            var filterNames = [String]()
            var filterNameServerValuePairs = [String : String]()
            if let serverValues = dataDictionary[withModulei18Nkey] as? [String]
            {
                for serverValue in serverValues
                {
                    let filtername = SearchKitUtil.getLocalizedString(i18nKey: withModulei18Nkey.createI18NKeyByAppendingNew(feild: serverValue), defaultValue: serverValue)
                    filterNames.append(filtername)
                    filterNameServerValuePairs[filtername] = serverValue
                }
            }
            return (filterNames , filterNameServerValuePairs )
        }
        
        struct Mail {
            static  let mailDataDictionary : [String : Any]? = (resourceFileDictionary!["mail"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = mailDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Cliq {
            static let cliqDataDictionary : [String : Any]? = (resourceFileDictionary!["cliq"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = cliqDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Connect {
            static let connectDataDictionary : [String : Any]? = (resourceFileDictionary!["connect"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = connectDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Docs {
            static let docsDataDictionary : [String : Any]? = (resourceFileDictionary!["docs"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = docsDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Crm {
            static let CrmDataDictionary : [String : Any]? = (resourceFileDictionary!["crm"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = CrmDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Desk {
            static let DeskDataDictionary : [String : Any]? = (resourceFileDictionary!["desk"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = DeskDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        struct Wiki {
            static let WikiDataDictionary : [String : Any]? = (resourceFileDictionary!["wiki"] as? [String : Any])
            static  func loadPlistfile(dataDictionary : [String : Any] = WikiDataDictionary!, withModulei18Nkey : String , defaulti18NName : String ) -> ([String],[String : String])
            {
                return  FilterConstants.Values.loadPlistfile(dataDictionary: dataDictionary, withModulei18Nkey: withModulei18Nkey, defaulti18NName: defaulti18NName)
            }
        }
        class MailFilterValues {
            static let ENTIRE_MESSAGE = "entire";
            static let SUBJECT = "subject";
            static let CONTENT = "content";
            static let ATTACHMENT_NAME = "attname";
            static let ATTACHMENT_CONTENT = "attcontent";
            static let ALL_FOLDERS = "allfolders";
            static let ALL_TAGS = "alltags";
        }
        
        struct DocsFilterValues {
            static let ALL_FILES = "allfiles";
            static let OWNED_BY_ME = "mydocs";
            static let SHARED_TO_ME = "sharedtome";
            static let SHARED_BY_ME = "sharedbyme";
            
            static let ALL_TYPES = "alltypes";
            static let WRITER = "writer";
            static let SHEET = "sheet";
            static let SHOW = "show";
            static let PDF = "pdf";
            static let IMAGE = "image";
            static let MUSIC = "music";
            static let VIDEO = "video";
            static let ZIP = "zip";
            
        }
        
        struct ConnectFilterValues {
            static let FEEDS = "feeds";
            static let FORUMS = "forums";
            
            static let SHARED_TO_ME = "sharedtome";
            static let SHARED_BY_ME = "sharedbyme";
        }
        struct DeskFilterVaules{
            static let ALLMODULES = "0"
            static let REQUEST = "1"
            static let KNOWLEDGE_BASE = "2"
            static let CONTACTS = "3"
            static let ACCOUNTS = "4"
        }
        struct CrmFilterValues {
            static let ALL_MODULE = "all_crm_mod";
        }
        
    }
}



