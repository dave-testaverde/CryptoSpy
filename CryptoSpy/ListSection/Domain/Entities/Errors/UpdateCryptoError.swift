//
//  UpdateCryptoError.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

enum UpdateCryptoError: Error, Equatable, LocalizedError {
    case localStorageError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .localStorageError(let cause):
            return cause
        }
    }
}

enum UpdateCurrenciesError: Error, Equatable, LocalizedError {
    case localStorageError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .localStorageError(let cause):
            return cause
        }
    }
}
