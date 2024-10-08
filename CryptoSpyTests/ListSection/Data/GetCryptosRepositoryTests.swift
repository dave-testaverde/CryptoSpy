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
    
    static let currencies = [Currencies(listSupported: ["usd", "eur", "gbp"])]
    
    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceSuccessfuly_returnsCryptos() async {
        let sut = makeSUT()
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }
    
    func testGetCurrenciesRepository_whenGettingCurrenciesFromLocalSourceSuccessfuly_returnsCurrencies() async {
        let sut = makeSUT()
        let getCurrenciesResult = await sut.getCurrencies()
        XCTAssertEqual(Result.success(Self.currencies), getCurrenciesResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceIsEmpty_returnsRemoteCryptos() async {
        let sut = makeSUT(
            CryptosLocalSource: CryptosDataSourceLocalStub(
                responseCrypto: .success([]),
                responseCurrencies: .success([])
            )
        )
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceFails_returnsRemoteCryptos() async {
        let sut = makeSUT(
            CryptosLocalSource: CryptosDataSourceLocalStub(
                responseCrypto: .failure(.localStorageError(cause: "localError")),
                responseCurrencies: .failure(.localStorageError(cause: "localError"))
            )
        )
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromBothSourcesFail_returnsNetworkError() async {
        let sut = makeSUT(
            CryptosRemoteSource: CryptosDataSourceRemoteStub(
                responseCrypto: .failure(.networkError(cause: "remoteError")),
                responseCurrencies: .failure(.networkError(cause: "remoteError"))
            ),
            CryptosLocalSource: CryptosDataSourceLocalStub(
                responseCrypto: .failure(.localStorageError(cause: "localError")),
                responseCurrencies: .failure(.localStorageError(cause: "localError"))
            )
        )
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.failure(GetCryptoError.networkError(cause: "remoteError")), getCryptoResult)
    }
    
    func testGetCurrenciesRepository_whenGettingCurrenciesFromBothSourcesFail_returnsNetworkError() async {
        let sut = makeSUT(
            CryptosRemoteSource: CryptosDataSourceRemoteStub(
                responseCrypto: .failure(.networkError(cause: "remoteError")),
                responseCurrencies: .failure(.networkError(cause: "remoteError"))
            ),
            CryptosLocalSource: CryptosDataSourceLocalStub(
                responseCrypto: .failure(.localStorageError(cause: "localError")),
                responseCurrencies: .failure(.localStorageError(cause: "localError"))
            )
        )
        let getCurrenciesResult = await sut.getCurrencies()
        XCTAssertEqual(Result.failure(GetCurrenciesError.networkError(cause: "remoteError")), getCurrenciesResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        CryptosRemoteSource: CryptosDataSourceRemote = CryptosDataSourceRemoteStub(
            responseCrypto: .success([crypto2]),
            responseCurrencies: .success(currencies)
        ),
        CryptosLocalSource: CryptosDataSourceLocal = CryptosDataSourceLocalStub(
            responseCrypto: .success([crypto2]),
            responseCurrencies: .success(currencies)
        ),
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


