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
    
    static let currencies = Currencies(listSupported: ["usd", "eur", "gbp"] )
    
    static let cryptosDataSourceRemoteStub = CryptosDataSourceRemoteStub(
        responseCrypto: .success([crypto]), 
        responseCurrencies: .success(currencies)
    )
    static let cryptosDataSourceLocalStub = CryptosDataSourceLocalStub(response: .success([crypto2]))
    
    static let getCryptosSource = buildGetCryptosRepository(
        cryptosRemoteSource: cryptosDataSourceRemoteStub,
        cryptosLocalSource: cryptosDataSourceLocalStub
    )
    
    static let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CryptosArePopulated() async {
        let sut = makeSUT(getCryptosUseCase: Self.buildGetCryptosUseCases())
        await sut.onAppearAction()
        XCTAssertFalse(sut.cryptos.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CurrenciesArePopulated() async {
        let sut = makeSUT(getCryptosUseCase: Self.buildGetCryptosUseCases())
        await sut.onAppearAction()
        XCTAssertFalse(sut.currencies.listSupported.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_whenChangeCryptosStatus_Rx() async {
        let sut = makeSUT(getCryptosUseCase: Self.buildGetCryptosUseCases(), disableRx: false, checkMemoryLeaks: false)
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
        let cryptosDataSourceLocalStubWithError = CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: localErrorCause)))
        let getCryptosSource = Self.buildGetCryptosRepository(cryptosRemoteSource: cryptosDataSourceRemoteStubWithError, cryptosLocalSource: cryptosDataSourceLocalStubWithError)
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let sut = makeSUT(getCryptosUseCase: getCryptosUseCase)
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
            response: .failure(.localStorageError(cause: localErrorCause))
        )
        let getCryptosSource = Self.buildGetCryptosRepository(
            cryptosRemoteSource: cryptosDataSourceRemoteStubWithError,
            cryptosLocalSource: cryptosDataSourceLocalStubWithError
        )
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let sut = makeSUT(getCryptosUseCase: getCryptosUseCase)
        await sut.onAppearAction()
        
        XCTAssertEqual(sut.currencies_alertError, getCurrenciesErrorNetworkError)
    }
    
    // MARK: - Helpers
    
    /// make System Under Test
    @MainActor
    private func makeSUT(
        getCryptosUseCase: GetCryptosUseCase = getCryptosUseCase,
        file: StaticString = #file,
        line: UInt = #line,
        disableRx: Bool = true,
        checkMemoryLeaks: Bool = true
    ) -> CryptoViewModel {
        let sut = CryptoViewModel(getCryptosUseCase: getCryptosUseCase, disableRx: disableRx)
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
    
    private static func buildGetCryptosUseCases() -> GetCryptosUseCase {
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
        
        return GetCryptosUseCase(source: getCryptosSource)
    }
    
}
