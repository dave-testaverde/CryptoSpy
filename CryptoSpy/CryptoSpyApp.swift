//
//  CryptoSpyApp.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import SwiftUI

@main
struct CryptoSpyApp: App {
    
    var body: some Scene {
        WindowGroup {
            CryptoListView().environment(Factory.makeListSection())
        }
    }
    
}
