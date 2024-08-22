//
//  GetCryptosRepository.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class GetCryptosRepository: GetCryptosSource {
    let cryptosRemoteSource: CryptosDataSourceRemote
    let cryptosLocalSource: CryptosDataSourceLocal
    
    init(cryptosRemoteSource: CryptosDataSourceRemote, cryptosLocalSource: CryptosDataSourceLocal) {
        self.cryptosRemoteSource = cryptosRemoteSource
        self.cryptosLocalSource = cryptosLocalSource
    }
    
    func getCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        let cryptosRemoteSourceResponse = await cryptosRemoteSource.fetchCryptos(currency: currency)
        switch cryptosRemoteSourceResponse {
        case let .success(cryptos):
            if cryptos.isEmpty {
                return await cryptosLocalSource.fetchCryptos()
            }
            return cryptosRemoteSourceResponse
        case .failure:
            return await cryptosRemoteSource.fetchCryptos(currency: currency)
        }
    }
}
