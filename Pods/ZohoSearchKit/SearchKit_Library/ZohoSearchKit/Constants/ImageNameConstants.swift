//
//  ImageNameConstants.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 18/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

extension SearchKitConstants {
    //If the SDK user want to have custom icon, then they should name the icons with the same name. And also ignore search kit icon set and set some config
    //accordingly we will load the image from respective bundle. Currently we are loading image from framework bundle, if needed we might have to load the icon
    //from the mail bundle
    struct ImageNameConstants {
        //Filter icons
        static let TickImage = "searchsdk-selection"
        //General icons
        static let NoUserImage = "searchsdk-nouser-image"
        static let LoadingImagePrefix = "searchsdk-loader"
        static let AttachmentImage = "searchsdk-attachment"
        static let MakeCallImage = "searchsdk-start-call"
        static let ChatWithTheUser = "searchsdk-start-chat"
        static let MoreActionsImage = "searchsdk-more"
        static let SendMailImage = "searchsdk-send-mail"
        static let OpenInAppImage = "searchsdk-open-app"
        static let SearchHistoryImage = "searchsdk-history"
        static let ResultCellExpanded = "searchsdk-eye-blue"
        static let ResultCellNotExpanded = "searchsdk-eye"
        static let GoBackImage = "searchsdk-back"
        static let GoForwardImage = "searchsdk-right-arrow"
        static let SavedSearchImage = "searchsdk-save"
        static let SelctionTickImage = "searchsdk-selection"
        static let ServiceReorderImage = "searchsdk-service-order"
        
        //Service icons
        static let AllServiceImage = "searchsdk-service-all"
        static let AllServiceSelectedImage = "searchsdk-service-all-selected"
        static let CliqServiceImage = "searchsdk-service-cliq"
        static let CliqServiceSelectedImage = "searchsdk-service-cliq-selected"
        static let ConnectServiceImage = "searchsdk-service-connect"
        static let ConnectServiceSelectedImage = "searchsdk-service-connect-selected"
        static let ContactsServiceImage = "searchsdk-service-contacts"
        static let ContactsServiceSelectedImage = "searchsdk-service-contacts-selected"
        static let CRMServiceImage = "searchsdk-service-crm"
        static let CRMServiceSelectedImage = "searchsdk-service-crm-selected"
        static let DeskServiceImage = "searchsdk-service-desk"
        static let DeskServiceSelectedImage = "searchsdk-service-desk-selected"
        static let DocsServiceImage = "searchsdk-service-docs"
        static let DocsServiceSelectedImage = "searchsdk-service-docs-selected"
        static let MailServiceImage = "searchsdk-service-mail"
        static let MailServiceSelectedImage = "searchsdk-service-mail-selected"
        static let PeopleServiceImage = "searchsdk-service-people"
        static let PeopleServiceSelectedImage = "searchsdk-service-people-selected"
        static let WikiServiceImage = "searchsdk-service-wiki"
        static let WikiServiceSelectedImage = "searchsdk-service-wiki-selected"
        static let ReportsServiceImage = "searchsdk-service-reports"
        static let ReportsServiceSelectedImage = "searchsdk-service-reports-selected"
        //Cliq/Chat result icons
        static let CliqGroupChatImage = "searchsdk-cliq-group"
        
        //Wiki result icons
        static let WikiResultImage = "searchsdk-wiki"
        
        //Mail result icons
        static let MailUnreadImage = "searchsdk-mail-unread"
        static let MailReadImage = "searchsdk-mail-read"
        
        //Docs result icons
        static let DocsUnknownFileImage = "searchsdk-docs-unknown"
        static let DocsWordFileImage = "searchsdk-docs-word"
        static let DocsSheetFileImage = "searchsdk-docs-sheet"
        static let DocsShowFileImage = "searchsdk-docs-show"
        static let DocsImageFileImage = "searchsdk-docs-image"
        static let DocsVideoFileImage = "searchsdk-docs-video"
        static let DocsAudioFileImage = "searchsdk-docs-music"
        static let DocsPPTFileImage = "searchsdk-docs-powerpoint"
        static let DocsPDFFileImage = "searchsdk-docs-pdf"
        static let DocsCodeFileImage = "searchsdk-docs-code"
        static let DocsZIPFileImage = "searchsdk-docs-zip"
        static let DocsTextFileImage = "searchsdk-docs-text"
        static let DocsFolderImage = "searchsdk-docs-folder"
        
        //CRM result icons
        static let CRMLeadsImage = "searchsdk-crm-leads"
        static let CRMCampaignsImage = "searchsdk-crm-campaigns"
        static let CRMSolutionsImage = "searchsdk-crm-solutions"
        static let CRMAccountsImage = "searchsdk-crm-accounts"
        static let CRMContactsImage = "searchsdk-crm-contacts"
        static let CRMPotentialsImage = "searchsdk-crm-potentials"
        static let CRMEventsImage = "searchsdk-crm-events"
        static let CRMCallsImage = "searchsdk-crm-calls"
        static let CRMTasksImage = "searchsdk-crm-tasks"
        static let CRMNotesImage = "searchsdk-crm-notes"
        static let CRMCasesImage = "searchsdk-crm-cases"
        static let CRMQuotesImage = "searchsdk-crm-quotes"
        static let CRMPurchaseOrderImage = "searchsdk-crm-purchase-order"
        static let CRMSalesOrderImage = "searchsdk-crm-sales-order"
        static let CRMPriceBooksImage = "searchsdk-crm-price-books"
        static let CRMProductsImage = "searchsdk-crm-products"
        static let CRMVendorsImage = "searchsdk-crm-vendors"
        static let CRMInvoiceImage = "searchsdk-crm-invoice"
        
        //Desk result icons
        static let DeskRequestImage = "searchsdk-desk-request"
        static let DeskKBImage = "searchsdk-desk-knowledge"
        static let DeskContactsImage = "searchsdk-desk-contacts"
        static let DeskAccountsImage = "searchsdk-desk-accounts"
        //Attachment icons
        static let AttachmentDownloadImage = "searchsdk-download"
    }
}
