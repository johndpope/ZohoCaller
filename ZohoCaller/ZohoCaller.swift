//
//  ZohoCaller.swift
//  ZohoCaller
//
//  Created by manikandan bangaru on 25/07/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//

import Foundation
import ZohoSearchKit
import CallKit
import UIKit
import PushKit
@available(iOS 10.0, *)
class ZohoCaller : CXCallDirectoryProvider , CXProviderDelegate , PKPushRegistryDelegate
{
    override init() {
        super.init()
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]
    }
    func providerDidReset(_ provider: CXProvider) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        let config = CXProviderConfiguration(localizedName: "Zoho Caller")
        config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "zoho")!)
        config.ringtoneSound = "ringtone.caf"
        if #available(iOS 11.0, *) {
            config.includesCallsInRecents = false
        } else {
            // Fallback on earlier versions
        };
        config.supportsVideo = true;
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "zoho search")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }
    //Receiving an Incoming Call
    // MARK: PKPushRegistryDelegate
//    override func viewDidLoad() {
//
//        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "Zoho Caller"))
//
//        provider.setDelegate(self, queue: nil)
//        let update = CXCallUpdate()
//        update.remoteHandle = CXHandle(type: .generic, value: "Zoho Caller")
//        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
//    }
    
    func getcontactDetails(phoneNumber : String) {
       _ =  ZOSSearchAPIClient.sharedInstance().getSearchResults(phoneNumber, mentionedZUID: nil, filters: nil, serviceName: "people", oAuthToken: "oauthtoken", completionHandlerForSearchResp: {
            (searchResults , error) in
            guard error != nil
            else {
                return
            }
            print("Zoho People Search results")
            print(searchResults!)
        })
    }
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        let labelsKeyedByPhoneNumber: [CXCallDirectoryPhoneNumber: String] = [CXCallDirectoryPhoneNumber(exactly: 8695860483)! : "Manikandan Bangaru mani" ,CXCallDirectoryPhoneNumber(exactly: 8695860482)! : "Manikandan Bangaru ban"  ]
        for (phoneNumber, label) in labelsKeyedByPhoneNumber.sorted(by: <) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
        context.completeRequest()
        super.beginRequest(with: context)
    }
}
//@available(iOS 10.0, *)
//class ZohoCallerDirectoryProvider : CXCallDirectoryProvider {
//
//}

