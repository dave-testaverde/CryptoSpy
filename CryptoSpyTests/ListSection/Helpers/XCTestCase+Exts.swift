//
//  XCTestCase+Extensions.swift
//  CryptoSpyTests
//
//  Created by Dave on 01/08/24.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak! The instance should have been deallocated.", file: file, line: line)
        }
    }
}
