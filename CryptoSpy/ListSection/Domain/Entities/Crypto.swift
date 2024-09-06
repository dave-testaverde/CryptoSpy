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
    
    var favourites: Bool
    
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
            self.favourites = try favourites.decodeIfPresent(Bool.self, forKey: .favourites) ?? false
        } else {
            self.favourites = false
        }
    }
    
    init(id: String, symbol: String, name: String, image: String, current_price: Double, price_change_percentage_24h: Float, market_cap_rank: Int, favourites: Bool){
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.current_price = current_price
        self.price_change_percentage_24h = price_change_percentage_24h
        self.market_cap_rank = market_cap_rank
        self.favourites = favourites
    }
}

extension Crypto: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.symbol, forKey: .symbol)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.image, forKey: .image)
        
        try container.encode(self.current_price, forKey: .current_price)
        try container.encode(self.price_change_percentage_24h, forKey: .price_change_percentage_24h)
        try container.encode(self.market_cap_rank, forKey: .market_cap_rank)
    }
}
