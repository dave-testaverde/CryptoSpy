//
//  CryptosDb.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosDb {
    func getCryptos() async -> Result<[Crypto], GetCryptoError>
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError>
    
    func updateCryptos(with Cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError>
}

class CryptosDbStub: CryptosDb {
    let getCryptosResult: Result<[Crypto], GetCryptoError>
    let updateCryptosResult: Result<Void, UpdateCryptoError>
    let getCurrenciesResult: Result<Currencies, GetCurrenciesError>
    
    init(
        getCryptosResult: Result<[Crypto], GetCryptoError> = .success([Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)]),
        updateCryptosResult: Result<Void, UpdateCryptoError> = .success(()),
        getCurrenciesResult: Result<Currencies, GetCurrenciesError> = .success(Currencies(listSupported: ["usd", "eur", "gbp"]))
    ) {
        self.getCryptosResult = getCryptosResult
        self.updateCryptosResult = updateCryptosResult
        self.getCurrenciesResult = getCurrenciesResult
    }
    
    func getCryptos() async -> Result<[Crypto], GetCryptoError> {
        getCryptosResult
    }
    
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        getCurrenciesResult
    }
    
    func updateCryptos(with Cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError> {
        updateCryptosResult
    }
}
