//
//  Register.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class Factory {
    
    @MainActor static func makeListSection() -> CryptoViewModel {
        let cryptosService = CryptosServiceImp()
        let cryptosDb = CryptosDbImp()
        let cryptosDataSourceRemote = CryptosRemoteDataGateway(service: cryptosService, db: cryptosDb)
        let cryptosDataSourceLocal = CryptosDbDataGateway(db: cryptosDb)
        let getCryptosSource = GetCryptosRepository(CryptosRemoteSource: cryptosDataSourceRemote, CryptosLocalSource: cryptosDataSourceLocal)
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let cryptoViewModel = CryptoViewModel(getCryptosUseCase: getCryptosUseCase)
        return cryptoViewModel
    }
}
