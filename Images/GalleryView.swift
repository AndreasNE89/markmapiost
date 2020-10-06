//
//  GalleryView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 14/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import KingfisherSwiftUI


struct GalleryView: View {
    @State public var userId = ""
    @State private var fetchedImageList = [fetchedImage]()
    var fallbackImage = UIImage(imageLiteralResourceName: "test")
    @State var imageViewer: UIImageView!
    
    func fetchImagesIds(){
        Firestore.firestore().collection("users").document(self.userId).collection("images").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let fetchedData = document.data()
                    self.fetchedImageList.append(fetchedImage(id: fetchedData["id"] as! String, imageUrl: fetchedData["imageUrl"] as! String, imageCaption: fetchedData["caption"] as! String, userId: fetchedData["userId"] as! String))
                }
            }
        }
    }
    
    
    var body: some View {
        NavigationView() {
            VStack(alignment:.leading){
                List(self.fetchedImageList, id: \.id) {imageData  in
                    ImageListView(imageData:imageTest(id: imageData.id, title: imageData.imageCaption, imageUrl: imageData.imageUrl, userId: self.userId), toggleImageView: false, myUserName: "Andreas", myUserId: self.userId)
                }.frame(maxWidth: .infinity, alignment: .center)
            }.navigationBarTitle("Gallery").onAppear{
                self.fetchImagesIds()
            }
        }
    }
    
    
    struct GalleryView_Previews: PreviewProvider {
        static var previews: some View {
            GalleryView(userId: "111355122617791962300")
        }
    }
}


