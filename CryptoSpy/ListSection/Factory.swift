//
//  Register.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

@Observable
class Factory {
    
    @MainActor static func makeListSection() -> CryptoViewModel {
        let cryptosService = CryptosServiceImp()
        let cryptosDb = CryptosDbImp()
        
        let cryptosDataSourceRemote = CryptosRemoteDataGateway(
            service: cryptosService,
            db: cryptosDb
        )
        
        let cryptosDataSourceLocal = CryptosDbDataGateway(db: cryptosDb)
        
        let getCryptosSource = GetCryptosRepository(
            cryptosRemoteSource: cryptosDataSourceRemote,
            cryptosLocalSource: cryptosDataSourceLocal
        )
        
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let cryptoViewModel = CryptoViewModel(getCryptosUseCase: getCryptosUseCase)
        return cryptoViewModel
    }
    
}
