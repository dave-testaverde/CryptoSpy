//
//  FavouritesButton.swift
//  CryptoSpy
//
//  Created by Dave on 14/08/24.
//

import SwiftUI

struct FavouritesButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Favourites",
                  systemImage: isSet ? "star.fill" : "star")
            .labelStyle(.iconOnly).foregroundStyle(isSet ? .yellow : .gray)
        }
    }
}

#Preview {
    FavouritesButton(isSet: .constant(true))
}
