//
//  EditImageView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 04/07/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import Mapbox

public struct imageDataSavable : Codable {
    var id: String
    var lat: Double
    var lng: Double
    var caption: String
    let userId: String
    var imageUrl: String
    var seen: Int
}

struct EditImageView: View {
    var resetImage:(() -> Void)
    @State public var takenImage: UIImage?
    @State private var titleText = ""
    @State private var isOpen = false
    @State public var editorIsOpen: Bool = false
    @State public var userId: String
    let imageID = UUID().uuidString
    var fallbackImage = UIImage(imageLiteralResourceName: "test")
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let imageHandler = DatabaseHandler.init()
    
    func saveImageToDb(sender: String){
        imageHandler.addImage(sender: sender, userId: self.userId, imageId: imageID, imageData: self.takenImage, caption: self.titleText,mapImagesCallback: {self.resetImage()} )
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                Image(uiImage: (self.takenImage != nil ? self.takenImage! : fallbackImage)).resizable().scaledToFit()
                HStack(alignment: .top){
                    TextField("Write a caption...", text: $titleText)
                        .frame( maxWidth: 300, alignment: .center)
                }
                Text("Where do you want to leave the image?").padding(.bottom)
                HStack{
                    Button(action: {
                        self.saveImageToDb(sender: "current")
                        
                    }) {
                        Text("Current location")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .offset(x: 10)
                    Spacer()
                    Button(action: {
                        self.saveImageToDb(sender: "random")
                    }) {
                        Text("Random Location")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .offset(x: -10)
                }
            }
        }
    }
}

struct EditImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditImageView( resetImage: {print("Resetting image")}, userId: "111355122617791962300")
    }
}
