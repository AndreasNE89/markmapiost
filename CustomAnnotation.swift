//
//  CustomAnnotation.swift
//  markmap
//
//  Created by Andreas Engebretsen on 15/07/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import Foundation
import Mapbox


// MGLAnnotation protocol reimplementation
class CustomPointAnnotation : NSObject, MGLAnnotation {
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // Custom properties that we will use to customize the annotation's image.
    var reuseIdentifier: String?
    var border: CGRect?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}

class CustomAnnotationView: MGLAnnotationView {
    var annotationTextView: UITextView?
    var imageText: UITextView?
    var viewFrame: CGRect?
    var imageView: UIImageView!
    var image: UIImage?
    
    required init(reuseIdentifier: String?, image: UIImage, imageText: UITextView?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.imageView = UIImageView(image: image)
        self.imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
        self.imageText?.text = "Test"
        self.addSubview(self.imageView)
        self.frame = self.imageView.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
