//
//  SearchKitConfigUtil.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class SearchKitConfigUtil {
    static func populateURLConfigs(searchKitURLConfig: SearchKitURLConfig) -> Void {
        var searchServerHostURL = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.SearchServerHost]
        if (searchServerHostURL == nil) {
            if let searchServerHost = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.SearchServerHost] {
                searchServerHostURL = searchServerHost as! NSString
            }
        }
        if let searchServerHostURL = searchServerHostURL {
            searchKitURLConfig.searchServerHost = searchServerHostURL as! String
        }
        
        var contactsServerHostURL = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ContactsServerHost]
        if (contactsServerHostURL == nil) {
            if let contactsServerHost = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ContactsServerHost] {
                contactsServerHostURL = contactsServerHost as! NSString
            }
        }
        if let contactsServerHostURL = contactsServerHostURL {
            searchKitURLConfig.contactsServerHost = contactsServerHostURL as! String
        }
    }
    
    static func populateChatUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let chatTitleFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let chatMsgTimeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let chatTypeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var chatTitleColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatTitleColorKey]
        if (chatTitleColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatTitleColorKey] {
                chatTitleColorCode = colorCode as! NSString
            }
        }
        if let chatTitleColorCode = chatTitleColorCode {
            chatTitleFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: chatTitleColorCode as! String)
        }
        
        var chatTitleFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatTitleFontSizeKey]
        if (chatTitleFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatTitleFontSizeKey] {
                chatTitleFontSize = fontSize as! NSNumber
            }
        }
        if let chatTitleFontSize = chatTitleFontSize {
            chatTitleFieldConfig?.fieldFontSize = chatTitleFontSize as! Float
        }
        
        var chatMsgTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatMsgTimeColorKey]
        if (chatMsgTimeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatMsgTimeColorKey] {
                chatMsgTimeColorCode = colorCode as! NSString
            }
        }
        if let chatMsgTimeColorCode = chatMsgTimeColorCode {
            chatMsgTimeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: chatMsgTimeColorCode as! String)
        }
        
        var chatMsgTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatMsgTimeFontSizeKey]
        if (chatMsgTimeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatMsgTimeFontSizeKey] {
                chatMsgTimeFontSize = fontSize as! NSNumber
            }
        }
        if let chatMsgTimeFontSize = chatMsgTimeFontSize {
            chatMsgTimeFieldConfig?.fieldFontSize = chatMsgTimeFontSize as! Float
        }
        
        var chatTypeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatTypeColorKey]
        if (chatTypeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatTypeColorKey] {
                chatTypeColorCode = colorCode as! NSString
            }
        }
        if let chatTypeColorCode = chatTypeColorCode {
            chatTypeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: chatTypeColorCode as! String)
        }
        
        var chatTypeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ChatTypeFontSizeKey]
        if (chatTypeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ChatTypeFontSizeKey] {
                chatTypeFontSize = fontSize as! NSNumber
            }
        }
        if let chatTypeFontSize = chatTypeFontSize {
            chatTypeFieldConfig?.fieldFontSize = chatTypeFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "chatTitle", fieldUIConfig: chatTitleFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "msgTime", fieldUIConfig: chatMsgTimeFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "chatType", fieldUIConfig: chatTypeFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Cliq, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateContactsUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        
        let contactNameFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let contactEmailFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var contactNameColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ContactNameColorKey]
        if (contactNameColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ContactNameColorKey] {
                contactNameColorCode = colorCode as! NSString
            }
        }
        if let contactNameColorCode = contactNameColorCode {
            contactNameFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: contactNameColorCode as! String)
        }
        
        var contactNameFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ContactNameFontSizeKey]
        if (contactNameFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ContactNameFontSizeKey] {
                contactNameFontSize = fontSize as! NSNumber
            }
        }
        if let contactNameFontSize = contactNameFontSize {
            contactNameFieldConfig?.fieldFontSize = contactNameFontSize as! Float
        }
        
        var contactEmailColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ContactEmailColorKey]
        if (contactEmailColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ContactEmailColorKey] {
                contactEmailColorCode = colorCode as! NSString
            }
        }
        if let contactEmailColorCode = contactEmailColorCode {
            contactEmailFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: contactEmailColorCode as! String)
        }
        
        var contactEmailFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ContactEmailFontSizeKey]
        if (contactEmailFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ContactEmailFontSizeKey] {
                contactEmailFontSize = fontSize as! NSNumber
            }
        }
        if let contactEmailFontSize = contactEmailFontSize {
            contactEmailFieldConfig?.fieldFontSize = contactEmailFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "contactName", fieldUIConfig: contactNameFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "contactEmail", fieldUIConfig: contactEmailFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Contacts, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateConnectUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        /*
         let name: String? = nil
         let unwrappedName = name ?? "Anonymous"
         */
        
        let serviceResultUIConfig = ServiceResultUIConfig()
        let connectPostTitleFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let connectPostTimeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let connectPostAuthorFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var connectPostTitleColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostTitleColorKey]
        if (connectPostTitleColorCode == nil) {
            if let postTitleColor = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostTitleColorKey] {
                connectPostTitleColorCode = postTitleColor as! NSString
            }
        }
        if let connectPostTitleColorCode = connectPostTitleColorCode {
            connectPostTitleFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: connectPostTitleColorCode as! String)
        }
        
        var connectPostTitleFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostTitleFontSizeKey]
        if (connectPostTitleFontSize == nil) {
            if let postTitleFontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostTitleFontSizeKey] {
                connectPostTitleFontSize = postTitleFontSize as! NSNumber
            }
        }
        if let connectPostTitleFontSize = connectPostTitleFontSize {
            connectPostTitleFieldConfig?.fieldFontSize = connectPostTitleFontSize as! Float
        }
        
        var connectPostTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostTimeColorKey]
        if (connectPostTimeColorCode == nil) {
            if let postTimeColorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostTimeColorKey] {
                connectPostTimeColorCode =  postTimeColorCode as! NSString
            }
        }
        if let connectPostTimeColorCode = connectPostTimeColorCode {
            connectPostTimeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: connectPostTimeColorCode as! String)
        }
        
        var connectPostTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostTimeFontSizeKey]
        if (connectPostTimeFontSize == nil) {
            if let postTimeFontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostTimeFontSizeKey] {
                connectPostTimeFontSize = postTimeFontSize as! NSNumber
            }
        }
        if let connectPostTimeFontSize = connectPostTimeFontSize {
            connectPostTimeFieldConfig?.fieldFontSize = connectPostTimeFontSize as! Float
        }
        
        var connectPostAuthorColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostAuthorColorKey]
        if (connectPostAuthorColorCode == nil) {
            if let postAuthorColorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostAuthorColorKey] {
                connectPostAuthorColorCode = postAuthorColorCode as! NSString
            }
        }
        if let connectPostAuthorColorCode = connectPostAuthorColorCode {
            connectPostAuthorFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: connectPostAuthorColorCode as! String)
        }
        
        var connectPostAuthorFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.ConnectPostAuthorFontSizeKey]
        if (connectPostAuthorFontSize == nil) {
            if let postAuthorFontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.ConnectPostAuthorFontSizeKey] {
                connectPostAuthorFontSize = postAuthorFontSize as! NSNumber
            }
        }
        if let connectPostAuthorFontSize = connectPostAuthorFontSize {
            connectPostAuthorFieldConfig?.fieldFontSize = connectPostAuthorFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "connectTitle", fieldUIConfig: connectPostTitleFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "connectPostTime", fieldUIConfig: connectPostTimeFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "connectPostAuthor", fieldUIConfig: connectPostAuthorFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Connect, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateCRMUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let crmTitleFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let crmSubtitleFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let crmTextIconFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 26.0)
        
        var crmTitleColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmTitleColorKey]
        if (crmTitleColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmTitleColorKey] {
                crmTitleColorCode = colorCode as! NSString
            }
        }
        if let crmTitleColorCode = crmTitleColorCode {
            crmTitleFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: crmTitleColorCode as! String)
        }
        
        var crmTitleFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmTitleFontSizeKey]
        if (crmTitleFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmTitleFontSizeKey] {
                crmTitleFontSize = fontSize as! NSNumber
            }
        }
        if let crmTitleFontSize = crmTitleFontSize {
            crmTitleFieldConfig?.fieldFontSize = crmTitleFontSize as! Float
        }
        
        var crmSubtitleColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmSubtitleColorKey]
        if (crmSubtitleColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmSubtitleColorKey] {
                crmSubtitleColorCode =  colorCode as! NSString
            }
        }
        if let crmSubtitleColorCode = crmSubtitleColorCode {
            crmSubtitleFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: crmSubtitleColorCode as! String)
        }
        
        var crmSubtitleFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmSubtitleFontSizeKey]
        if (crmSubtitleFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmSubtitleFontSizeKey] {
                crmSubtitleFontSize = fontSize as! NSNumber
            }
        }
        if let crmSubtitleFontSize = crmSubtitleFontSize {
            crmSubtitleFieldConfig?.fieldFontSize = crmSubtitleFontSize as! Float
        }
        
        var iconTextColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmIconTextColorKey]
        if (iconTextColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmIconTextColorKey] {
                iconTextColorCode = colorCode as! NSString
            }
        }
        if let iconTextColorCode = iconTextColorCode {
            crmTextIconFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: iconTextColorCode as! String)
        }
        
        var iconTextFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.CrmIconTextFontSizeKey]
        if (iconTextFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.CrmIconTextFontSizeKey] {
                iconTextFontSize = fontSize as! NSNumber
            }
        }
        if let iconTextFontSize = iconTextFontSize {
            crmTextIconFieldConfig?.fieldFontSize = iconTextFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "crmTitle", fieldUIConfig: crmTitleFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "subtitleOne", fieldUIConfig: crmSubtitleFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "iconText", fieldUIConfig: crmTextIconFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Crm, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateDocsUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let docNameFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let docLMTimeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let docAuthorFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var docNameColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocNameColorKey]
        if (docNameColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocNameColorKey] {
                docNameColorCode = colorCode as! NSString
            }
        }
        if let docNameColorCode = docNameColorCode {
            docNameFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: docNameColorCode as! String)
        }
        
        var docNameFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocNameFontSizeKey]
        if (docNameFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocNameFontSizeKey] {
                docNameFontSize = fontSize as! NSNumber
            }
        }
        if let docNameFontSize = docNameFontSize {
            docNameFieldConfig?.fieldFontSize = docNameFontSize as! Float
        }
        
        var docLMTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocModifiedTimeColorKey]
        if (docLMTimeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocModifiedTimeColorKey] {
                docLMTimeColorCode =  colorCode as! NSString
            }
        }
        if let docLMTimeColorCode = docLMTimeColorCode {
            docLMTimeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: docLMTimeColorCode as! String)
        }
        
        var docLMTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocModifiedTimeFontSizeKey]
        if (docLMTimeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocModifiedTimeFontSizeKey] {
                docLMTimeFontSize = fontSize as! NSNumber
            }
        }
        if let docLMTimeFontSize = docLMTimeFontSize {
            docLMTimeFieldConfig?.fieldFontSize = docLMTimeFontSize as! Float
        }
        
        var docAuthorColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocAuthorColorKey]
        if (docAuthorColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocAuthorColorKey] {
                docAuthorColorCode = colorCode as! NSString
            }
        }
        if let docAuthorColorCode = docAuthorColorCode {
            docAuthorFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: docAuthorColorCode as! String)
        }
        
        var docAuthorFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DocAuthorFontSizeKey]
        if (docAuthorFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DocAuthorFontSizeKey] {
                docAuthorFontSize = fontSize as! NSNumber
            }
        }
        if let docAuthorFontSize = docAuthorFontSize {
            docAuthorFieldConfig?.fieldFontSize = docAuthorFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "docName", fieldUIConfig: docNameFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "lmTime", fieldUIConfig: docLMTimeFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "docAuthor", fieldUIConfig: docAuthorFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Documents, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateDeskUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        
        let serviceResultUIConfig = ServiceResultUIConfig()
        let deskTitleFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let deskSubtitleOneFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let deskSubtitleTwoFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let deskCreationTimeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var deskTitleColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskTitleColorKey]
        if (deskTitleColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskTitleColorKey] {
                deskTitleColorCode = colorCode as! NSString
            }
        }
        if let deskTitleColorCode = deskTitleColorCode {
            deskTitleFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: deskTitleColorCode as! String)
        }
        
        var deskTitleFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskTitleFontSizeKey]
        if (deskTitleFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskTitleFontSizeKey] {
                deskTitleFontSize = fontSize as! NSNumber
            }
        }
        if let crmTitleFontSize = deskTitleFontSize {
            deskTitleFieldConfig?.fieldFontSize = crmTitleFontSize as! Float
        }
        
        var deskSubtitleOneColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskSubtitleOneColorKey]
        if (deskSubtitleOneColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskSubtitleOneColorKey] {
                deskSubtitleOneColorCode =  colorCode as! NSString
            }
        }
        if let deskSubtitleOneColorCode = deskSubtitleOneColorCode {
            deskSubtitleOneFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: deskSubtitleOneColorCode as! String)
        }
        
        var deskSubtitleOneFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskSubtitleOneFontSizeKey]
        if (deskSubtitleOneFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskSubtitleOneFontSizeKey] {
                deskSubtitleOneFontSize = fontSize as! NSNumber
            }
        }
        if let deskSubtitleOneFontSize = deskSubtitleOneFontSize {
            deskSubtitleOneFieldConfig?.fieldFontSize = deskSubtitleOneFontSize as! Float
        }
        
        var deskSubtitleTwoColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskSubtitleTwoColorKey]
        if (deskSubtitleTwoColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskSubtitleTwoColorKey] {
                deskSubtitleTwoColorCode = colorCode as! NSString
            }
        }
        if let deskSubtitleTwoColorCode = deskSubtitleTwoColorCode {
            deskSubtitleTwoFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: deskSubtitleTwoColorCode as! String)
        }
        
        var deskSubtitleTwoFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskSubtitleTwoFontSizeKey]
        if (deskSubtitleTwoFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskSubtitleTwoFontSizeKey] {
                deskSubtitleTwoFontSize = fontSize as! NSNumber
            }
        }
        if let deskSubtitleTwoFontSize = deskSubtitleTwoFontSize {
            deskSubtitleTwoFieldConfig?.fieldFontSize = deskSubtitleTwoFontSize as! Float
        }
        
        var creationTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskCreationTimeColorKey]
        if (creationTimeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskCreationTimeColorKey] {
                creationTimeColorCode = colorCode as! NSString
            }
        }
        if let creationTimeColorCode = creationTimeColorCode {
            deskCreationTimeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: creationTimeColorCode as! String)
        }
        
        var creationTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.DeskCreationTimeFontSizeKey]
        if (creationTimeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.DeskCreationTimeFontSizeKey] {
                creationTimeFontSize = fontSize as! NSNumber
            }
        }
        if let creationTimeFontSize = creationTimeFontSize {
            deskCreationTimeFieldConfig?.fieldFontSize = creationTimeFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "deskTitle", fieldUIConfig: deskTitleFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "subtitleOne", fieldUIConfig: deskSubtitleOneFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "subtitleTwo", fieldUIConfig: deskSubtitleTwoFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "creationTime", fieldUIConfig: deskCreationTimeFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Desk, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateMailUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let mailSubjectFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let msgTimeFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let mailSenderFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let mailFolderNameFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var mailSubjectColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailSubjectColorKey]
        if (mailSubjectColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailSubjectColorKey] {
                mailSubjectColorCode = colorCode as! NSString
            }
        }
        if let mailSubjectColorCode = mailSubjectColorCode {
            mailSubjectFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: mailSubjectColorCode as! String)
        }
        
        var mailSubjectFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailSubjectFontSizeKey]
        if (mailSubjectFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailSubjectFontSizeKey] {
                mailSubjectFontSize = fontSize as! NSNumber
            }
        }
        if let mailSubjectFontSize = mailSubjectFontSize {
            mailSubjectFieldConfig?.fieldFontSize = mailSubjectFontSize as! Float
        }
        
        var msgTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailMessageTimeColorKey]
        if (msgTimeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailMessageTimeColorKey] {
                msgTimeColorCode =  colorCode as! NSString
            }
        }
        if let msgTimeColorCode = msgTimeColorCode {
            msgTimeFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: msgTimeColorCode as! String)
        }
        
        var msgTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailMessageTimeFontSizeKey]
        if (msgTimeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailMessageTimeFontSizeKey] {
                msgTimeFontSize = fontSize as! NSNumber
            }
        }
        if let msgTimeFontSize = msgTimeFontSize {
            msgTimeFieldConfig?.fieldFontSize = msgTimeFontSize as! Float
        }
        
        var mailSenderColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailSenderColorKey]
        if (mailSenderColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailSenderColorKey] {
                mailSenderColorCode = colorCode as! NSString
            }
        }
        if let mailSenderColorCode = mailSenderColorCode {
            mailSenderFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: mailSenderColorCode as! String)
        }
        
        var mailSenderFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailSenderFontSizeKey]
        if (mailSenderFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailSenderFontSizeKey] {
                mailSenderFontSize = fontSize as! NSNumber
            }
        }
        if let mailSenderFontSize = mailSenderFontSize {
            mailSenderFieldConfig?.fieldFontSize = mailSenderFontSize as! Float
        }
        
        var folderNameColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailFolderNameColorKey]
        if (folderNameColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailFolderNameColorKey] {
                folderNameColorCode = colorCode as! NSString
            }
        }
        if let folderNameColorCode = folderNameColorCode {
            mailFolderNameFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: folderNameColorCode as! String)
        }
        
        var folderNameFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.MailFolderNameFontSizeKey]
        if (folderNameFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.MailFolderNameFontSizeKey] {
                folderNameFontSize = fontSize as! NSNumber
            }
        }
        if let folderNameFontSize = folderNameFontSize {
            mailFolderNameFieldConfig?.fieldFontSize = folderNameFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "mailSubject", fieldUIConfig: mailSubjectFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "msgTime", fieldUIConfig: msgTimeFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "sender", fieldUIConfig: mailSenderFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "folderName", fieldUIConfig: mailFolderNameFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Mail, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populatePeopleUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let employeeNameFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let employeeEmailFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let extnNumFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var empNameColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleNameColorKey]
        if (empNameColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleNameColorKey] {
                empNameColorCode = colorCode as! NSString
            }
        }
        if let empNameColorCode = empNameColorCode {
            employeeNameFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: empNameColorCode as! String)
        }
        
        var empNameFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleNameFontSizeKey]
        if (empNameFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleNameFontSizeKey] {
                empNameFontSize = fontSize as! NSNumber
            }
        }
        if let empNameFontSize = empNameFontSize {
            employeeNameFieldConfig?.fieldFontSize = empNameFontSize as! Float
        }
        
        var emailColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleEmailColorKey]
        if (emailColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleEmailColorKey] {
                emailColorCode =  colorCode as! NSString
            }
        }
        if let emailColorCode = emailColorCode {
            employeeEmailFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: emailColorCode as! String)
        }
        
        var emailFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleEmailFontSizeKey]
        if (emailFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleEmailFontSizeKey] {
                emailFontSize = fontSize as! NSNumber
            }
        }
        if let emailFontSize = emailFontSize {
            employeeEmailFieldConfig?.fieldFontSize = emailFontSize as! Float
        }
        
        var extnNumColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleExtnColorKey]
        if (extnNumColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleExtnColorKey] {
                extnNumColorCode = colorCode as! NSString
            }
        }
        if let extnNumColorCode = extnNumColorCode {
            extnNumFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: extnNumColorCode as! String)
        }
        
        var extnNumFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.PeopleExtnFontSizeKey]
        if (extnNumFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.PeopleExtnFontSizeKey] {
                extnNumFontSize = fontSize as! NSNumber
            }
        }
        if let extnNumFontSize = extnNumFontSize {
            extnNumFieldConfig?.fieldFontSize = extnNumFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "empName", fieldUIConfig: employeeNameFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "email", fieldUIConfig: employeeEmailFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "extnNumber", fieldUIConfig: extnNumFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.People, fieldUIConfig: serviceResultUIConfig)
    }
    
    static func populateWikiUIProperties(searchKitResUIConfig: SearchKitResultUIConfig) -> Void {
        let serviceResultUIConfig = ServiceResultUIConfig()
        let wikiNameFieldConfig = FieldUIConfig(fontColor: UIColor.black, fontSize: 18.0)
        let lastModifiedFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        let wikiAuthorFieldConfig = FieldUIConfig(fontColor: UIColor.darkGray, fontSize: 16.0)
        
        var wikiNameColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiNameColorKey]
        if (wikiNameColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiNameColorKey] {
                wikiNameColorCode = colorCode as! NSString
            }
        }
        if let wikiNameColorCode = wikiNameColorCode {
            wikiNameFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: wikiNameColorCode as! String)
        }
        
        var wikiNameFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiNameFontSizeKey]
        if (wikiNameFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiNameFontSizeKey] {
                wikiNameFontSize = fontSize as! NSNumber
            }
        }
        if let wikiNameFontSize = wikiNameFontSize {
            wikiNameFieldConfig?.fieldFontSize = wikiNameFontSize as! Float
        }
        
        var wikiLMTimeColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiLMTimeColorKey]
        if (wikiLMTimeColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiLMTimeColorKey] {
                wikiLMTimeColorCode =  colorCode as! NSString
            }
        }
        if let wikiLMTimeColorCode = wikiLMTimeColorCode {
            lastModifiedFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: wikiLMTimeColorCode as! String)
        }
        
        var lmTimeFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiLMTimeFontSizeKey]
        if (lmTimeFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiLMTimeFontSizeKey] {
                lmTimeFontSize = fontSize as! NSNumber
            }
        }
        if let lmTimeFontSize = lmTimeFontSize {
            lastModifiedFieldConfig?.fieldFontSize = lmTimeFontSize as! Float
        }
        
        var wikiAuthorColorCode = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiAuthorColorKey]
        if (wikiAuthorColorCode == nil) {
            if let colorCode = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiAuthorColorKey] {
                wikiAuthorColorCode = colorCode as! NSString
            }
        }
        if let wikiAuthorColorCode = wikiAuthorColorCode {
            wikiAuthorFieldConfig?.fieldFontColor = UIColor.hexStringToUIColor(hex: wikiAuthorColorCode as! String)
        }
        
        var wikiAuthorFontSize = ZohoSearchKit.sharedInstance().appInfoPropertyList[SearchKitConfigKeys.WikiAuthorFontSizeKey]
        if (wikiAuthorFontSize == nil) {
            if let fontSize = ZohoSearchKit.sharedInstance().frameworkConfigPropertyList[SearchKitConfigKeys.WikiAuthorFontSizeKey] {
                wikiAuthorFontSize = fontSize as! NSNumber
            }
        }
        if let wikiAuthorFontSize = wikiAuthorFontSize {
            wikiAuthorFieldConfig?.fieldFontSize = wikiAuthorFontSize as! Float
        }
        
        serviceResultUIConfig.addFieldUIConfig(fieldName: "wikiName", fieldUIConfig: wikiNameFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "lastModTime", fieldUIConfig: lastModifiedFieldConfig!)
        serviceResultUIConfig.addFieldUIConfig(fieldName: "wikiAuthor", fieldUIConfig: wikiAuthorFieldConfig!)
        searchKitResUIConfig.addServiceUIConfig(serviceName: ZOSSearchAPIClient.ServiceNameConstants.Wiki, fieldUIConfig: serviceResultUIConfig)
    }
}
