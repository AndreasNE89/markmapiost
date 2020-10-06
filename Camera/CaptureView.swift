//
//  CaptureView.swift
//  markmap
//
//  Created by Andreas Engebretsen on 05/07/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import SwiftUI

struct CaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var image: UIImage?
    
    var body: some View {
        CameraView(isShown: $showImagePicker, image: $image)
        }
    }
