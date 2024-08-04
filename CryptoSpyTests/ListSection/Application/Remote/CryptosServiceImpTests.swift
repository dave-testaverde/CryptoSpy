//
//  CryptosServiceImpTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 04/08/24.
//

import XCTest
@testable import CryptoSpy

final class CryptosServiceImpTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "BTC", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "ETH", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func testCryptosServiceImp_whenFetchingCryptosRequestSucceeds_returnsCryptos() async {
        let url = URL(string: get_all_crypto_from_coingecko)!
        
        let cryptoList = [Self.crypto, Self.crypto2]
        let encodedCryptoList = try? JSONEncoder().encode(cryptoList.self)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(data: encodedCryptoList, response: urlResponse, error: nil)
        
        let sut = makeSUT()
        let cryptosResult = await sut.fetchCryptos()
        switch cryptosResult {
        case let .success(Cryptos):
            XCTAssertEqual(Cryptos, cryptoList)
        default:
            XCTFail("Request should have succeded")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CryptosServiceImp {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: configuration)
        
        let sut = CryptosServiceImp(urlSession: urlSession)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
