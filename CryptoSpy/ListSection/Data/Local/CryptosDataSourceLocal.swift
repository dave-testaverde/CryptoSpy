//
//  CryptosDataSourceLocal.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

protocol CryptosDataSourceLocal {
    func fetchCryptos() async -> Result<[Crypto], GetCryptoError>
    func fetchCurrencies() async -> Result<[Currencies], GetCurrenciesError>
}

class CryptosDataSourceLocalStub: CryptosDataSourceLocal {
    let responseCrypto: Result<[Crypto], GetCryptoError>
    let responseCurrencies: Result<[Currencies], GetCurrenciesError>

    init(responseCrypto: Result<[Crypto], GetCryptoError>, responseCurrencies: Result<[Currencies], GetCurrenciesError>) {
        self.responseCrypto = responseCrypto
        self.responseCurrencies = responseCurrencies
    }
    
    func fetchCryptos() -> Result<[Crypto], GetCryptoError> {
        responseCrypto
    }
    
    func fetchCurrencies() -> Result<[Currencies], GetCurrenciesError> {
        responseCurrencies
    }
}
