//
//  NetworkMonitoring.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

protocol NetworkMonitoring {
    var statusDidChange: ((NetworkStatus) -> Void)? { get set }
    func start()
    func stop()
}
