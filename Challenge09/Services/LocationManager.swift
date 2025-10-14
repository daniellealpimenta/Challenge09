//
//  LocationManager.swift
//  Challenge09
//
//  Created by Wise on 14/10/25.
//

import Foundation
import CoreLocation
import MapKit


@Observable
class LocationManager: NSObject, CLLocationManagerDelegate{
    @ObservationIgnored let manager = CLLocationManager()
    var userlocation: CLLocation?
    var currentLocation: City?
    var isAuthorized = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func starLocationServices(){
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
            manager.startUpdatingLocation()
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didupdateLocations locations: [CLLocation]) {
        userlocation = locations.last
        if let userlocation {
            Task {
                let name = await getLocationName(location: userlocation)
                currentLocation = City(name: name, latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
            }
        }
        
        
    }
    
    func getLocationName(location:CLLocation) async -> String {
        var name: String? = nil
        // Feito com MK para evitar codigo depreciado
        if let request = MKReverseGeocodingRequest(location: location) {
            let mapitem = try? await request.mapItems.first?.name
            name = mapitem
        }
        return name ?? ""
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
        default:
            starLocationServices()
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}
