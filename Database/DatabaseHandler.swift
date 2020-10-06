//
//  DatabaseHandler.swift
//  markmap
//
//  Created by Andreas Engebretsen on 11/07/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Mapbox
struct imageSavable: Codable {
    let lat: Double
    let lng: Double
    let id: String
    let userId: String
}

public struct comment: Codable {
    let text: String
    let creator: String
    let id: String
    let commentId : String
}

struct fetchedImage: Identifiable {
    let id: String
    let imageUrl: String
    let imageCaption: String
    let userId: String
}

class DatabaseHandler: NSObject, CLLocationManagerDelegate {
    let dbFirestore = Firebase.Firestore.firestore()
    let dbStorage = Storage.storage()
    let manager = LocationManager.init()

    public func addImage(sender: String, userId: String, imageId: String, imageData: UIImage?, caption: String, mapImagesCallback: @escaping () -> Void){
        guard let data = imageData?.jpegData(compressionQuality: 0.30) else { return }
        
        let imageRef = dbStorage.reference()
            .child(userId)
            .child(imageId)
        
        imageRef.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                return
            }
            imageRef.downloadURL(completion:{(url, err) in
                if err != nil {
                    return
                }
                if let url = url {
                    let lat = self.manager.getMyLocation().coordinate.latitude
                    let lng = self.manager.getMyLocation().coordinate.longitude

                    let imageToSave = imageDataSavable(id: imageId, lat: lat, lng: lng, caption: caption, userId: userId, imageUrl: url.absoluteString, seen: 1)
                    let imageLocationData = imageSavable(lat: lat, lng: lng, id: imageId, userId: userId)
                    do {
                        print("Saving image")
                        try self.dbFirestore.collection("images").document(imageId).setData(from: imageLocationData)
                        try self.dbFirestore.collection("users").document(userId).collection("images").document(imageId).setData(from: imageToSave)
                        
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                }
                
            })
        }.observe(.success) { snapshot in
            print("Image has been saved")
            mapImagesCallback()
        }
        
    }

    public func addComment(userId: String, imageId: String, newComment: comment){
        do{
            try self.dbFirestore.collection("users").document(userId).collection("images").document(imageId).collection("comments").addDocument(from: newComment).addSnapshotListener{snap, err in
                guard let document = snap else {
                    print("Error fetching document")
                    return
                }
                guard document.data() != nil else {
                    print("Document data was empty.")
                    return
                }
            }
        } catch let err {
            print(err)
        }
        
    }
    
}
