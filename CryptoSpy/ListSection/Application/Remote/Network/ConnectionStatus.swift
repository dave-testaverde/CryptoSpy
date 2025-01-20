//
//  ConnectionStatus.swift
//  CryptoSpy
//
//  Created by Dave on 13/01/25.
//

import Alamofire

enum NetworkState {
    case ONLINE, OFFLINE
}

struct LabelState {
    static let On: String = "Online"
    static let Off: String = "Offline"
}

@Observable
class ConnectionStatus {
    private static let CONNECTION_STATUS_ENDPOINT = "www.coingecko.com"
    private static let DEFAULT_STATUS = LabelState.Off
    
    private var netState: NetworkState = .OFFLINE
    
    final let manager = NetworkReachabilityManager(host: CONNECTION_STATUS_ENDPOINT)
    
    var state: NetworkReachabilityManager.NetworkReachabilityStatus {
        willSet {
            self.netState = netStatusByState(by: newValue)
        }
    }
    
    init(
        state: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown,
        failConnection: Bool = false
    ){
        self.state = state
        self.netState = netStatusByState(by: state)
        
        if !failConnection {
            manager?.startListening { [self] status in
                update(by: status)
            }
        }
    }
    
    private func netStatusByState(by status: NetworkReachabilityManager.NetworkReachabilityStatus) -> NetworkState {
        return (status == .unknown || status == .notReachable) ? .OFFLINE : .ONLINE
    }
    
    func showNetState() -> String {
        return self.netState != .ONLINE ? "Offline" : "Online"
    }
    
    func update(by status: NetworkReachabilityManager.NetworkReachabilityStatus){
        state = status
    }
}
