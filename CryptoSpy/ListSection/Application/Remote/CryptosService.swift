//
//  CryptosService.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosService {
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError>
    func fetchCurrencies() async -> Result<Currencies, GetCurrenciesError>
}

class CryptosServiceStub: CryptosService {
    let fetchCryptosResult: Result<[Crypto], GetCryptoError>
    let fetchCurrenciesResult: Result<Currencies, GetCurrenciesError>
    /*init(
        fetchCryptosResult: Result<[Crypto], GetCryptoError> = .success([Crypto(id: "Stub", symbol: "crypto_coin", name: "CC", image: "", current_price: 1.0, price_change_percentage_24h: -1.0, market_cap_rank: 2)])
    ) {
        self.fetchCryptosResult = fetchCryptosResult
    }*/
    
    init(fetchCryptosResult: Result<[Crypto], GetCryptoError>,
         fetchCurrenciesResult: Result<Currencies, GetCurrenciesError>) {
        self.fetchCryptosResult = fetchCryptosResult
        self.fetchCurrenciesResult = fetchCurrenciesResult
    }
    
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        fetchCryptosResult
    }
    
    func fetchCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        fetchCurrenciesResult
    }
}
