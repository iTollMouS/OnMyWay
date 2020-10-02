//
//  StartChat.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/2/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

func StartChat(user1: User, user2: User) -> String {
    let chatRoomId = chatRoomIdFrom(user1Id: user1.userID, user2Id: user2.userID)
    createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
    return chatRoomId
}

func createRecentItems(chatRoomId: String, users: [User]) {
    
    guard let user1 = users.first?.userID else { return }
    guard let user2 = users.last?.userID else { return }
    
    var memberIdsToCreateRecent = [user1, user2]
    
    Firestore.firestore().collection("recent").whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {return}
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIDs: memberIdsToCreateRecent)
        }
        for userID in memberIdsToCreateRecent {
            
            
        }
    }
}

func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIDs: [String]) -> [String] {
    var memberIDsToCreateRecent = memberIDs
    for recentData in snapshot.documents {
        let currentRecent = recentData.data() as Dictionary
        if let currentUserId = currentRecent["senderId"] {
            if memberIDsToCreateRecent.contains(currentUserId as? String ?? "") {
                memberIDsToCreateRecent.remove(at: memberIDsToCreateRecent.firstIndex(of: currentUserId as! String)!)
            }
        }
    }
    return memberIDsToCreateRecent
}

func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
    var chatRoomId = ""
    let value = user1Id.compare(user2Id).rawValue
    chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    return chatRoomId
}
