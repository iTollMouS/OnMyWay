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

public let userDefault = UserDefaults.standard

struct Service {
    
    
    static func fetchUser(withUid userID: String, completion: @escaping(User) -> Void){
        Firestore.firestore().collection("users").document(userID).getDocument { (snapshot, error) in
            if let error = error {
                print("DEBUG: failed to get user info with \(error.localizedDescription)")
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(userID: userID, dictionary: dictionary)
            completion(user)
        }
    }
    
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
    
    static func downloadImage(imageUrl: String, completion: @escaping(_ image: UIImage?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        if fileExistsAtPath(path: imageFileName) {
            if let contentOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                
                completion(contentOfFile)
            } else {
                print("DEBUG: error getting image")
                completion(#imageLiteral(resourceName: "plus_photo"))
            }
        } else {
            if imageUrl != "" {
                let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDowloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        Service.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    } else {
                        print("DEBUG: No document in database ")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    static func saveFileLocally(fileData: NSData, fileName: String){
        let docUrl =  getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
    
}

func fileInDocumentsDirectory(fileName: String) ->  String{
    return getDocumentsURL().appendingPathComponent(fileName).path
}

func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
