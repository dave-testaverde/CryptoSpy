//
//  Api.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

let coingecko_get_all_crypto: String = "https://api.coingecko.com/api/v3/coins/markets?order=market_cap_desc&per_page=100&page=1&sparkline=false&vs_currency="
let coingecko_get_all_currencies: String =
    "https://api.coingecko.com/api/v3/simple/supported_vs_currencies"
