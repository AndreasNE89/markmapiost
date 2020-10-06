//
//  ContentView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 12/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import Mapbox
import Firebase

struct image {
    let creator: String
    let imageId: Int
    let lat: Double
    let lng: Double
    let country: String
}

struct ContentView: View {
    @State var imageListData: [CustomPointAnnotation] = []
    @State var isLoggedIn = false
    @State var openCamera = false
    @State var openimageEdit = false
    @State var openImageTest = false

    @State var googleId = "111355122617791962300"
    @State private var image: UIImage? = nil
    
    let manager = LocationManager.init()
    let db = Firestore.firestore()
    
    func getImageLocations(){
        db.collection("images").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let customPoint = CustomPointAnnotation(coordinate: .init(latitude: document.data()["lat"] as! Double, longitude: document.data()["lng"] as! Double), title: document.data()["id"] as? String, subtitle: "")
                    self.imageListData.append(customPoint)
                }
            }
        }
    }
    func  checkIfAccountExists(accountId: String) {
        let docRef = db.collection("users").document(self.googleId)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    self.isLoggedIn = true                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    func annotationClicked(isClicked: Bool){
        self.openImageTest = isClicked
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MapView(annotations: $imageListData).centerCoordinate(.init(latitude: manager.getMyLocation().coordinate.latitude, longitude: manager.getMyLocation().coordinate.longitude)).zoomLevel(17)
                if image != nil {
                    EditImageView(resetImage: {
                        self.image = nil
                        self.getImageLocations()
                    }, takenImage: self.image, userId: self.googleId)
                }
                VStack{
                    HStack(spacing: 10){
                        if image == nil{
                            NavigationLink(destination: FriendsView()) {
                                ZStack{
                                    Image(systemName: "person.3")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                    Image(systemName: "circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.black)
                                }
                            }
                            .offset(y:10)
                            Spacer()
                            Button(action: {
                                self.openCamera = true
                            }) {
                                ZStack{
                                    Image(systemName: "circle")
                                        .font(.system(size: 50))
                                        .foregroundColor(.blue)
                                    Image(systemName: "circle")
                                        .font(.system(size: 70))
                                        .foregroundColor(.black)
                                }
                            }.sheet(isPresented: self.$openCamera){
                                CameraView(isShown: self.$openCamera, image: self.$image)
                            }
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: GalleryView(userId: self.googleId)) {
                                ZStack{
                                    Image(systemName: "circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.black)
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                }
                                
                            }
                            .offset(y:10)}
                        
                    }.onAppear {
                        self.getImageLocations()
                        self.checkIfAccountExists(accountId: self.googleId)
                    }
                    .offset(y:-60)
                    .frame(maxWidth: 200, maxHeight: .infinity, alignment: .bottom)
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: HStack {ProfileIcon()}, trailing: LogInView())
        }
        
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
