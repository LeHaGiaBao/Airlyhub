//
//  NetworkMonitor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import Network

final class NetworkMonitor: NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "network.monitor")

    var statusDidChange: ((NetworkStatus) -> Void)?

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            let status: NetworkStatus = path.status == .satisfied ? .connected : .disconnected
            self?.statusDidChange?(status)
        }
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}
