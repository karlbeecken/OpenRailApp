//
//  LocationModel.swift
//  OpenRail
//
//  Created by Karl Beecken on 24.11.22.
//

import CoreLocation
import Foundation

class LocationModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var coords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(52.520, 13.405)

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuthorisation(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }


    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        
        if status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations _: [CLLocation]) {
        print("Updated Location")
        coords.latitude = (manager.location?.coordinate.latitude)!
        coords.longitude = (manager.location?.coordinate.longitude)!
    }
}
