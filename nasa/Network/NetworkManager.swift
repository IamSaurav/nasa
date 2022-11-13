//
//  NetworkManager.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    var isConnected: Bool = true
    private init() {}
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
                print("Online")
            } else {
                self.isConnected = false
                print("Offline")
            }
        }
        monitor.start(queue: queue)
    }
}
