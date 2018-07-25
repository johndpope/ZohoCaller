//
//  ServiceIconUtils.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 28/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class ServiceIconUtils {
    static func getServiceIcon(serviceName: String) -> UIImage? {
        var serviceIcon: UIImage?
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.All:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.AllServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.CliqServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.ContactsServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.PeopleServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.ConnectServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.MailServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.DocsServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.CRMServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.DeskServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.WikiServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        case ZOSSearchAPIClient.ServiceNameConstants.Reports:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.ReportsServiceImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        default:
            break
        }
        
        return serviceIcon
    }
    
    static func getServiceSelectedStateIcon(serviceName: String) -> UIImage? {
        var serviceIcon: UIImage?
        switch serviceName {
        case ZOSSearchAPIClient.ServiceNameConstants.All:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.AllServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Cliq:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.CliqServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Contacts:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.ContactsServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.People:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.PeopleServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Connect:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.ConnectServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Mail:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.MailServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Documents:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.DocsServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Crm:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.CRMServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Desk:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.DeskServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        case ZOSSearchAPIClient.ServiceNameConstants.Wiki:
            serviceIcon = UIImage(named: SearchKitConstants.ImageNameConstants.WikiServiceSelectedImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            break
        default:
            break
        }
        
        return serviceIcon
    }
}
