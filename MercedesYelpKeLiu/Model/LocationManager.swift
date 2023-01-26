//
//  LocationManager.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    
    let publisher = PassthroughSubject<Void, Never>()
    
    var didFailToRetrieveLocation = false
    var lat: Double?
    var lon: Double?
    
    private let locationManager = CLLocationManager()
    
    func startObservingLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func fail() {
        lat = nil
        lon = nil
        didFailToRetrieveLocation = true
        publisher.send()
    }
    
    private func success(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        didFailToRetrieveLocation = false
        publisher.send()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            fail()
            return
        }
        
        success(lat: location.coordinate.latitude,
                lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fail()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        default:
            fail()
        }
    }
}
