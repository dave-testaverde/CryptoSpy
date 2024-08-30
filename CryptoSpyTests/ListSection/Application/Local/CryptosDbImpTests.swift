//
//  CryptosDbImpTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 05/08/24.
//

import Foundation

import XCTest
@testable import CryptoSpy

final class CryptosDbImpTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "", image: "", current_price: 2400.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    
    static let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    
    override func tearDownWithError() throws {
        super.tearDown()
        try FileManager.default.removeItem(at: Self.temporaryDirectoryURL)
    }
    
    func testCryptosDbImp_whenRequestingGetCryptosInitially_getsAnEmptyCryptoList() async {
        let sut = makeSUT()
        let cryptosResult = await sut.getCryptos()
        
        switch cryptosResult {
        case let .success(cryptos):
            XCTAssertEqual(cryptos, [])
        default:
            XCTFail("Request should have succeded")
        }
    }
    
    func testCryptosDbImp_whenUpdatingCryptos_CryptosAreSavedInADirectory() async {
        let cryptoList = [Self.crypto, Self.crypto2]
        let sut = makeSUT()
        _ = await sut.updateCryptos(with: cryptoList)
        let cryptosResult = await sut.getCryptos()
        
        switch cryptosResult {
        case let .success(cryptos):
            XCTAssertEqual(cryptos, cryptoList)
        default:
            XCTFail("Request should have succeded")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CryptosDbImp {
        let sut = CryptosDbImp(directoryURL: Self.temporaryDirectoryURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
