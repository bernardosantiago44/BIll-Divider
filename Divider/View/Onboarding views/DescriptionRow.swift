//
//  DescriptionRow.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 23/06/22.
//

import SwiftUI

struct DescriptionRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(color)
                .symbolRenderingMode(.hierarchical)
                .alignmentGuide(.alignIconsInRows) { dimension in
                    dimension[HorizontalAlignment.center]
                }
                .padding(.horizontal, 8)
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(title))
                    .font(.headline)
                    .bold()
                
                Text(LocalizedStringKey(description))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    
            }
        }
    }
}

struct DescriptionRow_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionRow(icon: "dollarsign.circle", title: "row title", description: "row description", color: .green)
    }
}
