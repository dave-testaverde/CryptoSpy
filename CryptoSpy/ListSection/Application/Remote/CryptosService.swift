//
//  CryptosService.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosService {
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError>
}

class CryptosServiceStub: CryptosService {
    let fetchCryptosResult: Result<[Crypto], GetCryptoError>
    
    /*init(
        fetchCryptosResult: Result<[Crypto], GetCryptoError> = .success([Crypto(id: "Stub", symbol: "crypto_coin", name: "CC", image: "", current_price: 1.0, price_change_percentage_24h: -1.0, market_cap_rank: 2)])
    ) {
        self.fetchCryptosResult = fetchCryptosResult
    }*/
    
    init(fetchCryptosResult: Result<[Crypto], GetCryptoError>) {
        self.fetchCryptosResult = fetchCryptosResult
    }
    
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        fetchCryptosResult
    }
}
