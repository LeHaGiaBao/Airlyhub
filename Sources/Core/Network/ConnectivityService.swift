import Foundation
import Network

protocol ConnectivityServiceDelegate: AnyObject {
    func connectivityDidChange(isConnected: Bool)
}

class ConnectivityService {
    static let shared = ConnectivityService()

    private let monitor = NWPathMonitor()
    private var isConnected = true

    weak var delegate: ConnectivityServiceDelegate?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newConnectionState = path.status == .satisfied
            if newConnectionState != self.isConnected {
                self.isConnected = newConnectionState
                self.delegate?.connectivityDidChange(isConnected: self.isConnected)
            }
        }
        let queue = DispatchQueue(label: "ConnectivityMonitor")
        monitor.start(queue: queue)
    }

    func isNetworkAvailable() -> Bool {
        return isConnected
    }
}
