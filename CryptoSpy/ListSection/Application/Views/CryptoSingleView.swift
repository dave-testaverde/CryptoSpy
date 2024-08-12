//
//  CryptoSingleView.swift
//  CryptoSpy
//
//  Created by Dave on 06/08/24.
//

import SwiftUI

struct CryptoSingleView: View {
    
    var crypto: Crypto
    
    @State private var showFavourites = false
    
    var body: some View {
        VStack{
            HStack{
                Toggle(isOn: $showFavourites, label: {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                })
            }
            .frame(width: 70)
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
