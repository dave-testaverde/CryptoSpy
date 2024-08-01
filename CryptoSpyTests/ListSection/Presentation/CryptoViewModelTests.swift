//
//  CryptoViewModelTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 01/08/24.
//

import XCTest
@testable import CryptoSpy

final class CryptoViewModelTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "BTC", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "ETH", image: "", current_price: 1.0, price_change_percentage_24h: -1.0)
    static let cryptosDataSourceRemoteStub = CryptosDataSourceRemoteStub(response: .success([crypto]))
    static let cryptosDataSourceLocalStub = CryptosDataSourceLocalStub(response: .success([crypto2]))
    static let getCryptosSource = buildGetCryptosRepository(cryptosRemoteSource: cryptosDataSourceRemoteStub, cryptosLocalSource: cryptosDataSourceLocalStub)
    static let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
    
    @MainActor
    func testHomeViewModel_whenOnAppear_CryptosArePopulated() async {
        let sut = makeSUT()
        await sut.onAppearAction()
        XCTAssertFalse(sut.cryptos.isEmpty)
    }

    @MainActor
    func testHomeViewModel_whenOnAppear_CryptosArePopulatedWithLocalCryptos() async {
        let sut = makeSUT()
        await sut.onAppearAction()
        XCTAssertEqual(sut.cryptos, [Self.crypto2])
    }
    
    @MainActor
    func testHomeViewModel_whenOnAppearGetCryptosRemoteFails_errorAlertCauseIsSet() async {
        let remoteErrorCause = "Remote Fetch failed"
        let localErrorCause = "Local Storage failed"
        let getCryptoErrorNetworkError = GetCryptoError.networkError(cause: remoteErrorCause)
        let cryptosDataSourceRemoteStubWithError = CryptosDataSourceRemoteStub(response: .failure(getCryptoErrorNetworkError))
        let cryptosDataSourceLocalStubWithError = CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: localErrorCause)))
        let getCryptosSource = Self.buildGetCryptosRepository(cryptosRemoteSource: cryptosDataSourceRemoteStubWithError, cryptosLocalSource: cryptosDataSourceLocalStubWithError)
        let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
        let sut = makeSUT(getCryptosUseCase: getCryptosUseCase)
        await sut.onAppearAction()
        XCTAssertEqual(sut.alertError, getCryptoErrorNetworkError)
    }
    
    // MARK: - Helpers
    
    /// make System Under Test
    @MainActor
    private func makeSUT(
        getCryptosUseCase: GetCryptosUseCase = getCryptosUseCase,
        file: StaticString = #file,
        line: UInt = #line
    ) -> CryptoViewModel {
        let sut = CryptoViewModel(getCryptosUseCase: getCryptosUseCase)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private static func buildGetCryptosRepository(
        cryptosRemoteSource: CryptosDataSourceRemote = cryptosDataSourceRemoteStub,
        cryptosLocalSource: CryptosDataSourceLocal = cryptosDataSourceLocalStub
    ) -> GetCryptosRepository {
        return GetCryptosRepository(
            CryptosRemoteSource: cryptosRemoteSource,
            CryptosLocalSource: cryptosLocalSource)
    }
}
