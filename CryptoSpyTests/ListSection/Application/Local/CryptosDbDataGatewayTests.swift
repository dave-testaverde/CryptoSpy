//
//  CryptosDbDataGatewayTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 05/08/24.
//

import Foundation

import XCTest
@testable import CryptoSpy

final class CryptosDbDataGatewayTests: XCTestCase {
    
    static let crypto = Crypto(id: "StubDb", symbol: "crypto_coin", name: "CC", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    
    func testCryptosDbDataGateway_whenResultIsSuccessful_returnsCryptos() async {
        let sut = makeSUT()
        let cryptosResult = await sut.fetchCryptos()
        switch cryptosResult {
        case let .success(cryptos):
            XCTAssertEqual(cryptos, [Self.crypto])
        case .failure:
            XCTFail("Request should have succeded")
        }
    }

    func testCryptosDbDataGateway_whenResultIsAFailure_returnsGetCryptoError() async {
        let localStorageError = GetCryptoError.localStorageError(cause: "local storage error")
        let cryptosDbStub = CryptosDbStub(getCryptosResult: .failure(localStorageError))
        let sut = makeSUT(db: cryptosDbStub)
        let cryptosResult = await sut.fetchCryptos()
        switch cryptosResult {
        case .success:
            XCTFail("Request should have failed")
        case let .failure(error):
            XCTAssertEqual(error, localStorageError)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        db: CryptosDb = CryptosDbStub(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> CryptosDbDataGateway {
        let sut = CryptosDbDataGateway(db: db)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
