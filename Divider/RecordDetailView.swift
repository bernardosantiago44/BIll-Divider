//
//  RecordDetailView.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 21/05/22.
//

import SwiftUI

struct RecordDetailView: View {
    
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var showDeleteConfirmationDialog = false
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 140))]
    let columnsForBigDynamicSize: [GridItem] = [GridItem(.adaptive(minimum: 250))]
    
    var check: Check
    var amountOfPeople: Int {
        if self.check.dividedEqually {
            return self.check.amountOfPeople
        }
        return self.check.people.count
    }
    var tipAmount: Float {
        return self.check.checkAmount * self.check.tipPercent
    }
    
    var total: Float {
        return self.tipAmount + self.check.checkAmount
    }
    
    var body: some View {
        
        ScrollView {
            
            //Total and tip summary
            // if font size is less than xxxLarge display horizontally. Otherwise, display vertical
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
            
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.yellow)
                Text("bill_currency_saved") + Text(" \(Locale.current.localizedString(forCurrencyCode: self.check.currency) ?? "no_set_currency").")
                Spacer()
            }
            .padding(.horizontal)
            Divider()
            
            // if the dynamic type size is greater than xLarge, display vertical
            if dynamicTypeSize > .xLarge {
                HStack {
                    VStack(alignment: .leading) {
                        dateAndTimeHeader
                    }
                    Spacer()
                }
                .padding(.horizontal, 8)
            } else {
                HStack {
                    dateAndTimeHeader
                }
                .padding(.horizontal)
            }
            
            // Category and amount of people
            // if the dynamicTypeSize is accessibility then display vertical
            if dynamicTypeSize.isAccessibilitySize {
                HStack {
                    VStack(alignment: .leading) {
                        categoryAndPeople
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            } else {
                HStack {
                    categoryAndPeople
                }
                .padding(.horizontal)
            }
            
            Divider()
            
            // If the bill was divided equally
            // Show how much each person paid
            if check.dividedEqually {
                equallyDividedBillPeople
            } else {
                
                if self.dynamicTypeSize <= .large { // 2xN grid for sizes less or equal than large
                    VStack(alignment: .leading) {
                        Text("people")
                        LazyVGrid(columns: self.columns) {
                            ForEach(self.check.people) { person in
                                IndividualSummary(currency: self.check.currency, person: person, total: self.total, tipAmount: self.check.tipPercent)
                            }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    LazyVGrid(columns: self.columnsForBigDynamicSize) {
                        ForEach(self.check.people) { person in
                            IndividualSummary(currency: self.check.currency, person: person, total: self.total, tipAmount: self.check.tipPercent)
                        }
                    .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
                    }
                    .padding(.horizontal)
                }
            }
            
            if !self.check.notes.isEmpty {
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "note")
                            Text("notes")
                        }
                        .foregroundColor(.yellow)
                        .padding(8)
                        .background(Color.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                        
                        Text(self.check.notes)
                    }
                    .padding()
                    Spacer()
                }
            }
            
            Button {
                self.showDeleteConfirmationDialog = true
            } label: {
                Label {
                    Text("delete_record")
                } icon: {
                    Image(systemName: "trash.fill")
                    
                }
                .padding(10)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(self.check.identifiableName)
        .confirmationDialog("delete_record", isPresented: $showDeleteConfirmationDialog, titleVisibility: .visible) {
            Button("delete", role: .destructive) {
                self.store.deletingResponseStatus = deleteCheckFromDirectory(check: self.check)
                self.store.checks.removeAll(where: { $0.id == self.check.id })
            }
        }
        
    }
    
    var dateAndTimeHeader: some View {
        Section {
            HStack(alignment: .top) {
                Image(systemName: "calendar")
                Text("\(check.date, style: .date)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("HighlightBackground"))
            )
            
            Spacer()
            
            HStack {
                Image(systemName: "clock")
                Text("\(check.date, style: .time)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("HighlightBackground"))
            )
        }
        .foregroundColor(.blue)
    }
    
    var categoryAndPeople: some View {
        Section {
            HStack(alignment: .top) {
                Image(systemName: self.check.category.categoryIcon)
                    .foregroundColor(Color(self.check.category.categoryColor))
                Text(LocalizedStringKey(self.check.category.categoryName))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("HighlightBackground"))
            )
            Spacer()
            HStack(alignment: .top) {
                Image(systemName: "person.3")
                Text("people") + Text("\(self.amountOfPeople)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("HighlightBackground"))
            )
        }
    }
    
    var totalAndTipHeaderSummary: some View {
        Group {
            Section {
                Text("total") + Text(" \(check.checkAmount, format: .currency(code: self.check.currency))")
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
            )
            Spacer()
            
            Section {
                Text("tip") + Text(" +\(self.tipAmount, format: .currency(code: self.check.currency))")
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
            )
        }
        .foregroundColor(.accentColor)
    }
    
    var equallyDividedBillPeople: some View {
        Text("each_person_pays") +
        Text(" \(total / Float(amountOfPeople), format: .currency(code: self.check.currency))")
            .foregroundColor(.accentColor)
            .bold()
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecordDetailView(store: Store(), settings: UserSettings(), check: Store().sampleCheckData[1])
            RecordDetailView(store: Store(), settings: UserSettings(), check: Store().sampleCheckData[1])
        }
        .environment(\.sizeCategory, .extraSmall)
//        .environment(\.sizeCategory, .extraExtraExtraLarge)
//        .previewInterfaceOrientation(.landscapeLeft)
    }
}
