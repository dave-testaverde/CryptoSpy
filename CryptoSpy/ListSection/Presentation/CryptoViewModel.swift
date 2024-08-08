//
//  CryptoViewModel.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

import RxSwift

@MainActor
@Observable
class CryptoViewModel {
    var cryptos = [Crypto]()
    var alertError: GetCryptoError?
    
    var cryptoSelected: Crypto?
    
    let getCryptosUseCase: GetCryptosUseCase

    init(getCryptosUseCase: GetCryptosUseCase) {
        self.getCryptosUseCase = getCryptosUseCase
    }
    
    private func getCryptos() async {
        let CryptosResult = await getCryptosUseCase.getCryptos()
        switch CryptosResult {
            case let .success(Cryptos):
                self.cryptos = Cryptos
            case let .failure(getCryptoError):
                alertError = getCryptoError
        }
    }

    func onAppearAction() async {
        await getCryptos()
    }
    
    func refreshListAction() async {
        await getCryptos()
    }
    
    
}
