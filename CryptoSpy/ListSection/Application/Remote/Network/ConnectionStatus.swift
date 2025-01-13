//
//  ConnectionStatus.swift
//  CryptoSpy
//
//  Created by Dave on 13/01/25.
//

import Alamofire

@Observable
class ConnectionStatus {
    let manager = NetworkReachabilityManager(host: host_for_connection_test)
    var state: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    init(){
        manager?.startListening { [self] status in
            print("Network Status Changed: \(status)")
            state = status
        }
    }
}
