//
//  CryptosRemoteDataGatewayTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 04/08/24.
//

import Foundation

import XCTest
@testable import CryptoSpy

final class CryptosRemoteDataGatewayTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    
    func testCryptosRemoteDataGateway_whenResultIsSuccessful_returnsCryptos() async {
        let sut = makeSUT()
        let cryptosResult = await sut.fetchCryptos(currency: "usd")
        switch cryptosResult {
        case let .success(cryptos):
            XCTAssertEqual(cryptos, [Self.crypto])
        case .failure:
            XCTFail("Request should have succeded")
        }
    }

    func testCryptosRemoteDataGateway_whenResultIsAFailure_returnsGetCryptoError() async {
        let cryptoRemoteStorageError = GetCryptoError.networkError(cause: "network error")
        let currenciesRemoteStorageError = GetCurrenciesError.networkError(cause: "network error")
        let cryptosServiceStub = CryptosServiceStub(
            fetchCryptosResult: .failure(cryptoRemoteStorageError),
            fetchCurrenciesResult: .failure(currenciesRemoteStorageError)
        )
        let sut = makeSUT(service: cryptosServiceStub)
        let cryptosResult = await sut.fetchCryptos(currency: "usd")
        switch cryptosResult {
        case .success:
            XCTFail("Request should have failed")
        case let .failure(error):
            XCTAssertEqual(error, remoteStorageError)
        }
    }

    func testCryptosRemoteDataGateway_whenResultIsSuccessful_updatesDbCryptos() async {
        let cryptosDbSpy = CryptosDbSpy()
        let sut = makeSUT(db: cryptosDbSpy)
        let cryptosResult = await sut.fetchCryptos()
        XCTAssertTrue(cryptosDbSpy.didUpdateCryptos)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        service: CryptosService = CryptosServiceStub(),
        db: CryptosDb = CryptosDbStub(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> CryptosRemoteDataGateway {
        let sut = CryptosRemoteDataGateway(service: service, db: db)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    class CryptosDbSpy: CryptosDbStub {
        var didUpdateCryptos = false
        
        override func updateCryptos(with cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError> {
            didUpdateCryptos = true
            return updateCryptosResult
        }
    }
}
