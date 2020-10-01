//
//  Service.swift
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
import JGProgressHUD
import ProgressHUD

public let kFILEREFERENCE = "gs://mapandphoto-4f7b3.appspot.com"

struct Service {
    
    
    static func updateProfileImage(withImage image: UIImage, userID: String, completion: ((Error?) -> Void)?) {
        uploadProfileImageView(withImage: image, userID: userID) { imageUrl in
            let userData = ["profileImageUrl" : imageUrl]
            Firestore.firestore().collection("users").document(userID).setData(userData, merge: true, completion: completion)
        }
    }
    
    
    static func uploadProfileImageView(withImage image: UIImage, userID: String? = nil, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.70) else { return }
        guard let userID = userID else { return }
        let imageUUID = NSUUID().uuidString
        let storageReference = Storage.storage().reference(withPath: "ProfileImages/\(userID.isEmpty ? imageUUID : userID)")
        var task: StorageUploadTask!
        
        task =  storageReference.putData(imageData, metadata: nil) { (metadata, error) in
            task.removeAllObservers()
            if let error = error {
                print("DEBUG: error while uploading photo with \(error.localizedDescription)")
                return
            }
            storageReference.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
            
        }
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            guard let completedUnitCount = snapshot.progress?.completedUnitCount else {return}
            guard let totalUnitCount = snapshot.progress?.totalUnitCount else {return}
            ProgressHUD.showProgress(CGFloat(completedUnitCount / totalUnitCount))
        }
        
    }
}
