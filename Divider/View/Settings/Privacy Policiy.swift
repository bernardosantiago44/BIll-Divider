//
//  Privacy Policiy.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 11/07/22.
//

import SwiftUI

struct Privacy_Policiy: View {
    @ObservedObject var store: Store
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text(self.store.privacy.policy)
                .font(.footnote)
                .padding()
            Image("divider_launchscreen")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .background(Material.regular, in: RoundedRectangle(cornerRadius: 12))
        }
        .navigationTitle("privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Privacy_Policiy_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Privacy_Policiy(store: Store())
        }
        .preferredColorScheme(.dark)
    }
}
