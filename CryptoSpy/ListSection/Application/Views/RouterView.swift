//
//  RouterView.swift
//  CryptoSpy
//
//  Created by Dave on 06/08/24.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct RouterView: View {
    @State private var router = Router()
    
    @State private var cryptoViewModel: CryptoViewModel = Factory.makeListSection()
    
    var body: some View {

        NavigationStack(path: $router.navigationPath) {
            CryptoListView()
                .environment(router)
                .environment(cryptoViewModel)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .cryptoListView:
                            CryptoListView()
                    }
                }
        }
        .tint(.orange)
    }
}
