//
//  GetCryptosRepositoryTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 03/08/24.
//

import XCTest
@testable import CryptoSpy

final class GetCryptosRepositoryTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "BTC", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "ETH", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    
    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceSuccessfuly_returnsCryptos() async {
        let sut = makeSUT()
        let getCryptoResult = await sut.getCryptos()
        XCTAssertEqual(Result.success([Self.crypto]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceIsEmpty_returnsRemoteCryptos() async {
        let sut = makeSUT(CryptosLocalSource: CryptosDataSourceLocalStub(response: .success([])))
        let getCryptoResult = await sut.getCryptos()
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromLocalSourceFails_returnsRemoteCryptos() async {
        let sut = makeSUT(CryptosLocalSource: CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: "localError"))))
        let getCryptoResult = await sut.getCryptos()
        XCTAssertEqual(Result.success([Self.crypto2]), getCryptoResult)
    }

    func testGetCryptosRepository_whenGettingCryptosFromBothSourcesFail_returnsNetworkError() async {
        let sut = makeSUT(
            CryptosRemoteSource: CryptosDataSourceRemoteStub(response: .failure(.networkError(cause: "remoteError"))),
            CryptosLocalSource: CryptosDataSourceLocalStub(response: .failure(.localStorageError(cause: "localError")))
        )
        let getCryptoResult = await sut.getCryptos()
        XCTAssertEqual(Result.failure(GetCryptoError.networkError(cause: "remoteError")), getCryptoResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        CryptosRemoteSource: CryptosDataSourceRemote = CryptosDataSourceRemoteStub(response: .success([crypto2])),
        CryptosLocalSource: CryptosDataSourceLocal = CryptosDataSourceLocalStub(response: .success([crypto])),
        file: StaticString = #file,
        line: UInt = #line
    ) -> GetCryptosRepository {
        let sut = GetCryptosRepository(
            CryptosRemoteSource: CryptosRemoteSource,
            CryptosLocalSource: CryptosLocalSource)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}


