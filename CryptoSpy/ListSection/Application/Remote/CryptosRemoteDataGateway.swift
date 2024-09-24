//
//  CryptosRemoteDataGateway.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class CryptosRemoteDataGateway: CryptosDataSourceRemote {
    let service: CryptosService
    let db: CryptosDb
    
    init(service: CryptosService, db: CryptosDb) {
        self.service = service
        self.db = db
    }
    
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        let fetchCryptosResponse = await service.fetchCryptos(currency: currency)
        switch fetchCryptosResponse {
        case let .success(cryptos):
            let _ = await db.updateCryptos(with: cryptos)
            return .success(cryptos)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func fetchCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        let fetchCurrenciesResponse = await service.fetchCurrencies()
        switch fetchCurrenciesResponse {
        case let .success(currencies):
            //let _ = await db.updateCurrencies(with: currencies)
            return .success(currencies)
        case let .failure(error):
            return .failure(error)
        }
    }
    
}
