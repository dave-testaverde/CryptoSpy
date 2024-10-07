//
//  CurrenciesDataSourceTests.swift
//  CryptoSpyTests
//
//  Created by Dave on 03/10/24.
//

import XCTest
@testable import CryptoSpy

@MainActor
final class CurrenciesDataSourceTests: XCTestCase {
    
    static let currencies = Currencies(listSupported: ["usd", "eur", "gbp"])
    
    func testGetCurrencies_whenLoadingCurrenciesIsSuccessful_getSuccessfulResponse() {
        let sut = makeSUT(populate: true)
        let getCryptoResult = sut.loadItems()
        XCTAssertEqual(Result.success([Self.currencies]), getCryptoResult)
    }
    
    func testGetEmptyResponse_whenDeletingAllCurrencies() {
        let sut = makeSUT(populate: true)
        sut.removeAll()
        let getCryptoResult = sut.loadItems()
        XCTAssertEqual(Result.success([]), getCryptoResult)
    }
    
    func testGetEmptyResponse_whenNotPopulated() {
        let sut = makeSUT(populate: false)
        let getCryptoResult = sut.loadItems()
        XCTAssertEqual(Result.success([]), getCryptoResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        populate: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) -> CurrenciesDataSource {
        if(populate){
            CurrenciesDataSource.shared.appendItem(item: Self.currencies)
        }
        return CurrenciesDataSource.shared
    }
}
