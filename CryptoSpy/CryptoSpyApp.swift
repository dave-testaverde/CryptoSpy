//
//  CryptoSpyApp.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import SwiftUI
import SwiftData

@main
struct CryptoSpyApp: App {
    
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: Currencies.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView()
        }
        .modelContainer(modelContainer)
    }
    
}
