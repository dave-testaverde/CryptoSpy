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
    
    var state: NetworkReachabilityManager.NetworkReachabilityStatus
    var stateLabel: String
    
    init(
        state: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown,
        failConnection: Bool = false
    ){
        self.state = state
        self.stateLabel = (state == .unknown || state == .notReachable) ? "Offline" : "Online"
        
        if !failConnection {
            manager?.startListening { [self] status in
                update(by: status)
            }
        }
    }
    
    func update(by status: NetworkReachabilityManager.NetworkReachabilityStatus){
        state = status
        stateLabel = (status == .unknown || status == .notReachable) ? "Offline" : "Online"
    }
}
