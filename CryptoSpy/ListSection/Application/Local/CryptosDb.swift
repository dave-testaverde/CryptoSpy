//
//  CryptosDb.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosDb {
    func getCryptos() async -> Result<[Crypto], GetCryptoError>
    func updateCryptos(with Cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError>
}

class CryptosDbStub: CryptosDb {
    let getCryptosResult: Result<[Crypto], GetCryptoError>
    let updateCryptosResult: Result<Void, UpdateCryptoError>
    
    /*init(
        getCryptosResult: Result<[Crypto], GetCryptoError> = .success([Crypto(id: "StubDb", symbol: "crypto_coin", name: "CC", image: "", current_price: 1.0, price_change_percentage_24h: 1.0, market_cap_rank: 1)]),
        updateCryptosResult: Result<Void, UpdateCryptoError> = .success(())
    ) {
        self.getCryptosResult = getCryptosResult
        self.updateCryptosResult = updateCryptosResult
    }*/
    
    init(getCryptosResult: Result<[Crypto], GetCryptoError>, updateCryptosResult: Result<Void, UpdateCryptoError>) {
        self.getCryptosResult = getCryptosResult
        self.updateCryptosResult = updateCryptosResult
    }
    
    func getCryptos() async -> Result<[Crypto], GetCryptoError> {
        getCryptosResult
    }
    
    func updateCryptos(with Cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError> {
        updateCryptosResult
    }
}
