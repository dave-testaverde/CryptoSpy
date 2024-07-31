//
//  Crypto.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

struct Crypto: Identifiable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Float
}

extension Crypto: Codable {}
