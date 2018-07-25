//
//  ZOSConstants.swift
//  ZohoSearchApp
//
//  Created by hemant kumar s. on 13/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//
import Foundation

extension ZOSSearchAPIClient {
    
    struct ServiceNameConstants {
        static let All = "all" //all is not an actual service name, rather a constant given to the All service result page
        static let Mail = "mails"
        static let Cliq = "chat"
        static let Connect = "connect"
        static let Contacts = "personalContacts"
        static let People = "people"
        static let Documents = "documents"
        static let Desk = "support"
        static let Crm = "crm"
        static let Wiki = "wiki"
        static let Reports = "reports"
    }
    
    struct ContactsAPI {
        static let ApiScheme = "https"
        static let ApiHost = "contacts.zoho.com"
        static let ApiPathPrefix = "/api/v1/accounts/"
        static let ApiPathSuffix = "/contacts"
    }
    
    struct ContactsAPIParamKeys {
        static let PageIndex = "page"
        static let PerPageCount = "per_page"
        static let SortBy = "sort"
        static let IncludeFields = "include"
        
        //using search server
        static let Action = "action"
        static let FetchPersonalContacts = "fetchPersonalContacts"
        static let FetchOrgContacts = "fetchOrgContacts"
        static let Start = "start"
        static let Limit = "limit"
    }
    
    struct ContactsAPIParamValues {
        static let SortByUsageCountDescending = "-usage_count"
        static let NeededFields = "nick_name,emails,phones"
    }
    
    struct ContactsPhotoAPI {
        static let ApiScheme = "https"
        static let ApiHost = "contacts.zoho.com"
        static let ApiPath = "/file/download"
    }
    
    struct DocsResourceAPI {
        static let ApiScheme = "https"
        static let ApiHost = "docs.zoho.com"
        static let ApiPath = "/file"
    }
    
    // MARK: Contacts photo api param keys
    struct ContactsPhotoAPIParamKeys {
        static let FileSize = "fs"
        static let PhotoType = "t"
        static let ContactID = "ID"
    }
    
    // MARK: Contacts photo api param values
    struct ContactsPhotoAPIParamValues {
        enum ContactImageFileSize :String {
            case Stamp = "stamp"
            case Thumb = "thumb"
            case Original = "original"
        }
        
        enum ContactImageType :String {
            case User = "user"
            case Group = "group"
            case Org = "org"
        }
    }
    
    // MARK: API URL Constants
    struct SearchAPI {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "search.zoho.com"
        static let ApiPath = "/api/v1"
    }
    
    // MARK: API End Points
    struct APIPaths {
        // MARK: Widget Data
        static let WidgetData = "/widgetdata"
        // MARK: Widget granular data
        static let ServiceWidgetData = "/widgetdata/servicedata"
        // MARK: Search
        static let Search = "/search"
        // MARK: Callout Data
        static let Callout = "/callout"
    }
    
    // MARK: HTTP Request Methods
    struct HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
    }
    
    struct OAuthHeader {
        static let AuthHeaderName = "Authorization"
        //single space and only one space should be present as separator
        static let OAuthTokenPrefix = "Zoho-oauthtoken "
    }
    
    // MARK: App Info(Used for stats) Parameter Keys
    struct AppInfoParamKeys {
        static let AppPackage = "appPackage"
        static let AppPlatform = "appPlatform"
    }
    
    // MARK: App Info Parameter Values
    struct AppInfoParamValues {
        static let AppBundleID = Bundle.main.bundleIdentifier!
        static let AppPlatform = "iOS"
    }
    
    //some request urls with and without filters
    //all services search(no filter and no portal id and all) - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=all&services_list=chat,crm,mails,personalContacts,wiki,support,connect,documents,people
    //contact service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=personalContacts&services_list=personalContacts
    //people service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=people&services_list=people
    
    //mail service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=mails&services_list=mails
    //filter - mail service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=mails&services_list=mails&filters=%7B%22emailId%22%3A%22hemantkumar.s%40zohocorp.com%22%2C%22labelId%22%3A%22alltags%22%2C%22folderId%22%3A%22allfolders%22%2C%22searchin%22%3A%22entire%22%2C%22hasAtt%22%3Atrue%2C%22hasFlg%22%3Atrue%2C%22hasResp%22%3Atrue%7D
    //Note - no double encoding for email address - filters={"emailId":"hemantkumar.s@zohocorp.com","labelId":"alltags","folderId":"allfolders","searchin":"entire","hasAtt":true,"hasFlg":true,"hasResp":true}
    
    //cliq service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=chat&services_list=chat
    //filter - cliq service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=chat&services_list=chat&filters=%7B%22sort%22%3A%22sorttime%22%2C%22fromdate%22%3A%2208-03-2018%22%2C%22todate%22%3A%2208-03-2018%22%7D
    //filters={"sort":"sorttime","fromdate":"08-03-2018","todate":"08-03-2018"}
    
    //connect service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=connect&services_list=connect
    //filter - connect service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=connect&services_list=connect&filters=%7B%22connectId%22%3A9000500%2C%22searchin%22%3A%22feeds%22%2C%22sort%22%3A%22sorttime%22%2C%22fromdate%22%3A%2209-03-2018%22%2C%22todate%22%3A%2209-03-2018%22%7D
    //filters={"connectId":9000500,"searchin":"feeds","sort":"sorttime","fromdate":"09-03-2018","todate":"09-03-2018"}
    
    //docs service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=documents&services_list=documents
    //filter - docs service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=documents&services_list=documents&filters=%7B%22ownerType%22%3A%22mydocs%22%2C%22searchin%22%3A%22show%22%2C%22sort%22%3A%22sorttime%22%7D
    //filters={"ownerType":"mydocs","searchin":"show","sort":"sorttime"}
    
    //crm service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=crm&services_list=crm
    //filter - crm service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=crm&services_list=crm&filters=%7B%22moduleName%22%3A%22Leads%22%7D
    //filters={"moduleName":"Leads"}
    
    //desk service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=support&services_list=support
    //filter - desk service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=support&services_list=support&filters=%7B%22portalId%22%3A4241905%2C%22deptId%22%3A4000003812188%2C%22moduleId%22%3A1%2C%22sort%22%3A%22sorttime%22%7D
    //filters={"portalId":4241905,"deptId":4000003812188,"moduleId":1,"sort":"sorttime"}
    
    //wiki service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=wiki&services_list=wiki
    //filter - wiki service search - https://search.zoho.com/api/v1/search?appPackage=com.zoho.search&appPlatform=Android&query=zoho&is_scroll=false&start=0&no_of_results=25&search_type=wiki&services_list=wiki&filters=%7B%22wikiId%22%3A%226435862%22%2C%22sort%22%3A%22sorttime%22%7D
    //filters={"wikiId":"6435862","sort":"sorttime"}
    
    // MARK: Search Request Parameter Keys
    struct SearchParameterKeys {
        static let Query = "query"
        static let MentionedZUID = "men_user_zuid"
        static let ServiceList = "services_list"
        static let SearchType = "search_type"
        static let IsScroll = "is_scroll"
        static let StartIndex = "start"
        static let NumberOfResults = "no_of_results"
    }
    
    // MARK: Search Request Parameter Values
    struct SearchParameterValues {
        static let AllSearch = "all"
    }
    
    // MARK: Sort parameter keys
    struct SortParameterKeys {
        static let Sort = "sort"
    }
    
    // MARK: Sort parameter values
    struct SortParameterValues {
        static let SortByTime = "sorttime"
        static let SortByRelevance = "sortrelv"
    }
    
    // MARK: Search request filter parameter keys
    struct FilterParameterKeys {
        static let Filters = "filters"
        
        struct DateFilterParamKets {
            static let FromDate = "fromdate"
            static let ToDate = "todate"
        }
        
        struct MailFilterParamKeys {
            static let EmailID = "emailId"
            static let FolderID = "folderId"
            static let FromDate = "fromdate"
            static let ToDate = "todate"
            static let LabelID = "labelId"
            static let HasAttachment = "hasAtt"
            static let HasFlag = "hasFlg"
            static let HasReplies = "hasResp"
            static let SearchIn = "searchin"
        }
        
        struct DocsFilterParamKeys {
            static let SearchIn = "searchin"
            static let OwnerType = "ownerType"
        }
        
        struct CliqFilterParamKeys {
            static let ChatType = "chatType"
        }
        
        struct ConnectFilterParamKeys {
            static let ConnectID = "connectId"
            static let SearchIn = "searchin"
        }
        
        struct DeskFilterParamKeys {
            static let PortalID = "portalId"
            static let DepartmentID = "deptId"
            static let ModuleID = "moduleId"
        }
        
        struct CRMFilterParamKeys {
            static let ModuleName = "moduleName"
        }
        
        struct WikiFilterParamKeys {
            static let WikiID = "wikiId"
        }
    }
    
    // MARK: search request filter constant values
    struct FilterParameterValues {
        
        struct MailFilterParamValues {
            static let EntireMessage = "entire"
            static let Subject = "subject"
            static let Content = "content"
            static let AttachmentName = "attname"
            static let AttachmentContent = "attcontent";
            static let AllFolders = "allfolders"
            static let AllTags = "alltags"
        }
        
        struct DocsFilterParamValues {
            static let AllFiles = "allfiles"
            static let OwnedByMe = "mydocs"
            static let SharedToMe = "sharedtome"
            static let SHaredByMe = "sharedbyme"
            
            static let AllTypes = "alltypes"
            static let Writer = "writer"
            static let Sheet = "sheet"
            static let Show = "show"
            static let Pdf = "pdf"
            static let Image = "image"
            static let Music = "music"
            static let Video = "video"
            static let Zip = "zip"
        }
        
        struct ConnectFilterParamValues {
            static let Feeds = "feeds"
            static let Forums = "forums"
        }
    }
    
    // MARK: Search Response JSON Keys
    struct SearchResponseJSONKeys {
        static let SearchResults = "results"
        static let SearchResultMetaData = "meta_data"
        
        // MARK: Mail Result Meta Data JSON Keys
        struct MailResultsMetaData {
            static let MailAccount = "mail_account"
            static let AccountID = "accountId"
            static let AccountDisplayName = "displayName"
            static let EmailAddress = "emailAddr"
            static let IsDefault = "isDefault"
            static let AccountType = "accountType"
        }
        
        // MARK: Mail Result JSON Keys
        struct MailSearchResult {
            static let MessageID = "message_id"
            static let FromAddress = "from_address"
            static let SenderName = "sender_name"
            static let FolderName = "folder_name"
            static let AccountID = "account_id"
            static let MailSummary = "mail_summary"
            static let MailSubject = "subject"
            static let HasAttachment = "has_attachment"
            static let RecievedTime = "received_time"
            static let IsMailUnread = "is_mail_unread"
        }
        
        // MARK: Docs Result JSON Keys
        struct DocsSearchResult {
            static let DocumentID = "document_id"
            static let DocumentName = "document_name"
            static let Author = "author"
            static let ServiceName = "service"
            static let FileExtension = "file_extension"
            static let AccountID = "account_id"
            static let DocumentType = "document_type"
            static let LastModifiedTime = "last_modified_time"
        }
        
        // MARK: Chat Result JSON Keys
        struct ChatsSearchResult {
            static let ChatID = "chat_id"
            static let ChatTitle = "chat_title"
            static let ParticipantCount = "participants_count"
            static let RecentParticipants = "recent_participants"
            static let ServiceName = "service"
            static let AccountID = "ownerid"
            static let OwnerName = "owner_display_name"
            static let OwnerEmail = "owner_email"
            static let Time = "time"
            static let RecievedTime = "received_time"
        }
        
        // MARK: People Result JSON Keys
        struct PeopleSearchResult {
            static let PeopleID = "id"
            static let Zuid = "zuid"
            static let EmployeedID = "empid"
            static let FirstName = "empFname"
            static let LastName = "empLname"
            static let Gender = "gender"
            static let CroppedPhotoURL = "cphoto"
            static let PhotoURL = "photo"
            static let DepartmentID = "deptid"
            static let DepartmentName = "deptname"
            static let DesignationName = "desgname"
            static let MobileNumber = "mobile"
            static let Extension = "extn"
            static let PhoneNumber = "phone"
            static let EmailAddress = "mailid"
            static let Location = "location"
            static let IsSameOrg = "issameorg"
            static let ReportingFirstName = "reportFname"
            static let ReportingLastName = "reportLname"
            static let TeamMailID = "deptmail"
        }
        
        // MARK: Contacts Result JSON Keys
        struct ContactsSearchResult {
            static let ContactID = "contact_id"
            static let AccountID = "account_id"
            static let FullName = "full_name"
            static let EmailAddress = "email_address"
            static let MobileNumber = "mobile"
            static let ServiceName = "service"
            static let ContactsType = "type_of_contact"
            static let PhotoURL = "photo"
            static let UsageCount = "usage_count"
            static let StampURL = "stamp"
        }
        
        struct ConnectResultsMetaData {
            static let NetworkID = "network_id"
            static let NetworkName = "network_name"
        }
        
        // MARK: Connect Result JSON Keys
        struct ConnectSearchResult {
            static let StreamID = "id"
            static let StreamTitle = "title"
            static let PostedInWall = "pname"
            static let StreamAuthor = "author"
            static let StreamURL = "url"
            static let Zuid = "zuid"
            static let StreamType = "type"
            static let LastModifiedTime = "streamModifiedTime"
            static let HasAttachment = "hasAttach"
        }
        
        struct DeskResultsMetaData {
            static let PortalID = "portal_id"
            static let PortalName = "portal_name"
            static let DepartmentID = "department_id"
            static let DepartmentName = "department_name"
        }
        
        // MARK: Desk Result JSON Keys
        struct DeskSearchResult {
            static let EntityID = "entity_id"
            static let ModuleID = "module_id"
            static let Mode = "MODE"
            static let CreatedTime = "CREATEDTIME"
            static let OrgID = "ZSOID"
            static let ServiceName = "service"
            static let DepartmentID = "DEP_ID"
            static let Mobile = "MOBILE"
            static let Phone = "PHONE"
            static let Email = "EMAIL"
            static let Tickets = "tickets"
            static let Contacts = "contacts"
            static let AccountName = "ACCOUNTNAME"
            static let ContactName = "CONTACTNAME"
            static let CaseSubject = "CASESUBJECT"
            static let CaseNumber = "CASENUMBER"
            static let Status = "STATUS"
            static let SolutionTitle = "SOLUTIONTITLE"
            static let TopicName = "TOPIC_NAME"
        }
        
        // MARK: CRM Result Meta Data JSON Keys
        struct CRMSearchResult {
            static let EntityID = "id"
            static let FullName = "Full_Name"
            static let ModuleName = "mod"
            static let Status = "Status"
            static let Email = "Email"
            static let Mobile = "Mobile"
            static let Phone = "Phone"
            static let CampaignName = "Campaign_Name"
            static let SolutionTitle = "Solution_Title"
            static let AccountName = "Account_Name"
            static let CaseSubject = "Subject"
            static let DealName = "Deal_Name"
            static let Stage = "Stage"
            static let EventTitle = "Event_Title"
            static let ProductName = "Product_Name"
            static let SolutionNumber = "Solution_Number"
            static let CRMType = "Type"
            static let callsSubject = "Subject"
        }
        
        struct WikiResultsMetaData {
            static let WikiID = "wiki_id"
            static let WikiName = "wiki_name"
        }
        
        // MARK: Wiki Result JSON Keys
        struct WikiSearchResult {
            static let WikiID = "wiki_id"
            static let WikiDocID = "page_id"
            static let PageTitle = "page"
            static let AuthorName = "author_name"
            static let ServiceName = "service"
            static let ParentWikiID = "parent_id"
            static let WikiCategoryID = "wiki_category_id"
            static let WikiType = "type"
            static let LastModifiedTime = "last_modified_time"
            static let HasAttachment = "hasAttach"
            static let WikiAuthorZUID = "author_zuid"
            static let AuthorDisplayName = "author_display_name"
            static let LMAuthorDisplayName = "lm_author_display_name"
        }
    }
    
    // MARK: Widget Data Response JSON Keys
    struct WidgetDataResponseJSONKeys {
        static let ServiceList = "serviceList"
        static let UserInfo = "currentUserInfo"
        
        // MARK: Current User Data JSON Keys
        struct CurrentUserInfo {
            static let AccountZUID = "userZUID"
            static let AccountZOID = "userZOID"
            static let Email = "email"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let DisplayName = "displayName"
            static let CountryCode = "country"
            static let Language = "language"
            static let Timezone = "timezone"
            static let Gender = "gender"
        }
        
        // MARK: Mail Widget Data Response JSON Keys
        struct MailWidgetData {
            static let WidgetData = "mailsWidgetData"
            static let AccountID = "accountId"
            static let DisplayName = "displayName"
            static let Email = "emailAddr"
            static let IsDefault = "isDefault"
            static let AccountType = "accountType"
            static let Folders = "fArr"
            static let Tags = "lArr"
            static let TagID = "ID"
            static let TagName = "NAME"
            static let TagColor = "COLOR"
        }
        
        // MARK: Desk Widget Data Response JSON Keys
        struct DeskWidgetData {
            static let WidgetData = "supportWidgetData"
            static let ListData = "listData"
            static let PermData = "permData"
            static let ModuleData = "moduleData"
            static let DepartmentID = "id"
            static let DepartmentName = "name"
            static let DefaultData = "warmIndexData"
            static let DefaultPortalID = "warmPortalID"
            static let DefaultDepartmentID = "warmDepartmentID"
        }
        
        // MARK: CRM Widget Data Response JSON Keys
        struct CRMWidgetData {
            static let WidgetData = "crmWidgetData"
            static let ModuleID = "id"
            static let ModuleName = "modName"
            static let ModuleDisplayName = "modDispName"
            static let ModuleQueryName = "modQueryName"
        }
        
        // MARK: Connect Widget Data Response JSON Keys
        struct ConnectWidgetData {
            static let WidgetData = "connectWidgetData"
            static let PortalSOID = "soid"
            static let PortalName = "name"
            static let IsDefault = "isDefault"
        }
        
        // MARK: Wiki Widget Data Response JSON Keys
        struct WikiWidgetData {
            static let WidgetData = "wikiWidgetData"
            static let PersonalWiki = "mywiki_from_wiki"
            static let SubscribedWiki = "subscribed_from_wiki"
            static let WikiID = "wikiid"
            static let WikiName = "wikiname"
            static let IsDefault = "islanding"
        }
    }
    
    struct ContactsResponseJSONKeys {
        static let StatusCode = "status_code"
        static let HasMore = "has_more"
        static let ContactsList = "contacts"
        
        struct ContactInfo {
            static let ContactID = "contact_id"
            static let ContactZUID = "contact_zuid"
            static let ContactStatus = "status"
            static let ContactType = "contact_type"
            static let FirstName = "first_name"
            static let LastName = "last_name"
            static let NickName = "nick_name"
            static let PhotoURL = "photo_url"
            static let EmailAddresses = "emails"
            static let EmailID = "email_id"
            static let IsPrimaryEmail = "is_primary"
            static let PhoneNumbers = "phones"
            static let PhoneNumberType = "type"
            static let PhoneNumber = "number"
        }
    }
    
    struct CalloutRequestParamKeys {
        static let SearchType = "searchType"
        static let ClickPosition = "cpos"
    }
    struct CRMModulesNames {
        static let Contacts = "Contacts"
        static let Potentials = "Deals"
        static let Accounts = "Accounts"
        static let Leads = "Leads"
        static let Solutions = "Solutions"
        static let Campaigns = "Campaigns"
        static let Events = "Events"
        static let Calls = "Calls"
        static let Tasks = "Tasks"
        static let Cases = "Cases"
        static let Notes = "Notes"
    }
    struct CalloutResponseJSONKeys {
        static let ActualContent = "actualContent"
        static let WSName = "wsName"
        
        struct MailCallout {
            static let MailContent = "content"
            static let ToField = "to"
            static let SentTime = "sentTime"
            static let CC = "cc"
            static let BCC = "bcc"
            static let AttachmentInfo = "attach_info"
            struct AttactmentData {
                static let name = "n"
                static let size = "s"
                static let index = "i"
            }
        }
        struct CrmCallout {
            static let Owner = "Owner"
            struct OwnerData {
                static let ID = "id"
                static let Name = "name"
            }
            static let APInames = "apiNames"
            static let DataTypes = "dt"
            static let ExtraFeilds = "extraFields"
            static let ImportFeilds = "impFields"
            
            struct Contacts{
                static let Title = "Full Name"
            }
            struct  Potentials {
                static let Title = "Potential Name"
            }
            struct Accounts {
                static let Title = "Account Name"
            }
            struct Leads {
                static let Title = "Full Name"
            }
            struct Solutions {
                static let Title = "Solution Title"
            }
            struct Campaigns {
                static let Title = "Campaign Name"
            }
            //MARK:-Should update following modules title names
            struct events {
                static let Title = "Title"
            }
            
            struct Calls {
                static let Title = "Subject"
            }
            
            struct Tasks {
                static let Title = "Subject"
            }
            
            struct Cases {
                static let Title = "Subject" // Temp values need to cross check with serverside
            }
            struct Notes {
                static let Title = "Note Title" // Temp values need to cross check with serverside
                static let subTitle = "Note Content"
            }
            
        }
        
        struct DeskCallout {
            static let Result = "result"
            //TODO: Find out whether this Case Owner is display field value. I mean will it be used for display and also will it change for different language.
            //if not why name the field with multi words case.
            static let CaseOwner = "Case Owner"
            static let Answer = "Answer"
            static let CreatedBy = "Created By"
            static let DepartmentName = "Department"
            
        }
        
        struct ConnectCallout {
            static let Content = "content"
            static let Comments = "comment"
            static let CommentCount = "ccount"
            static let BlogCategories = "categories"
            static let Attachments = "attachments"
            static let Images = "images"
            struct CommentData {
                static let Name = "name"
                static let Time = "time"
                static let Zuid = "zuid"
                static let Content = "content"
                static let ID = "id"
            }
            struct AttactmentData {
                static let name = "name"
                static let size = "size"
                static let index = "fileId"
            }
        }
    }
    
    struct MailCalloutRequestParamKeys {
        static let MessageID = "msgId"
        static let AccountID = "accId"
        static let AccountType = "accType"
        static let attName = "atName"
        static let attIndex = "arIndex"
    }
    
    struct MailCalloutRequestParamValues {
        //TODO: I think this will not be needed as when sending request, will get form result object
        enum MailAccountType :String {
            case ZohoMailAccount = "1"
            case PopAccount = "0"
        }
    }
    
    struct WikiCalloutRequestParamKeys {
        static let DocID = "docId"
        static let WikiID = "wikiId"
        static let WikiCategoryID = "wikiCatId"
        static let WikiType = "type"
    }
    struct CRMCalloutRequestParamKeys {
        static let EntityID = "entityId"
        static let CrmModule = "crmMod"
    }
    
    struct ConnectCalloutRequestParamKeys {
        static let StreamID = "streamId"
        static let NetworkID = "networkId"
        static let postType = "ctype"
    }
    
    struct DeskCalloutRequestParamKeys {
        static let PortalName = "portal"
        static let PortalID = "portalId"
        static let DepartmentName = "department"
        static let EntityID = "id"
        static let ModuleID = "module"
        static let ModeName = "mode"
    }
}
