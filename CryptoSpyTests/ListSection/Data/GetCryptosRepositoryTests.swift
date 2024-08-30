//
//  GetCryptosRepositoryTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 03/08/24.
//

import XCTest
@testable import CryptoSpy

final class GetCryptosRepositoryTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "", image: "", current_price: 2400.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    
    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceSuccessfuly_returnsCryptos() async {
        let sut = makeSUT()
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceIsEmpty_returnsRemoteCryptos() async {
        let sut = makeSUT(CryptosLocalSource: CryptosDataSourceLocalStub(response: .success([])))
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceFails_returnsRemoteCryptos() async {
        let sut = makeSUT(CryptosLocalSource: CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: "localError"))))
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromBothSourcesFail_returnsNetworkError() async {
        let sut = makeSUT(
            CryptosRemoteSource: CryptosDataSourceRemoteStub(responseCrypto: .failure(.networkError(cause: "remoteError")), responseCurrencies: .failure(.networkError(cause: "remoteError"))),
            CryptosLocalSource: CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: "localError")))
        )
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.failure(GetCryptoError.networkError(cause: "remoteError")), getCryptoResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        CryptosRemoteSource: CryptosDataSourceRemote = CryptosDataSourceRemoteStub(responseCrypto: .success([crypto2]), responseCurrencies: .success(Currencies(listSupported: ["usd", "eur", "gbp"]))),
        CryptosLocalSource: CryptosDataSourceLocal = CryptosDataSourceLocalStub(response: .success([crypto])),
        file: StaticString = #file,
        line: UInt = #line
    ) -> GetCryptosRepository {
        let sut = GetCryptosRepository(
            cryptosRemoteSource: CryptosRemoteSource,
            cryptosLocalSource: CryptosLocalSource)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}


