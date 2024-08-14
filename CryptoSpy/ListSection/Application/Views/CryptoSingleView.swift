//
//  CryptoSingleView.swift
//  CryptoSpy
//
//  Created by Dave on 06/08/24.
//

import SwiftUI

@MainActor
struct CryptoSingleView: View {
    
    var crypto: Crypto
    
    @Environment(CryptoViewModel.self) var viewModel
    @State private var showFavourites = false
    
    var index: Int {
        viewModel.cryptos.firstIndex(
            where: {
                $0.id == crypto.id
            }
        )!
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack{
            HStack{
                Text("Favourite")
                FavouritesButton(
                    isSet: $viewModel.cryptos[index].favourites
                )
            }
            .frame(width: 130)
            HStack{
                Text(String(crypto.market_cap_rank)+"°")
            }
            HStack {
                AsyncImage(url: URL(string: crypto.image)) { image in
                    image.resizable()
                } placeholder: {
                    Color.red
                }
                .frame(width: 50, height: 50)
                .clipShape(.rect(cornerRadius: 25))
                Text(crypto.name)
            }
            HStack{
                Text(String(crypto.current_price))
                    .foregroundStyle(
                        (crypto.price_change_percentage_24h > 0) ? .green : .red
                    )
                    .padding(.all, 15)
                Text("USD")
                    .foregroundStyle(
                        (crypto.price_change_percentage_24h > 0) ? .green : .red
                    )
            }
        }
                
    }
}
