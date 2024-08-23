//
//  GetCryptosSource.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol GetCryptosSource {
    func getCryptos(currency: String) async -> Result<[Crypto], GetCryptoError>
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError>
}

class GetCryptosSourceStub: GetCryptosSource {
    let responseCrypto: Result<[Crypto], GetCryptoError>
    let responseCurrencies: Result<Currencies, GetCurrenciesError>

    init(responseCrypto: Result<[Crypto], GetCryptoError>,
         responseCurrencies: Result<Currencies, GetCurrenciesError>) {
        self.responseCrypto = responseCrypto
        self.responseCurrencies = responseCurrencies
    }
    
    func getCryptos(currency: String) -> Result<[Crypto], GetCryptoError> {
        responseCrypto
    }
    
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        responseCurrencies
    }
}
