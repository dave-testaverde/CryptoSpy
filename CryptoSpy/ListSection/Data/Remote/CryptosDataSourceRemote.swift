//
//  CryptosDataSourceRemote.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosDataSourceRemote {
    func fetchCryptos() async -> Result<[Crypto], GetCryptoError>
}

class CryptosDataSourceRemoteStub: CryptosDataSourceRemote {
    let response: Result<[Crypto], GetCryptoError>

    init(response: Result<[Crypto], GetCryptoError>) {
        self.response = response
    }
    
    func fetchCryptos() -> Result<[Crypto], GetCryptoError> {
        response
    }
}
