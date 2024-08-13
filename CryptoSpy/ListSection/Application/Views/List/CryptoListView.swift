//
//  CryptoListView.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import SwiftUI

struct CryptoListView: View {
    
    @Environment(CryptoViewModel.self) var viewModel
    @Environment(Router.self) var router
    
    @State private var showFavourites = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationSplitView {
            VStack{
                VStack{
                    HStack{
                        TextField("Search", text: $viewModel.searchPattern)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Toggle(isOn: $showFavourites, label: {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }).frame(width: 70)
                    }
                }
                .frame(width: 350)
                VStack{
                    List {
                        ForEach(viewModel.getCryptos()) { crypto in
                            NavigationLink {
                                CryptoSingleView(crypto: crypto)
                            } label: {
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
                                    Text("$"+String(crypto.current_price))
                                        .foregroundStyle(
                                            (crypto.price_change_percentage_24h > 0) ? .green : .red
                                        )
                                }
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
        } detail: {
            Text("Cryptos")
        }
    }
}

/*struct CryptoView_Previews: PreviewProvider {
    static let crypto = Crypto(id: "", symbol: "bitcoin", name: "BTC", image: "", current_price: 1.0, price_change_percentage_24h: -1.0, market_cap_rank: 1)
    static let crypto2 = Crypto(id: "", symbol: "etherum", name: "ETH", image: "", current_price: 1.0, price_change_percentage_24h: 1.0, market_cap_rank: 2)
    static let getCryptosSource = GetCryptosSourceStub(response: .success([crypto, crypto2]))
    static let getCryptosUseCase = GetCryptosUseCase(source: getCryptosSource)
    static let cryptoViewModel = CryptoViewModel(getCryptosUseCase: getCryptosUseCase)
    
    static var previews: some View {
        NavigationStack {
            CryptoListView().environment(Factory.makeListSection())
        }
    }
}*/
