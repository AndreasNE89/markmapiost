//
//  ProfileIcon.swift
//  markmap
//
//  Created by Andreas Engebretsen on 12/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ProfileIcon: View {
   var ref = Database.database().reference()
    var body: some View {
        HStack{
            Button(action: {
                self.ref.child("users").child("1337").setValue(["username": "Andreas"])
                
            }) {
                Image(systemName: "person.crop.circle")
                .font(.system(size: 40))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
    }
    
}

struct ProfileIcon_Previews: PreviewProvider {
    static var previews: some View {
        ProfileIcon()
    }
}
