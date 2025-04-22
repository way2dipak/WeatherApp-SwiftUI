//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Dipak Singh on 22/10/23.
//

import Combine
import CoreLocation

enum LocationError: Error {
    case noPermission
    case locationNotFound
    case locationError(Error)
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    @Published var location: CLLocation?
    @Published var currentPosition: GeoPositionModel?
    
    private let locationManager = CLLocationManager()
    
    private var locationSubject = PassthroughSubject<CLLocation, Never>()
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    private var errorSubject = PassthroughSubject<LocationError, Never>()
    var errorPublisher: AnyPublisher<LocationError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            errorSubject.send(.noPermission)
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            self.locationSubject.send(location)
        } else {
            errorSubject.send(.locationNotFound)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorSubject.send(.locationError(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .notDetermined:
            break
        default:
            errorSubject.send(.noPermission)
        }
    }
}

extension LocationManager {
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    //self.locationSubject.send(city)
                } else if let area = placemark.subLocality {
                    //self.locationSubject.send(area)
                } else {
                    fatalError("City name not found 💣")
                }
            }
        }
    }
    
    func isDefaultCity(latitude: Double?,
                       longitude: Double?) -> Bool {
        guard let latitude = latitude,
              let longitude = longitude,
              let location = location else { return false }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        
        return location.coordinate.latitude == coordinate.latitude &&
        location.coordinate.longitude == coordinate.longitude
        
    }
}
