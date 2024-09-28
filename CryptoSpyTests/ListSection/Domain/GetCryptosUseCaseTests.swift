//
//  GetCryptosUseCaseTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 02/08/24.
//

import XCTest
@testable import CryptoSpy

final class GetCryptosUseCaseTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    static let currencies = Currencies(listSupported: ["usd", "eur", "gbp"] )
    
    func testGetCryptosUseCase_whenCallingGetCryptosIsSuccessful_getsSuccessfulResponse() async {
        let sut = makeSUT()
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.success([Self.crypto]), getCryptoResult)
    }

    func testGetCryptosUseCase_whenCallingGetCryptosFails_getsErrorResponse() async {
        let getCryptosSource = GetCryptosSourceStub(
            responseCrypto: .failure(.networkError(cause: "cause")),
            responseCurrencies: .failure(.networkError(cause: "cause"))
        )
        let sut = makeSUT(getCryptosSource: getCryptosSource)
        let getCryptoResult = await sut.getCryptos(currency: "usd")
        XCTAssertEqual(Result.failure(.networkError(cause: "cause")), getCryptoResult)
    }
    
    func testGetCurrenciesUseCase_whenCallingGetCurrenciesIsSuccessful_getsSuccessfulResponse() async {
        let sut = makeSUT()
        let getCurrenciesResult = await sut.getCurrencies()
        XCTAssertEqual(Result.success([Self.currencies]), getCurrenciesResult)
    }

    func testGetCurrenciesUseCase_whenCallingGetCurrenciesFails_getsErrorResponse() async {
        let getCryptosSource = GetCryptosSourceStub(
            responseCrypto: .failure(.networkError(cause: "cause")),
            responseCurrencies: .failure(.networkError(cause: "cause"))
        )
        let sut = makeSUT(getCryptosSource: getCryptosSource)
        let getCurrenciesResult = await sut.getCurrencies()
        XCTAssertEqual(Result.failure(.networkError(cause: "cause")), getCurrenciesResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        getCryptosSource: GetCryptosSource = GetCryptosSourceStub(
            responseCrypto: .success([crypto]),
            responseCurrencies: .success([currencies])
        ),
        file: StaticString = #file,
        line: UInt = #line
    ) -> GetCryptosUseCase {
        let sut = GetCryptosUseCase(
            source: getCryptosSource
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
