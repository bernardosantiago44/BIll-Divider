//
//  Currencies.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 19/06/22.
//

import SwiftUI

struct Currencies: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Convert currencies :D")
            }
            .navigationTitle("currencies")
        }
    }
}

struct Currencies_Previews: PreviewProvider {
    static var previews: some View {
        Currencies()
    }
}
