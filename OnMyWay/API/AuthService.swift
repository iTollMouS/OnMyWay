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


struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImageView: UIImage
}

struct AuthService {
    
    
    static func resetPassword(withEmail email: String, completion: @escaping(Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) -> Void)){
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (authResult, error) in
                if let error = error {
                    print("DEBUG: error while register new user \(error.localizedDescription)")
                    return
                }
                guard let user = authResult else {return}
                Service.uploadProfileImageView(withImage: credentials.profileImageView, userID: user.user.uid) { imageUrl in
                guard let fcmToken = Messaging.messaging().fcmToken else {return}
                let userData = ["userID": user.user.uid,
                                "userFcmToken": fcmToken,
                                "email": credentials.email,
                                "profileImageUrl": imageUrl,
                                "password": credentials.password,
                                "fullname": credentials.fullname.lowercased(),
                                "pushID": "",
                                "timestamp": Timestamp(date: Date())] as [String : Any]
                emailVerification(withEmail: credentials.email, userResult: user)
                Firestore.firestore().collection("users").document(user.user.uid).setData(userData, completion: completion)
                
            }
            
        }
        
    }
    
    static func signInWithAppleID(credential: AuthCredential, fullname: String, imageUrl: String, fcmToken: String, completion: @escaping(Error?) -> Void){
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            guard let user = authResult?.user else {return}
            let userData = ["userID": user.uid,
                            "userFcmToken": fcmToken,
                            "email": user.email,
                            "profileImageUrl": imageUrl,
                            "fullname": fullname.lowercased(),
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
    
    static func emailVerification(withEmail: String, userResult: AuthDataResult){
        userResult.user.sendEmailVerification { error in
            if let error = error {
                print("DEBUG: error while verifying email\(error.localizedDescription)")
                return
            }
        }
    }
    
}
