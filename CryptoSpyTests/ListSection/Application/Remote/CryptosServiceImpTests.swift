//
//  CryptosServiceImpTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 04/08/24.
//

import XCTest
@testable import CryptoSpy

final class CryptosServiceImpTests: XCTestCase {
    
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "", image: "", current_price: 50000.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "", image: "", current_price: 2400.0, price_change_percentage_24h: 10.0, market_cap_rank: 1, favourites: false)
    
    static let currenciesList = [Currencies(listSupported: ["usd", "eur", "gbp"])]
    
    static let currency = "usd"
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func testCryptosServiceImp_whenFetchingCryptosRequestSucceeds_returnsCryptos() async {
        let url = URL(string: coingecko_get_all_crypto + Self.currency)!
        
        let cryptoList = [
            Self.crypto,
            Self.crypto2
        ]
        
        let encodedCryptoList = try? JSONEncoder().encode(cryptoList.self)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(data: encodedCryptoList, response: urlResponse, error: nil)
        
        let sut = makeSUT()
        let cryptosResult = await sut.fetchCryptos(currency: Self.currency)
        switch cryptosResult {
        case let .success(cryptos):
            XCTAssertEqual(cryptos, cryptoList)
        default:
            XCTFail("Request should have succeded")
        }
    }
    
    func testCurrenciesServiceImp_whenFetchingCurrenciesRequestSucceeds_returnsCurrencies() async {
        let url = URL(string: coingecko_get_all_currencies)!
        
        let encodedCurrenciesList = try? JSONEncoder().encode(Self.currenciesList[0].listSupported)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(data: encodedCurrenciesList, response: urlResponse, error: nil)
        
        let sut = makeSUT()
        let currenciesResult = await sut.fetchCurrencies()
        switch currenciesResult {
        case let .success(currencies):
            XCTAssertEqual(currencies[0].listSupported, Self.currenciesList[0].listSupported)
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
