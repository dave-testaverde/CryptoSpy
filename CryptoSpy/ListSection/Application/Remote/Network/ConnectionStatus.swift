//
//  ConnectionStatus.swift
//  CryptoSpy
//
//  Created by Dave on 13/01/25.
//

import Alamofire

@Observable
class ConnectionStatus {
    private static let CONNECTION_STATUS_ENDPOINT = "www.coingecko.com"
    private static let DEFAULT_STATUS = "Offline"
    
    final let manager = NetworkReachabilityManager(host: CONNECTION_STATUS_ENDPOINT)
    
    var state: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    var stateLabel: String = DEFAULT_STATUS
    
    init(){
        manager?.startListening { [self] status in
            print("Network Status Changed: \(status)")
            state = status
            stateLabel = (status == .unknown || status == .notReachable) ? "Offline" : "Online"
        }
    }
}
