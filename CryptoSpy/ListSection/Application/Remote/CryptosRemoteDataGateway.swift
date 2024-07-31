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
    
    func fetchCryptos() async -> Result<[Crypto], GetCryptoError> {
        let fetchCryptosResponse = await service.fetchCryptos()
        switch fetchCryptosResponse {
        case let .success(Cryptos):
            let _ = await db.updateCryptos(with: Cryptos)
            return .success(Cryptos)
        case let .failure(error):
            return .failure(error)
        }
    }
}
