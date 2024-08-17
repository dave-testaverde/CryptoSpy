//
//  GetCryptosRepository.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class GetCryptosRepository: GetCryptosSource {
    let CryptosRemoteSource: CryptosDataSourceRemote
    let CryptosLocalSource: CryptosDataSourceLocal
    
    init(CryptosRemoteSource: CryptosDataSourceRemote, CryptosLocalSource: CryptosDataSourceLocal) {
        self.CryptosRemoteSource = CryptosRemoteSource
        self.CryptosLocalSource = CryptosLocalSource
    }
    
    func getCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        let CryptosLocalSourceResponse = await CryptosRemoteSource.fetchCryptos(currency: currency)
        switch CryptosLocalSourceResponse {
        case let .success(Cryptos):
            if Cryptos.isEmpty {
                return await CryptosLocalSource.fetchCryptos()
            }
            return CryptosLocalSourceResponse
        case .failure:
            return await CryptosRemoteSource.fetchCryptos(currency: currency)
        }
    }
}
