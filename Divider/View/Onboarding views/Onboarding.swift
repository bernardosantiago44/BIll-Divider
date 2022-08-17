//
//  Onboarding.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 20/06/22.
//

import SwiftUI

struct Onboarding: View {
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        VStack {
            Text("divider")
                .bold()
                .font(.largeTitle)
                .padding(30)
            
            VStack(alignment: .alignIconsInRows) {
                DescriptionRow(icon: "arrow.triangle.branch", title: "split_bills", description: "split_bills_description", color: .green)
                DescriptionRow(icon: "dollarsign.circle.fill", title: "currencies", description: "select_currencies_description", color: .mint)
                DescriptionRow(icon: "square.and.arrow.down", title: "save_bills", description: "save_bills_description", color: .cyan)
                DescriptionRow(icon: "tag.circle.fill", title: "organize_with_tags", description: "tags_description", color: .blue)
            }
            
            Spacer()
            
            Button {
                self.settings.showOnboarding = false
            } label: {
                HStack {
                    Spacer()
                    Text("continue")
                    Spacer()
                }
                .padding(12)
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)

        }
        .padding()
        .frame(maxWidth: 550)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding(settings: UserSettings())
            .environment(\.sizeCategory, .medium)
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
