//
//  NetworkManager.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 13/06/24.
//

import Foundation
import Network


class NetworkManager: ObservableObject{
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    var imageName: String{
        return isConnected ? "wifi" : "wifi.slash"
    }
    var textConnection: String{
        if isConnected{
            return "Your wifi connection is good"
        } else {
            return "Your wifi connection is running low"
        }
        
    }
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async{
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
