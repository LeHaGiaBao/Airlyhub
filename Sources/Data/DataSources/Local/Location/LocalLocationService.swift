//
//  LocalLocationService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import CoreLocation

enum LocationServiceError: Error {
    case denied
    case failed
}

final class LocalLocationService: NSObject {
    static let shared = LocalLocationService()

    private let locationManager = CLLocationManager()
    private var completion: ((Result<LocationResult, LocationServiceError>) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestCurrentLocation(completion: @escaping (Result<LocationResult, LocationServiceError>) -> Void) {
        self.completion = completion

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            finish(.failure(.denied))
        @unknown default:
            finish(.failure(.failed))
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first else {
                self?.finish(.failure(.failed))
                return
            }
            let city = placemark.locality ?? placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            self?.finish(.success(LocationResult(city: city, country: country)))
        }
    }

    private func finish(_ result: Result<LocationResult, LocationServiceError>) {
        DispatchQueue.main.async { [weak self] in
            self?.completion?(result)
            self?.completion = nil
        }
    }
}

extension LocalLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            finish(.failure(.denied))
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeocode(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(.failure(.failed))
    }
}
