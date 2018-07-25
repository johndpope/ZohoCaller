//
//  ChatResult.swift
//  ZohoSearchLogin
//
//  Created by hemant kumar s. on 06/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

// MARK: For SDK.

// MARK: - ChatResult

class ChatResult: SearchResult {
    
    // MARK: Properties
    let chatID: String
    let chatTitle: String
    let recentParticipants: String?
    let accountID: String
    let participantCount: Int?
    let messageTime: Int64
    let chatOwnerName: String
    let chatOwnerEmail: String
    let  getImageZUID : Int64
    // MARK: Initializers
    
    // construct a ChatResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        chatID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.ChatID] as! String
        
        //chatTitle = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.ChatTitle] as! String
        if let chatTitleStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.ChatTitle] as? String, chatTitleStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            chatTitle = chatTitleStr.decodedHTMLEntities()
        } else {
            chatTitle = ""
        }
        
        if let chatOwnerStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.OwnerName] as? String, chatOwnerStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            chatOwnerName = chatOwnerStr.decodedHTMLEntities()
        } else {
            chatOwnerName = ""
        }
        
        if let chatOwnerEmailStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.OwnerEmail] as? String, chatOwnerEmailStr.isEmpty == false {
            //MARK: Decoded(HTML tags) chat title
            chatOwnerEmail = chatOwnerEmailStr.decodedHTMLEntities()
        } else {
            chatOwnerEmail = ""
        }
        
        recentParticipants = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.RecentParticipants] as? String
        accountID = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.AccountID] as! String
        if let participantCountStr = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.ParticipantCount] as? String {
            participantCount = Int(participantCountStr)
        }
        else {
            participantCount = -1
        }
        
        messageTime = dictionary[ZOSSearchAPIClient.SearchResponseJSONKeys.ChatsSearchResult.RecievedTime] as! Int64

        if participantCount! < 3 {
            let zuids = recentParticipants?.components(separatedBy: ",")
            //for now hardcoded, this should be current user zuid
            //let currentUserZUID = ZohoSearchKit.sharedInstance().getCurrentUser().zuid
            let currentUserZUID = ZohoSearchKit.sharedInstance().getCurrentUserZUID()
            if let count = zuids?.count, count > 1 && zuids![0] == currentUserZUID {
                getImageZUID  =  Int64(zuids![1])!
            }
            else if let count = zuids?.count, count > 1 && zuids![1] == currentUserZUID {
                getImageZUID  =  Int64(zuids![0])!
            }
            else
            {
                 getImageZUID  =  -1
            }
        }
        else
        {
            getImageZUID  =  -1
        }
        super.init(entityID: chatID)
    }
    
//    func getImageZUID() -> Int64 {
//        if participantCount! < 3 {
//            let zuids = recentParticipants?.components(separatedBy: ",")
//            //for now hardcoded, this should be current user zuid
//            //let currentUserZUID = ZohoSearchKit.sharedInstance().getCurrentUser().zuid
//            let currentUserZUID = ZohoSearchKit.sharedInstance().getCurrentUserZUID()
//            if let count = zuids?.count, count > 1 && zuids![0] == currentUserZUID {
//                return Int64(zuids![1])!
//            }
//            else if let count = zuids?.count, count > 1 && zuids![1] == currentUserZUID {
//                return Int64(zuids![0])!
//            }
//        }
//        return -1
//    }
//
    static func chatResultsFromResponse(_ results: [[String:AnyObject]]) -> [ChatResult] {
        
        var chatResults = [ChatResult]()
        
        // iterate through array of dictionaries, each ChatResult is a dictionary
        for result in results {
            chatResults.append(ChatResult(dictionary: result))
        }
        
        return chatResults
    }
}

// MARK: - ChatResult: Equatable

extension ChatResult: Equatable {}

func ==(lhs: ChatResult, rhs: ChatResult) -> Bool {
    return lhs.chatID == rhs.chatID
}
