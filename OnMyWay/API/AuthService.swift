//
//  APIService.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/26/20.
//

import Firebase
import FirebaseUI
import FirebaseCore
import FirebaseFunctions
import FirebaseMessaging
import FirebaseABTesting
import FirebaseInstanceID
import FirebaseRemoteConfig


struct AuthService {
    
    static func signInWithAppleID(credential: AuthCredential, fullname: String, imageUrl: String, fcmToken: String, completion: @escaping(Error?) -> Void){
        Auth.auth().signIn(with: credential) { (authResult, error) in
       
            print("DEBUG: \(authResult?.user.uid)")
            print("DEBUG: \(fullname)")
            print("DEBUG: \(fcmToken)")
            print("DEBUG: \(imageUrl)")
            print("DEBUG: \(authResult?.user.email)")
            guard let user = authResult?.user else {return}
            
            let userData = ["userID": user.uid,
                            "userFcmToken": fcmToken,
                            "email": user.email,
                            "profileImageUrl": imageUrl,
                            "fullname": fullname,
                            "timestamp": Timestamp(date: Date())] as [String : Any]
            Firestore.firestore().collection("users").document(user.uid).setData(userData, completion: completion)
        }
    }
    
}
