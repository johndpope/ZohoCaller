//
//  DocsResultIconUtil.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

class ResultIconUtils {
    static func getIconForDocsResult(docResult: DocsResult) -> UIImage {
        var image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.DocsUnknownFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let iconType = docResult.docFileExtn
        switch (iconType?.lowercased()) {
        //For now we have the same icon for zwriter and ms word files. Later we might have different one.
        case "zwriter"?:
            fallthrough
        case "word"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsWordFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "zsheet"?:
            fallthrough
        case "xl"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsSheetFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "zslides"? :
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsShowFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "image"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsImageFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "video"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsVideoFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "music"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsAudioFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "power"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsPPTFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "pdf"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsPDFFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "html"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsCodeFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "zip"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsZIPFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "txt"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsTextFileImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "explorer"?:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DocsFolderImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        return image
    }
    static func getIconNameForDocsResult(docResult: DocsResult) -> String {
        var image:String = SearchKitConstants.ImageNameConstants.DocsUnknownFileImage
        let iconType = docResult.docFileExtn
        switch (iconType?.lowercased()) {
        //For now we have the same icon for zwriter and ms word files. Later we might have different one.
        case "zwriter"?:
            fallthrough
        case "word"?:
            image = SearchKitConstants.ImageNameConstants.DocsWordFileImage
            break
        case "zsheet"?:
            fallthrough
        case "xl"?:
            image = SearchKitConstants.ImageNameConstants.DocsSheetFileImage
            break
        case "zslides"? :
            image = SearchKitConstants.ImageNameConstants.DocsShowFileImage
            break
        case "image"?:
            image = SearchKitConstants.ImageNameConstants.DocsImageFileImage
            break
        case "video"?:
            image = SearchKitConstants.ImageNameConstants.DocsVideoFileImage
            break
        case "music"?:
            image = SearchKitConstants.ImageNameConstants.DocsAudioFileImage
            break
        case "power"?:
            image = SearchKitConstants.ImageNameConstants.DocsPPTFileImage
            break
        case "pdf"?:
            image = SearchKitConstants.ImageNameConstants.DocsPDFFileImage
            break
        case "html"?:
            image = SearchKitConstants.ImageNameConstants.DocsCodeFileImage
            break
        case "zip"?:
            image = SearchKitConstants.ImageNameConstants.DocsZIPFileImage
            break
        case "txt"?:
            image = SearchKitConstants.ImageNameConstants.DocsTextFileImage
            break
        case "explorer"?:
            image = SearchKitConstants.ImageNameConstants.DocsFolderImage
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        return image
    }
    static func getIconForCRMResult(crmResult: CRMResult) -> UIImage? {
        var image:UIImage?
        let moduleName = crmResult.moduleName.lowercased()
        switch (moduleName) {
        case "leads":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMLeadsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        case "campaigns":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMCampaignsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "solutions":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMSolutionsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        case "accounts":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMAccountsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "contacts" :
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMContactsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "deals":
            fallthrough
        case "potentials":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMPotentialsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "events":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMEventsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "calls":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMCallsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "tasks":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMTasksImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "notes":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMNotesImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "cases":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMCasesImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "quotes":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMQuotesImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "purchase_orders":
            fallthrough
        case "purchaseorders":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMPurchaseOrderImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "salesorders":
            fallthrough
        case "sales_orders":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMSalesOrderImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "pricebooks":
            fallthrough
        case "price_books":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMPriceBooksImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "products":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMProductsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "vendors":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMVendorsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case "invoices":
            image = UIImage(named: SearchKitConstants.ImageNameConstants.CRMInvoiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        default:
            image = nil
        }
        
        return image
    }
    static func getIconNameForCRMResult(crmResult: CRMResult) -> String? {
        var image:String?
        let moduleName = crmResult.moduleName.lowercased()
        switch (moduleName) {
        case "leads":
            image = SearchKitConstants.ImageNameConstants.CRMLeadsImage
        case "campaigns":
            image = SearchKitConstants.ImageNameConstants.CRMCampaignsImage
            break
        case "solutions":
            image = SearchKitConstants.ImageNameConstants.CRMSolutionsImage
        case "accounts":
            image = SearchKitConstants.ImageNameConstants.CRMAccountsImage
            break
        case "contacts" :
            image = SearchKitConstants.ImageNameConstants.CRMContactsImage
            break
        case "deals":
            fallthrough
        case "potentials":
            image = SearchKitConstants.ImageNameConstants.CRMPotentialsImage
            break
        case "events":
            image = SearchKitConstants.ImageNameConstants.CRMEventsImage
            break
        case "calls":
            image = SearchKitConstants.ImageNameConstants.CRMCallsImage
            break
        case "tasks":
            image = SearchKitConstants.ImageNameConstants.CRMTasksImage
            break
        case "notes":
            image = SearchKitConstants.ImageNameConstants.CRMNotesImage
            break
        case "cases":
            image = SearchKitConstants.ImageNameConstants.CRMCasesImage
            break
        case "quotes":
            image = SearchKitConstants.ImageNameConstants.CRMQuotesImage
            break
        case "purchase_orders":
            fallthrough
        case "purchaseorders":
            image = SearchKitConstants.ImageNameConstants.CRMPurchaseOrderImage
            break
        case "salesorders":
            fallthrough
        case "sales_orders":
            image = SearchKitConstants.ImageNameConstants.CRMSalesOrderImage
            break
        case "pricebooks":
            fallthrough
        case "price_books":
            image = SearchKitConstants.ImageNameConstants.CRMPriceBooksImage
            break
        case "products":
            image = SearchKitConstants.ImageNameConstants.CRMProductsImage
            break
        case "vendors":
            image = SearchKitConstants.ImageNameConstants.CRMVendorsImage
            break
        case "invoices":
            image = SearchKitConstants.ImageNameConstants.CRMInvoiceImage
            break
        default:
            image = nil
        }
        
        return image
    }
    static func getIconForDeskResult(deskResult: SupportResult) -> UIImage {
        //default is set to request module image
        var image:UIImage? = UIImage(named: SearchKitConstants.ImageNameConstants.DeskRequestImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        
        switch deskResult.moduleID {
        case 1:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DeskRequestImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case 2:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DeskKBImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case 3:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DeskContactsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        case 4:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DeskAccountsImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            break
        default:
            image = UIImage(named: SearchKitConstants.ImageNameConstants.DeskRequestImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        }
        
        return image!
    }
   
    static func getIconNameForDeskResult(deskResult: SupportResult) -> String {
        //default is set to request module image
        var image:String? =     SearchKitConstants.ImageNameConstants.DeskRequestImage
        
        switch deskResult.moduleID {
        case 1:
            image =     SearchKitConstants.ImageNameConstants.DeskRequestImage
            break
        case 2:
            image =     SearchKitConstants.ImageNameConstants.DeskKBImage
            break
        case 3:
            image =     SearchKitConstants.ImageNameConstants.DeskContactsImage
            break
        case 4:
            image =     SearchKitConstants.ImageNameConstants.DeskAccountsImage
            break
        default:
            image =     SearchKitConstants.ImageNameConstants.DeskRequestImage
        }
        
        return image!
    }
}
