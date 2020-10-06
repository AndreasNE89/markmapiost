//
//  LocationManager.swift
//  markmap
//
//  Created by Andreas Engebretsen on 13/07/2020.
//  Copyright © 2020 Andreas Engebretsen. All rights reserved.
//

import Foundation
import Mapbox
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    
    public func getMyLocation() -> CLLocation {
        locManager.requestWhenInUseAuthorization()

        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
        }
        return currentLocation
    }

}
