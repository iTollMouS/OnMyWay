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
    var profileImageView: String
    var phoneNumber: String
    var email: String
    var basePrice: String
    var userReviews: Int
    var password: String
    var userBio: String
    
    var isCurrentUser: Bool{return Auth.auth().currentUser?.uid == userID}
    
    init(userID: String, dictionary: [String: Any]) {
        self.userID = dictionary["userID"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageView = dictionary["profileImageView"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.basePrice = dictionary["basePrice"] as? String ?? ""
        self.userReviews = dictionary["userReviews"] as? Int ?? 0
        self.password = dictionary["password"] as? String ?? ""
        self.userBio = dictionary["userBio"] as? String ?? ""
    }
    
}

