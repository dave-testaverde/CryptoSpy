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
    var crypto_alertError: GetCryptoError?
    var currencies_alertError: GetCurrenciesError?
    
    var cryptoSelected: Crypto?
    
    let getCryptosUseCase: GetCryptosUseCase
    
    var reducer = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    var filteredMessages: [Crypto] = []
    
    var currencies: Currencies = Currencies(listSupported: [])
    
    var currency: String = "usd" {
        didSet {
            Task {
                await getCryptos()
            }
        }
    }
    
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
        let cryptosResult = await getCryptosUseCase.getCryptos(currency: currency)
        switch cryptosResult {
            case let .success(cryptos):
                self.cryptos = cryptos
            case let .failure(getCryptoError):
                crypto_alertError = getCryptoError
        }
    }
    
    private func getCurrencies() async {
        let currienciesResult = await getCryptosUseCase.getCurrencies()
        switch currienciesResult {
            case let .success(currencies):
                self.currencies = currencies
                self.currency = self.currencies.listSupported.first ?? "usd"
            case let .failure(getCurrenciesError):
                currencies_alertError = getCurrenciesError
        }
    }
    
    func getCryptosList() -> [Crypto] {
        return (searchPattern.isEmpty) ? cryptos : filteredMessages
    }

    func onAppearAction() async {
        await getCurrencies()
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
