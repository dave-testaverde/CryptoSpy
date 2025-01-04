//
//  CryptoViewModelTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 01/08/24.
//

import XCTest
@testable import CryptoSpy

final class CryptoViewModelTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "", image: "", current_price: 2400.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    
    static let currencies = [Currencies(listSupported: ["usd", "eur", "gbp"])]
    
    static let cryptosDataSourceRemoteStub = CryptosDataSourceRemoteStub(
        responseCrypto: .success([crypto]), 
        responseCurrencies: .success(currencies)
    )
    static let cryptosDataSourceLocalStub = CryptosDataSourceLocalStub(
        responseCrypto: .success([crypto2]),
        responseCurrencies: .success(currencies)
    )
    
    static let getCryptosSource = buildGetCryptosRepository(
        cryptosRemoteSource: cryptosDataSourceRemoteStub,
        cryptosLocalSource: cryptosDataSourceLocalStub
    )
    
    static let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CryptosArePopulated() async {
        let sut = makeSUT(viewModel: Self.buildCryptosViewModel())
        await sut.onAppearAction()
        XCTAssertFalse(sut.cryptos.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CurrenciesArePopulated() async {
        let sut = makeSUT(viewModel: Self.buildCryptosViewModel())
        await sut.onAppearAction()
        XCTAssertFalse(sut.currencies.listSupported.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CryptosArePopulatedRx() async {
        let expectation = XCTestExpectation(description: "Cryptos populated")
        let sut = makeSUT(viewModel: Self.buildCryptosViewModel(enableAlamofire: true), checkMemoryLeaks: false)
        await sut.onAppearAction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            XCTAssertFalse(sut.cryptos.isEmpty)
            expectation.fulfill()
        })
        await fulfillment(of: [expectation])
    }
    
    @MainActor
    func testHomeViewModel_whenChangeCryptosStatus_Rx() async {
        let sut = makeSUT(
            viewModel: Self.buildCryptosViewModel(enableRx: true),
            checkMemoryLeaks: false
        )
        await sut.onAppearAction()
        sut.searchPattern = "doge"
        XCTAssertEqual(sut.filteredMessages.count, 1)
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppearGetCryptosRemoteFails_errorAlertCauseIsSet() async {
        let remoteErrorCause = "Remote Fetch failed"
        let localErrorCause = "Local Storage failed"
        let getCryptoErrorNetworkError = GetCryptoError.networkError(cause: remoteErrorCause)
        let getCurrenciesErrorNetworkError = GetCurrenciesError.networkError(cause: remoteErrorCause)
        let cryptosDataSourceRemoteStubWithError = CryptosDataSourceRemoteStub(
            responseCrypto: .failure(getCryptoErrorNetworkError),
            responseCurrencies: .failure(getCurrenciesErrorNetworkError)
        )
        let cryptosDataSourceLocalStubWithError = CryptosDataSourceLocalStub(
            responseCrypto: .failure(.localStorageError(cause: localErrorCause)),
            responseCurrencies: .failure(.localStorageError(cause: localErrorCause))
        )
        let getCryptosSource = Self.buildGetCryptosRepository(cryptosRemoteSource: cryptosDataSourceRemoteStubWithError, cryptosLocalSource: cryptosDataSourceLocalStubWithError)
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let sut = makeSUT(viewModel: Self.buildCryptosViewModel())
        await sut.onAppearAction()
        XCTAssertEqual(sut.crypto_alertError, getCryptoErrorNetworkError)
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppearGetCurrenciesRemoteFails_errorAlertCauseIsSet() async {
        let remoteErrorCause = "Remote Fetch failed"
        let localErrorCause = "Local Storage failed"
        
        let getCryptoErrorNetworkError = GetCryptoError.networkError(cause: remoteErrorCause)
        let getCurrenciesErrorNetworkError = GetCurrenciesError.networkError(cause: remoteErrorCause)
        
        let cryptosDataSourceRemoteStubWithError = CryptosDataSourceRemoteStub(
            responseCrypto: .failure(getCryptoErrorNetworkError),
            responseCurrencies: .failure(getCurrenciesErrorNetworkError)
        )
        let cryptosDataSourceLocalStubWithError = CryptosDataSourceLocalStub(
            responseCrypto: .failure(.localStorageError(cause: localErrorCause)),
            responseCurrencies: .failure(.localStorageError(cause: localErrorCause))
        )
        let getCryptosSource = Self.buildGetCryptosRepository(
            cryptosRemoteSource: cryptosDataSourceRemoteStubWithError,
            cryptosLocalSource: cryptosDataSourceLocalStubWithError
        )
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let sut = makeSUT(viewModel: Self.buildCryptosViewModel())
        await sut.onAppearAction()
        
        XCTAssertEqual(sut.currencies_alertError, getCurrenciesErrorNetworkError)
    }
    
    // MARK: - Helpers
    
    /// make System Under Test
    @MainActor
    private func makeSUT(
        viewModel: CryptoViewModel,
        file: StaticString = #file,
        line: UInt = #line,
        checkMemoryLeaks: Bool = true
    ) -> CryptoViewModel {
        let sut = viewModel
        if(checkMemoryLeaks){
            trackForMemoryLeaks(sut, file: file, line: line)
        }
        return sut
    }
    
    private static func buildGetCryptosRepository(
        cryptosRemoteSource: CryptosDataSourceRemote = cryptosDataSourceRemoteStub,
        cryptosLocalSource: CryptosDataSourceLocal = cryptosDataSourceLocalStub
    ) -> GetCryptosRepository {
        return GetCryptosRepository(
            cryptosRemoteSource: cryptosRemoteSource,
            cryptosLocalSource: cryptosLocalSource)
    }
    
    @MainActor
    private static func buildCryptosViewModel(
        enableAlamofire: Bool = false,
        enableRx: Bool = true
    ) -> CryptoViewModel {
        let cryptosService = CryptosServiceImp(enableAlamofire: enableAlamofire)
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
        
        let cryptoViewModel = CryptoViewModel(
            getCryptosUseCase: getCryptosUseCase,
            enableRx: enableRx
        )
        
        if(enableAlamofire){
            cryptosService.viewModel = cryptoViewModel
        }
        
        return cryptoViewModel
    }
    
}
