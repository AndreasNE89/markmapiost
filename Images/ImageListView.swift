//
//  ImageListView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 24/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Firebase

public struct imageTest {
    var id: String
    var title: String
    let imageUrl: String
    let userId: String
    var comments: [comment]?
}
struct ImageListView: View {
    @State public var imageData: imageTest
    @State var toggleImageView: Bool
    @State public var myUserName: String
    @State public var myUserId: String
    @State private var comments = [comment]()
    
    func grabComments() {
        Firestore.firestore().collection("users").document(imageData.userId).collection("images").document(imageData.id).collection("comments").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let fetchedData = document.data()
                    self.comments.append(comment(text: fetchedData["text"] as! String, creator: fetchedData["creator"] as! String, id: fetchedData["id"] as! String , commentId: fetchedData["commentId"] as! String))
                }
            }
        }
    }
    var body: some View {
        ZStack(alignment: .bottom){
            Button(action: {
                self.toggleImageView = !self.toggleImageView
            }) {
                KFImage(URL(string: imageData.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                
            }.buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $toggleImageView) {
                    ImageView(function: {self.grabComments()}, imageToView: self.imageData, myUserName: self.myUserName, myUserId: self.myUserId, comments: self.$comments)
            }.onAppear{
                self.grabComments()
            }
            .onDisappear{
                self.comments = []
            }
        }
    }
    struct ImageListView_Previews: PreviewProvider {
        static var previews: some View {
            ImageListView(imageData:imageTest(id: "6", title: "Awesome", imageUrl:"test", userId: "1", comments: [comment(text: testComment, creator: "Peter", id: "1", commentId: "2")]), toggleImageView: false, myUserName: "Andreas", myUserId: "1")
        }
    }
}
