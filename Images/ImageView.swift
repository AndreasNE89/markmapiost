//
//  ImageView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 28/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
let testComment = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
let testImage = "https://firebasestorage.googleapis.com/v0/b/leave-a-mark.appspot.com/o/111355122617791962300%2F8AA9119E-F552-4847-B7CD-DBAC58EB050A?alt=media&token=1d8cb4f3-87d9-4334-8081-0a3e41ce9103"

struct upvote: Codable, Equatable {
    let userId: String
}

struct ImageView: View {
    var function: () -> Void
    @State public var imageToView: imageTest
    @State private var isLiked = false
    @State private var writtenComment: String = ""
    @State private var commentsExist: Bool = false
    @State public var myUserName: String
    @State public var myUserId: String
    @Binding var comments: [comment]
    @State var upvotes = [upvote]()
    @State var seen = 0
    
    let db = Firestore.firestore()
    let commentHandler = DatabaseHandler.init()
    
    func addComment(newComment: comment){
        do{
            try self.db.collection("users").document(self.myUserId).collection("images").document(self.imageToView.id).collection("comments").addDocument(from: newComment).addSnapshotListener{snap, err in
                guard let document = snap else {
                    print("Error fetching document")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.comments.append(comment(text: data["text"] as! String, creator: data["creator"] as! String, id: data["id"] as! String ,commentId: data["commentId"] as! String))
            }
        } catch let err {
            print(err)
        }        
        //commentHandler.addComment(userId: self.myUserId, imageId: imageToView.id, newComment: newComment)
    }
    func updateViews(){
        let documentRef = self.db.collection("users").document(self.myUserId).collection("images").document(self.imageToView.id)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(documentRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let seen = sfDocument.data()?["seen"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve seen from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            transaction.updateData(["seen": seen + 1], forDocument: documentRef)
            self.seen = seen
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        
        
        //self.db.collection("users").document(self.myUserId).collection("images").document(self.imageToView.id).updateData(["seen": data["seen"] as! Int + 1])
        
    }
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .center){
                GeometryReader{ geo in
                    KFImage(URL(string: self.imageToView.imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width, height: 350)
                }
            }.frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading){
                Text("Image views: " + String(self.seen)).offset(y: 10)
                List(self.comments, id: \.commentId ){ comment in
                    HStack(alignment: .top){
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 25)).offset(y:5)
                        Text(comment.creator + ": ")
                        Text(comment.text)
                    }.offset(x: 10)
                }
            }
            HStack{
                TextField("Add comment", text: $writtenComment)
                    .offset(x: 10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame( maxWidth: 400,alignment: .center)
                Button(action: {
                    let commentId = UUID().uuidString
                    self.addComment(newComment:comment(text: self.writtenComment, creator: self.myUserName, id: self.myUserId, commentId: commentId))
                    self.writtenComment = ""
                    
                }){
                    Text("Add comment")
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top).offset(y:20)
            .onAppear{
                self.updateViews()
        }
    }
    
   /*struct ImageView_Previews: PreviewProvider {
        static var previews: some View {
            ImageView(function: {print("Grabbing comments")}, imageToView:imageTest(id: "6", title: "Awesome", imageUrl: testImage, userId: "2", comments: [comment(text: testComment, creator: "Peter", id: "1", commentId: "2")]))
        }
    }*/
}
