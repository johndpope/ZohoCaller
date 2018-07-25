//
//  UserPrefManager.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 08/03/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class UserPrefManager {
    
    //or this should be just prefix in case of multi user scenario
    fileprivate struct PrefKeysPrefix {
        static let RemoveService = "RemovedService_"
        static let ServiceOrder = "ServiceOrder_"
        static let DefaultUserService = "DefaultUserService_"
        static let PullToRefreshEnabled = "PullToRefreshEnabled_"
        static let ResultHighlightingEnabled = "ResultHighlightingEnabled_"
        static let LastWidgetDataSyncTime = "LastWidgetDataSyncTime_"
        static let IsWidgetDataSyncInProgress = "IsWidgetDataSyncInProgress_"
    }
    
    fileprivate static func getPrefKeyForUser(prefKey: String) -> String {
        let hashedUserID = HashGenerator.getMD5(ZohoSearchKit.sharedInstance().getCurrentUser().zuid)
        //return prefKey + ZohoSearchKit.sharedInstance().getCurrentUser().zuid
        return prefKey + hashedUserID;
    }
    
    static func clearAllUserPreferences() {
        var prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.LastWidgetDataSyncTime)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.IsWidgetDataSyncInProgress)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ServiceOrder)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.DefaultUserService)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.PullToRefreshEnabled)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ResultHighlightingEnabled)
        UserDefaults.standard.removeObject(forKey: prefKey)
    }
    
    //Removes only entries which are used internally to store the state of App, like Widget data sync status etc.
    //as for the newly logged in user we should fresh download the data
    static func clearDataSyncStatus() {
        var prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.LastWidgetDataSyncTime)
        UserDefaults.standard.removeObject(forKey: prefKey)
        prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.IsWidgetDataSyncInProgress)
        UserDefaults.standard.removeObject(forKey: prefKey)
    }
    
    //here for user means in case of multi user
    //also in this method itself we will find the current user
    //using ZohoSearchKit, not need to pass from the calling method
    static func getDefaultServiceForUser() -> String {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.DefaultUserService)
        if let defSerName = UserDefaults.standard.string(forKey: prefKey) {
            let decryptedServiceName = EncryptionHelper.decrypt(defSerName)
            return decryptedServiceName
            //return defSerName
        }
        return ZOSSearchAPIClient.ServiceNameConstants.All
    }

    

    static func setDefaultServiceForUser(serviceName: String) {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.DefaultUserService)
        let encryptedServiceName = EncryptionHelper.encrypt(serviceName)
        UserDefaults.standard.set(encryptedServiceName, forKey: prefKey)
        //UserDefaults.standard.set(serviceName, forKey: prefKey)
    }
    
    //here we might have to store comma separated instead of as array
    static func getOrderedServiceListForUser() -> [String]? {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ServiceOrder)
        
        if let commaSepServices = UserDefaults.standard.string(forKey: prefKey) {
            let decryptedServiceList = EncryptionHelper.decrypt(commaSepServices)
            let services = decryptedServiceList.components(separatedBy: ",")
            return services
        }
        //        if let serviceOrder = UserDefaults.standard.array(forKey: prefKey) {
        //            return serviceOrder as? [String]
        //        }
        return nil
    }
    
    static func setOrderedServiceListForUser(services: [String]) {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ServiceOrder)
        var commaSeparatedServiceList = ""
        for service in services {
            if !commaSeparatedServiceList.isEmpty {
                commaSeparatedServiceList = commaSeparatedServiceList + ","
            }
            commaSeparatedServiceList = commaSeparatedServiceList + service
        }
        let encryptedServiceList = EncryptionHelper.encrypt(commaSeparatedServiceList)
        UserDefaults.standard.set(encryptedServiceList, forKey: prefKey)
        //UserDefaults.standard.set(services, forKey: prefKey)
    }
    static func setRemovedServiceListForUser(services : [String]){
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.RemoveService)
        var commaSeparatedServiceList = ""
        for service in services {
            if !commaSeparatedServiceList.isEmpty {
                commaSeparatedServiceList = commaSeparatedServiceList + ","
            }
            commaSeparatedServiceList = commaSeparatedServiceList + service
        }
        let encryptedServiceList = EncryptionHelper.encrypt(commaSeparatedServiceList)
        UserDefaults.standard.set(encryptedServiceList, forKey: prefKey)
    }
    static func getRemovedServiceListForUser() -> [String]? {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.RemoveService)
        if let commaSepServices = UserDefaults.standard.string(forKey: prefKey) {
            let decryptedServiceList = EncryptionHelper.decrypt(commaSepServices)
            let services = decryptedServiceList.components(separatedBy: ",")
            return services
        }
        return nil
    }
    
    static func getCommaSeparatedServiceList() -> String {
        var commaSeparatedServiceList = ""
        if let services = UserPrefManager.getOrderedServiceListForUser() {
            for service in services {
                if !(service == ZOSSearchAPIClient.ServiceNameConstants.All) {
                    if !commaSeparatedServiceList.isEmpty {
                        commaSeparatedServiceList = commaSeparatedServiceList + ","
                    }
                    commaSeparatedServiceList = commaSeparatedServiceList + service
                }
            }
        }
        return commaSeparatedServiceList
    }
    
    //this includes the all service tab as well.
    static func getServiceNameForIndex(index: Int) -> String {
        if let services = UserPrefManager.getOrderedServiceListForUser(), index < services.count {
            return services[index]
        }
        return ""
    }
    
    static func isPullToRefreshEnabled() -> Bool {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.PullToRefreshEnabled)
        if let _ = UserDefaults.standard.object(forKey: prefKey) {
            return UserDefaults.standard.bool(forKey: prefKey)
        }
        //By default pull to refresh is enabled
        return true
    }
    
    static func setPullToRefreshEnabled(isEnabled: Bool) {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.PullToRefreshEnabled)
        UserDefaults.standard.set(isEnabled, forKey: prefKey)
    }
    
    static func isResultHighlightingEnabled() -> Bool {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ResultHighlightingEnabled)
        if let _ = UserDefaults.standard.object(forKey: prefKey) {
            return UserDefaults.standard.bool(forKey: prefKey)
        }
        //By default pull to refresh is enabled
        return true
    }
    
    static func setResultHighlightingEnabled(isEnabled: Bool) {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.ResultHighlightingEnabled)
        UserDefaults.standard.set(isEnabled, forKey: prefKey)
    }
    
    static func lastWidgetDataSyncTime() -> Int {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.LastWidgetDataSyncTime)
        //if the widget data has not be yet synced then 0 will be returned otherwise none 0 value will be returned
        return UserDefaults.standard.integer(forKey: prefKey)
    }
    
    static func setLastWidgetDataSyncTime(syncTime: Int) {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.LastWidgetDataSyncTime)
        UserDefaults.standard.set(syncTime, forKey: prefKey)
    }
    
    static func isWidgetDataSyncInProgress() -> Bool {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.IsWidgetDataSyncInProgress)
        if UserDefaults.standard.bool(forKey: prefKey) {
            return true
        }
        else {
            UserDefaults.standard.set(false, forKey: prefKey)
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    static func setWidgetDataSyncInProgress() {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.IsWidgetDataSyncInProgress)
        UserDefaults.standard.set(true, forKey: prefKey)
        UserDefaults.standard.synchronize()
    }
    
    static func setWidgetDataSyncFinished() {
        let prefKey = getPrefKeyForUser(prefKey: PrefKeysPrefix.IsWidgetDataSyncInProgress)
        UserDefaults.standard.set(false, forKey: prefKey)
        UserDefaults.standard.synchronize()
    }
    
}
