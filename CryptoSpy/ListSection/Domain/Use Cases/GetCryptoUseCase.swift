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
    
    func getCryptos() async -> Result<[Crypto], GetCryptoError> {
        await source.getCryptos()
    }
    
    func getCrypto() async -> Result<[Crypto], GetCryptoError> {
        await source.getCryptos()
    }
}
