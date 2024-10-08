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
        let getCurrenciesResult = sut.loadItems()
        XCTAssertEqual(Result.success([Self.currencies]), getCurrenciesResult)
    }
    
    func testGetEmptyResponse_whenDeletingAllCurrencies() {
        let sut = makeSUT(populate: true)
        sut.removeAll()
        let getCurrenciesResult = sut.loadItems()
        XCTAssertEqual(Result.success([]), getCurrenciesResult)
    }
    
    func testGetFailureResponse_whenOccuredErrorFromModelContext() {
        let sut = makeSUT(populate: false)
        let getCurrenciesResult = sut.loadItems(onError: true)
        XCTAssertEqual(Result.failure(GetCurrenciesError.localStorageError(cause: "")), getCurrenciesResult)
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
