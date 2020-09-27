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
import GoogleSignIn


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
    
    static func signInWithGoogle(didSignInfo user: GIDGoogleUser, completion: @escaping(Error?) -> Void){
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("DEBUG: error while sing user with Google account \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            guard let userID = authResult?.user.uid else {return}
            
            Firestore.firestore().collection("users").document(userID).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {return}
                if !snapshot.exists {
                    guard let email = authResult?.user.email else { return  }
                    guard let fullname = authResult?.user.displayName else { return  }
                    guard let imageUrl = authResult?.user.photoURL?.absoluteString else { return  }
                    let userData = ["userID": userID,
                                    "userFcmToken": fcmToken,
                                    "email": email,
                                    "profileImageUrl": imageUrl,
                                    "fullname": fullname.lowercased(),
                                    "timestamp": Timestamp(date: Date())] as [String : Any]
                    Firestore.firestore().collection("users").document(userID).setData(userData, completion: completion)
                } else {
                    print("DEBUG: user is already exist")
                    completion(error)
                }
                
            }
        }
    }
    
}
