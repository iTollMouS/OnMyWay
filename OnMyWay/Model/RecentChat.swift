//
//  RecentChat.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/2/20.
//

import Foundation
import FirebaseFirestoreSwift


struct RecentChat {
    
    @ServerTimestamp var date = Date()
    var id : String
    var chatRoomId : String
    var senderName: String
    var receiverName: String
    var senderId: String
    var receiverId: String
    var memberIds: [String]
    var lastMessage: String
    var unreadCounter: Int
    var profileImage: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.chatRoomId = dictionary["chatRoomId"] as? String ?? ""
        self.senderName = dictionary["senderName"] as? String ?? ""
        self.receiverName = dictionary["receiverName"] as? String ?? ""
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.receiverId = dictionary["receiverId"] as? String ?? ""
        self.memberIds = dictionary["memberIds"] as? [String] ?? [""]
        self.lastMessage = dictionary["lastMessage"] as? String ?? ""
        self.unreadCounter = dictionary["unreadCounter"] as? Int ?? 0
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        
    }
    
}

