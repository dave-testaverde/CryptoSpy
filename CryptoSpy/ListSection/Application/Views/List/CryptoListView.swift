//
//  CryptoListView.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import SwiftUI

struct CryptoListView: View {
    
    @Environment(CryptoViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationView {
            List {
                ForEach(viewModel.cryptos) { crypto in
                    HStack {
                        AsyncImage(url: URL(string: crypto.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.red
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.rect(cornerRadius: 25))
                        Text(crypto.name)
                        Spacer()
                        Text(String(crypto.current_price))
                            .foregroundStyle(
                                (crypto.price_change_percentage_24h > 0) ? .green : .red
                            )
                    }
                }
            }
            .sheet(item: $viewModel.alertError) { error in
                Text(error.localizedDescription)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Cryptos")
            .navigationBarTitle(Text("Cryptos"))
            .task {
                await viewModel.onAppearAction()
            }
            .refreshable {
                Task {
                    await viewModel.refreshListAction()
                }
            }
        }
    }
}

struct CryptoView_Previews: PreviewProvider {
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "BTC", image: "", current_price: 1.0, price_change_percentage_24h: -1.0)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "ETH", image: "", current_price: 1.0, price_change_percentage_24h: 1.0)
    static let getCryptosSource = GetCryptosSourceStub(response: .success([crypto, crypto2]))
    static let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
    static let cryptoViewModel = CryptoViewModel(getCryptosUseCase: getCryptosUseCase)
    
    static var previews: some View {
        NavigationStack {
            CryptoListView().environment(Factory.makeListSection())
        }
    }
}
