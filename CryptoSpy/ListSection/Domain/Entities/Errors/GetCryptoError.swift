//
//  GetCryptoError.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

enum GetCryptoError: Error, Hashable, Identifiable, Equatable, LocalizedError {
    var id: Self { self }
    
    case networkError(cause: String)
    case localStorageError(cause: String)
    case providerError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let cause):
            return cause
        case .localStorageError(let cause):
            return cause
        case .providerError(let cause):
            return cause
        }
    }
}
