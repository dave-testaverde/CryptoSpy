//
//  GetCryptosSource.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol GetCryptosSource {
    func getCryptos() async -> Result<[Crypto], GetCryptoError>
}

class GetCryptosSourceStub: GetCryptosSource {
    let response: Result<[Crypto], GetCryptoError>

    init(response: Result<[Crypto], GetCryptoError>) {
        self.response = response
    }
    
    func getCryptos() -> Result<[Crypto], GetCryptoError> {
        response
    }
}
