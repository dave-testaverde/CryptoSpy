//
//  GetServiceError.swift
//  CryptoSpy
//
//  Created by Dave on 09/01/25.
//

import Foundation

enum GetServiceError: Error, Hashable, Identifiable, Equatable, LocalizedError {
    var id: Self { self }
    
    case networkError(cause: String)
    case providerError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let cause):
            return cause
        case .providerError(let cause):
            return cause
        }
    }
}
