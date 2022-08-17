//
//  CurrencyCodePicker.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 19/06/22.
//

import SwiftUI

struct CurrencyCodePicker: View {
    @ObservedObject var settings: UserSettings
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var currencyCode: String = ""
    @State private var search: String = ""
    var currencyCodes: [String] { // MARK: - MRU is mro in api, SSP is SDG in api, STN is STD, VES = VEF
        if self.search.isEmpty {
            return Locale.commonISOCurrencyCodes
        }
        return Locale.commonISOCurrencyCodes.filter { code in
            Locale.current.localizedString(forCurrencyCode: code)?.forSorting.contains(search.forSorting) ?? true
        }
    }
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 140))]
    let ipadColumns: [GridItem] = .init(repeating: .init(.flexible()), count: 5)
    
    // FIXME: - solve the issue crashing when in landscape mode and iPad!.
    var body: some View {
        ScrollView {
            searchField
            if self.horizontalSizeClass == .compact {
                if self.dynamicTypeSize < .accessibility1 {
                    LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                        if self.search.isEmpty {
                            CommonCurrenciesList
                            Divider()
                            Divider()
                        }
                        AllCurrenciesList
                    }
                } else {
                    LazyVGrid(columns: [.init(.flexible(minimum: 90))], pinnedViews: [.sectionHeaders]) {
                        if self.search.isEmpty {
                            CommonCurrenciesList
                            Divider()
                        }
                        AllCurrenciesList
                    }
                }
            } else {
                LazyVGrid(columns: self.ipadColumns, pinnedViews: [.sectionHeaders]) {
                    if self.search.isEmpty {
                        CommonCurrenciesList
                    }
                    ForEach(0...4, id: \.self) {_ in
                        Divider()
                    }
                    AllCurrenciesList
                }
            }
        }
        .onAppear {
            self.currencyCode = settings.currencyFormat
        }
        .animation(.easeOut, value: currencyCode)
        .navigationTitle("choose_currency")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var searchField: some View {
        TextField("search", text: $search)
            .padding()
            .background(Material.thick, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 8)
            .accessibilityAddTraits(.isSearchField)
            .accessibilityLabel("search-currencies")
    }
    
    var CommonCurrenciesList: some View {
        Section {
            ForEach(CommonCurrencies.allCases, id: \.rawValue) { currency in
                CurrencyDisplayer(currency: currency.rawValue, highlighted: self.currencyCode == currency.rawValue)
                    .onTapGesture {
                        self.currencyCode = currency.rawValue
                        self.settings.currencyFormat = currency.rawValue
                    }
            }
            .padding(.horizontal, 8)
        } header: {
            Text("common_currencies")
                .font(.subheadline)
                .padding(8)
                .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var AllCurrenciesList: some View {
        Section {
            ForEach(currencyCodes, id: \.debugDescription) { currency in
                CurrencyDisplayer(currency: currency, highlighted: self.currencyCode == currency)
                    .onTapGesture {
                        self.currencyCode = currency
                        self.settings.currencyFormat = currency
                    }
                
            }
        } header: {
            Text("all_currencies")
                .font(.subheadline)
                .padding(8)
                .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 8)
    }
}

struct CurrencyDisplayer: View {
    let currency: String
    let highlighted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(highlighted ? .accentColor : Color("HighlightBackground"))
            VStack(alignment: .center) {
                Text(currency)
                    .foregroundColor(highlighted ? .white : .primary)
                Text(Locale.current.localizedString(forCurrencyCode: currency) ?? "")
                    .font(.caption)
                    .foregroundColor(highlighted ? .white : .primary)
            }
            .padding(.vertical)
        }
    }
}

struct CurrencyCodePicker_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCodePicker(settings: UserSettings())
    }
}
