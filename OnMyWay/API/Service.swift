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



struct Service {
    
    
    static func uploadImage(withImage image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.70) else { return }
        let imageUUID = NSUUID().uuidString
        let storageReference = Storage.storage().reference(withPath: "/images/\(imageUUID)")
        storageReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: error while uploading photo with \(error.localizedDescription)")
                return
            }
            storageReference.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
