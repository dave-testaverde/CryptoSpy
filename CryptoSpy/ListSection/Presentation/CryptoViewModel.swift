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
    private var cryptos = [Crypto]()
    var alertError: GetCryptoError?
    
    var cryptoSelected: Crypto?
    
    let getCryptosUseCase: GetCryptosUseCase
    
    var reducer = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    var filteredMessages: [Crypto] = []
    
    var searchPattern: String = "" {
        didSet {
            self.notifyEvent()
        }
    }

    init(getCryptosUseCase: GetCryptosUseCase) {
        self.getCryptosUseCase = getCryptosUseCase
        initRxComponents()
    }
    
    private func getCryptos() async {
        let cryptosResult = await getCryptosUseCase.getCryptos()
        switch cryptosResult {
            case let .success(cryptos):
                self.cryptos = cryptos
            case let .failure(getCryptoError):
                alertError = getCryptoError
        }
    }
    
    func getCryptos() -> [Crypto] {
        return (searchPattern.isEmpty) ? cryptos : filteredMessages
    }

    func onAppearAction() async {
        await getCryptos()
    }
    
    func refreshListAction() async {
        await getCryptos()
    }
    
    private func notifyEvent() {
        reducer.onNext(self.searchPattern)
    }
    
    private func initRxComponents() {
        reducer.map({ [self] query in
            filteredMessages = cryptos.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        })
        .debug()
        .subscribe(onNext: { value in })
        .disposed(by: disposeBag)
    }
    
}
