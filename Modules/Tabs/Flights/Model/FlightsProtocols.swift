//
//  FlightsProtocols.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

protocol FlightsViewProtocol: AnyObject {
    func setLocation(_ location: LocationResult, for field: LocationField)
    func showLocationError(_ error: LocationServiceError)
}

protocol FlightsPresenterProtocol {
    func viewDidLoad()
    func fetchMyLocation(for field: LocationField)
}

protocol FlightsInteractorProtocol {
    func fetchCurrentLocation(completion: @escaping (Result<LocationResult, LocationServiceError>) -> Void)
}

protocol FlightsRouterProtocol: AnyObject {}
