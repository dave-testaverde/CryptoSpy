//
//  Crypto.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

struct Crypto: Identifiable, Equatable {
    var id: String
    var symbol: String
    var name: String
    var image: String
    var current_price: Double
    var price_change_percentage_24h: Float
    var market_cap_rank: Int
    
    var favourites: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case symbol = "symbol"
        case name = "name"
        case image = "image"
        
        case current_price
        case price_change_percentage_24h
        case market_cap_rank
        
        case favourites
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.symbol = try values.decode(String.self, forKey: .symbol)
        self.name = try values.decode(String.self, forKey: .name)
        self.image = try values.decode(String.self, forKey: .image)
        
        self.current_price = try values.decode(Double.self, forKey: .current_price)
        self.price_change_percentage_24h = try values.decode(Float.self, forKey: .price_change_percentage_24h)
        self.market_cap_rank = try values.decode(Int.self, forKey: .market_cap_rank)
        
        /// CoinGecko does not contain favourites key in json payload
        if values.contains(.favourites) {
            let favourites = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .favourites)
            self.favourites = try favourites.decodeIfPresent(Bool.self, forKey: .favourites)
        } else {
            self.favourites = nil
        }
    }
}

extension Crypto: Codable {}
