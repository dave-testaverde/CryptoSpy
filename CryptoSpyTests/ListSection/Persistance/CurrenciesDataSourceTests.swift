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
        let sut = makeSUT()
        let getCryptoResult = sut.loadItems()
        XCTAssertEqual(Result.success([Self.currencies]), getCryptoResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CurrenciesDataSource {
        let sut = CurrenciesDataSource.shared
        sut.appendItem(item: Self.currencies)
        return sut
    }
}
