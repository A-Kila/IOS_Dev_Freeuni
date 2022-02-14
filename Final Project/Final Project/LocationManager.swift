//
//  LocationManager.swift
//  Final Project
//
//  Created by Andria Kilasonia on 14.02.22.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    
    static var shared = LocationManager()
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    private var locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}


extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        longitude = nil
        latitude = nil
    }
    
}
