//
//  DividerSummary.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 16/05/22.
//

import SwiftUI

struct DividerSummary: View {
    
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    
    var copiedPeople: [Person] {
        self.store.people
    }
    
    var lastPerson: Int {
        return self.copiedPeople.endIndex - 1
    }
    @State private var showSaveSheet = false
    @State private var newCheckData: Check.CheckData? = nil
    @State private var currencyToSave: String = ""
    
    var percentage: Float
    var tip: Float {
        if store.data != nil {
            return Float(self.store.data?.tipPercent ?? 0) * Float(self.store.data?.checkAmount ?? 0)
        }
        return 0
    }
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 140))]
    let columnsForBigDynamicSize: [GridItem] = [GridItem(.adaptive(minimum: 220))]
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    
    var body: some View {
        VStack {
            if self.store.data != nil {
                ScrollView {
                if self.dynamicTypeSize <= .xxLarge {
                    HStack {
                        totalAndTipHeaderSummary
                    }
                    .padding(.horizontal)
                } else {
                    HStack {
                        VStack(alignment: .leading) {
                            totalAndTipHeaderSummary
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    }
                    
                    Text("saving_currency_info") + Text("\(Locale.current.localizedString(forCurrencyCode: self.settings.currencyFormat) ?? "no_set_currency").")
                    
                Divider()
                    .padding(.horizontal)
                    
                
                if self.dynamicTypeSize <= .large { // 2xN grid for sizes less or equal than large
                    LazyVGrid(columns: self.columns) {
                        ForEach(self.copiedPeople) { person in
                            IndividualSummary(currency: self.settings.currencyFormat, person: person, total: self.store.data!.checkAmount, tipAmount: self.store.data!.tipPercent)
                        }
                    }
                    .padding(.horizontal)
                    
                } else { // a vertical grid with a font size greater than large
                    LazyVGrid(columns: self.columnsForBigDynamicSize) {
                        ForEach(self.copiedPeople) { person in
                            IndividualSummary(currency: self.settings.currencyFormat, person: person, total: self.store.data!.checkAmount, tipAmount: self.store.data!.tipPercent)
                        }
                        .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveCheckButton
                }
            }
            .sheet(item: $newCheckData) { checkData in
                SaveCheckSheet(store: self.store, checkData: $newCheckData)
            }
                // TODO: - Add sheet to select currency to save
            .blur(radius: self.store.savingCheckResponseStatus != nil ? 4 : 0)
            .overlay(alignment: .center) {
                if self.store.savingCheckResponseStatus != nil {
                    SavingResponseOverlay(store: self.store)
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { self.store.savingCheckResponseStatus = nil })
                        }
                }
            }
            .animation(.easeOut, value: store.savingCheckResponseStatus)
            } else {
                    ProgressView()
                    .tint(.green)
            }
        }
        .onAppear {
            self.currencyToSave = settings.currencyFormat
        }
    }
    
    var totalAndTipHeaderSummary: some View {
        Group {
            Section {
                Text("total") + Text(" \(((self.store.data?.checkAmount) ?? 0)!, format: .currency(code: self.settings.currencyFormat))")
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
            )
            Spacer()
            
            Section {
                Text("tip") + Text(" +\(tip, format: .currency(code: self.settings.currencyFormat))")
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
            )
        }
        .foregroundColor(.accentColor)
    }
    
    var saveCheckButton: some View {
        Button {
            self.newCheckData = Check.CheckData(currency: self.currencyToSave, checkAmount: self.store.data!.checkAmount, tipPercent: self.store.data!.tipPercent, dividedEqually: false, amountOfPeople: self.copiedPeople.count, people: self.copiedPeople)
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .symbolRenderingMode(.hierarchical)
        }

    }
}

struct IndividualSummary: View {
    let currency: String
    let person: Person
    let total: Float
    let tipAmount: Float
    var relativeConsumed: Float {
        if total != 0 {
            return person.consumed / total
        }
        return 0
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
                Text("\(self.person.name)")
                    .padding(.vertical)
                    .padding(.horizontal, 8)
                    .lineLimit(1)
            }
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("HighlightBackground"))
                    Text("\(self.person.relativeConsumed * 100, specifier: "%.1f")%")
                        .padding(.vertical)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("HighlightBackground"))
                    Text("\(self.relativeConsumed * (self.total * (1.0 + self.tipAmount)), format: .currency(code: self.currency))")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                        .bold()
                        .padding(.vertical)
                }
            }
            .multilineTextAlignment(.center)
        }
    }
}

struct DividerSummary_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DividerSummary(store: Store(), settings: UserSettings(), percentage: 0.15)
            IndividualSummary(currency: "usd", person: Store().sampleData[1], total: 100, tipAmount: 0.15)
        }
//        .environment(\.sizeCategory, .large)
//        .previewInterfaceOrientation(.landscapeLeft)
    }
}
