//
//  GetCryptoUseCase.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class GetCryptosUseCase {
    let source: GetCryptosSource
    
    init(source: GetCryptosSource) {
        self.source = source
    }
    
    func getCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        await source.getCryptos(currency: currency)
    }
    
    func getCrypto(currency: String) async -> Result<[Crypto], GetCryptoError> {
        await source.getCryptos(currency: currency)
    }
    
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        await source.getCurrencies()
    }
}
