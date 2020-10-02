//
//  User.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/1/20.
//

import Foundation
import Firebase
import FirebaseAuth


struct User {
    let userID: String
    var fullname: String
    var profileImageUrl: String
    var phoneNumber: String
    var email: String
    var basePrice: String
    var userReviews: Int
    var password: String
    var userBio: String
    let pushID: String
    
    static var isCurrentUser: String{
        guard let userID = Auth.auth().currentUser?.uid else {return ""}
        return  userID}
    
    init(userID: String, dictionary: [String: Any]) {
        self.userID = dictionary["userID"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.basePrice = dictionary["basePrice"] as? String ?? ""
        self.userReviews = dictionary["userReviews"] as? Int ?? 0
        self.password = dictionary["password"] as? String ?? ""
        self.userBio = dictionary["userBio"] as? String ?? ""
        self.pushID = dictionary["pushID"] as? String ?? ""
    }
    
}

