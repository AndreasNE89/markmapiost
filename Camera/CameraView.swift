//
//  CameraView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 15/06/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI

class imagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
        _isShown = isShown
        _image = image
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = uIImage
        isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct CameraView: UIViewControllerRepresentable{
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> imagePickerCoordinator{
        return imagePickerCoordinator(isShown: $isShown, image: $image)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .camera
        }
        return picker
    }
    
   
}
