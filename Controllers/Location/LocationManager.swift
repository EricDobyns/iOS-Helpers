//
//  LocationManager.swift
//  LE
//
//  Created by Luis Garcia on 3/12/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate {
    func getCurrentLocation(currentLocation: CLLocation)
    func locationRetrievalDidFailWith(error: Error)
}

enum LocationError: Error {
    case userDenied
    case userRestricted
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        
        guard let locationManager = self.locationManager else { return }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    //LocationManager delegate methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationRetrievalDidFailWith(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.lastLocation = location
        self.delegate?.getCurrentLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.requestLocation()
            break
        case .authorizedAlways:
            locationManager?.requestLocation()
            break
        case .restricted:
            self.delegate?.locationRetrievalDidFailWith(error: LocationError.userRestricted)
            break
        case .denied:
            self.delegate?.locationRetrievalDidFailWith(error: LocationError.userDenied)
            break
        }
    }
}
