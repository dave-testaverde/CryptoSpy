//
//  CryptosDbDataGateway.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

class CryptosDbDataGateway: CryptosDataSourceLocal {
    let db: CryptosDb
    
    init(db: CryptosDb) {
        self.db = db
    }
    
    func fetchCryptos() async -> Result<[Crypto], GetCryptoError> {
        await db.getCryptos()
    }
    
    func fetchCurrencies() async -> Result<[Currencies], GetCurrenciesError> {
        await db.getCurrencies()
    }
}
