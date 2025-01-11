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
    @State private var currency = "USD"
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack{
            VStack{
                HStack{
                    TextField("Search", text: $viewModel.searchPattern)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Toggle(isOn: $showFavourites, label: {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    })
                    .frame(width: 70)
                    .padding(.leading, 8)
                    Menu {
                        Picker("Currency", selection: $viewModel.currency) {
                            ForEach(viewModel.currencies.listSupported, id: \.self) { curr in
                                Text(curr)
                            }
                        }
                    } label: {
                        Text(viewModel.currency)
                            .padding(.all, 12)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                    .id(viewModel.currency)
                    .padding(.leading, 8)
                }
            }
            .frame(width: 350)
            VStack{
                List {
                    ForEach(viewModel.getCryptosList().filter { crypto in
                        crypto.favourites || !showFavourites
                    }) { crypto in
                        NavigationLink {
                            CryptoSingleView(crypto: crypto)
                                .environment(viewModel)
                                .onAppear(perform: {
                                    print(crypto)
                                })
                                
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
                                Text(String(crypto.current_price))
                                    .foregroundStyle(
                                        (crypto.price_change_percentage_24h > 0) ? .green : .red
                                    )
                            }
                        }
                    }
                }
                .sheet(item: $viewModel.service_alertError) { error in
                    Text(error.localizedDescription)
                }
                .sheet(item: $viewModel.crypto_alertError) { error in
                    Text(error.localizedDescription)
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Cryptos")
                .navigationBarTitle(Text("Cryptos"))
                .task {
                    if(viewModel.cryptos.isEmpty){
                        await viewModel.onAppearAction()
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.refreshListAction()
                    }
                }
            }
        }
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CryptoListView()
                .environment(Factory.makeListSection())
                .environment(Router())
        }
    }
}
