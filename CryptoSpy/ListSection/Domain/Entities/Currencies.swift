//
//  Currencies.swift
//  CryptoSpy
//
//  Created by Dave on 20/08/24.
//

import Foundation
import SwiftData

@Model
class Currencies: Identifiable {
    var listSupported: [String] 
    
    init(listSupported: [String]) {
        self.listSupported = listSupported
    }
}
