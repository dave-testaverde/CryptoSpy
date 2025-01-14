//
//  ConnectionStatus.swift
//  CryptoSpy
//
//  Created by Dave on 13/01/25.
//

import Alamofire

@Observable
class ConnectionStatus {
    final let manager = NetworkReachabilityManager(host: host_for_connection_test)
    
    var state: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    var stateLabel: String = "Offline"
    
    init(){
        manager?.startListening { [self] status in
            print("Network Status Changed: \(status)")
            state = status
            stateLabel = (status == .unknown || status == .notReachable) ? "Offline" : "Online"
        }
    }
}
