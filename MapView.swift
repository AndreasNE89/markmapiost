import SwiftUI
import Mapbox
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var annotations: [CustomPointAnnotation]
    
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations()
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate = centerCoordinate
        mapView.allowsZooming = false
        mapView.showsUserLocation = true
        mapView.showsUserHeadingIndicator = true
        mapView.userTrackingMode = .followWithHeading
        
        
        return self
    }
    
    func zoomLevel(_ zoomLevel: Double) -> MapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        
        for annotation in annotations {
            let point = CustomPointAnnotation(coordinate: annotation.coordinate, title: annotation.title, subtitle: annotation.subtitle)
            point.title = "tst"
            annotations.append(point)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
            // Instantiate and return our custom callout view.
            print("Opening callout")
            return CustomCalloutView(representedObject: annotation as! CustomPointAnnotation )
        }
        
        func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
            // Optionally handle taps on the callout.
            print("Tapped the callout for: \(annotation)")
            
            // Hide the callout.
            mapView.deselectAnnotation(annotation, animated: true)
        }
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            // This example is only concerned with point annotations.
            guard annotation is CustomPointAnnotation else {
                return nil
            }
            
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier, image: UIImage(named: "nature")!, imageText: UITextView(frame: CGRect(x:0, y: 0, width: 50, height: 10)))
                annotationView!.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
                
                // Set the annotation view’s background color to a value determined by its longitude.
                let hue = CGFloat(annotation.coordinate.longitude) / 100
                annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
            }
            
            return annotationView
        }
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
    }
    
}

