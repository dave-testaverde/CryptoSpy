//
//  CryptoSingleView.swift
//  CryptoSpy
//
//  Created by Dave on 06/08/24.
//

import SwiftUI

struct CryptoSingleView: View {
    
    @Environment(CryptoViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack{
            HStack{
                Text(String(viewModel.cryptoSelected!.market_cap_rank)+"°")
            }
            HStack {
                AsyncImage(url: URL(string: viewModel.cryptoSelected!.image)) { image in
                    image.resizable()
                } placeholder: {
                    Color.red
                }
                .frame(width: 50, height: 50)
                .clipShape(.rect(cornerRadius: 25))
                Text(viewModel.cryptoSelected!.name)
            }
            HStack{
                Text(String(viewModel.cryptoSelected!.current_price))
                    .foregroundStyle(
                        (viewModel.cryptoSelected!.price_change_percentage_24h > 0) ? .green : .red
                    )
                    .padding(.all, 15)
                Text("USD")
                    .foregroundStyle(
                        (viewModel.cryptoSelected!.price_change_percentage_24h > 0) ? .green : .red
                    )
            }
        }
                
    }
}
