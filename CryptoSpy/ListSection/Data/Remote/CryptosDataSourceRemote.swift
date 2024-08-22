//
//  CryptosDataSourceRemote.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosDataSourceRemote {
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError>
    func fetchCurrencies() async -> Result<Currencies, GetCurrenciesError>
}

class CryptosDataSourceRemoteStub: CryptosDataSourceRemote {
    let responseCrypto: Result<[Crypto], GetCryptoError>
    let responseCurrencies: Result<Currencies, GetCurrenciesError>

    init(responseCrypto: Result<[Crypto], GetCryptoError>, responseCurrencies: Result<Currencies, GetCurrenciesError>) {
        self.responseCrypto = responseCrypto
        self.responseCurrencies = responseCurrencies
    }
    
    func fetchCryptos(currency: String) -> Result<[Crypto], GetCryptoError> {
        responseCrypto
    }
    
    func fetchCurrencies() -> Result<Currencies, GetCurrenciesError> {
        responseCurrencies
    }
}
