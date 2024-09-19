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
    @ObservationIgnored
    private let dataSource: CurrenciesDataSource
    
    final let INIT_CURRENCY = "usd"
    
    var cryptos = [Crypto]()
    var crypto_alertError: GetCryptoError?
    var currencies_alertError: GetCurrenciesError?
    
    var cryptoSelected: Crypto?
    
    let getCryptosUseCase: GetCryptosUseCase
    
    var reducer = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    var filteredMessages: [Crypto] = []
    
    var currencies: Currencies = Currencies(listSupported: [])
    
    var currency: String {
        didSet {
            Task {
                await getCryptos()
            }
        }
    }
    
    var searchPattern: String = "" {
        didSet {
            self.emit()
        }
    }

    init(getCryptosUseCase: GetCryptosUseCase, disableRx: Bool, dataSource: CurrenciesDataSource = CurrenciesDataSource.shared) {
        self.getCryptosUseCase = getCryptosUseCase
        self.dataSource = dataSource
        self.currency = INIT_CURRENCY
        if(!disableRx){
            initRxComponents()
        }
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
                self.currency = self.currencies.listSupported.first ?? INIT_CURRENCY
                if(self.fetchCurrencies().count == 0){
                    self.saveCurrencies(currencies: currencies)
                }
                print(self.fetchCurrencies())
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
    
    // MARK: - Helpers for RxSwift
    
    private func emit() {
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
    
    // MARK: - Helpers for SwiftData
    
    func saveCurrencies(currencies: Currencies) {
        dataSource.appendItem(item: currencies)
    }
    
    func cleanCurrencies(){
        dataSource.removeAll()
    }
    
    func fetchCurrencies() -> [Currencies] {
        return dataSource.fetchItems()
    }
    
}
