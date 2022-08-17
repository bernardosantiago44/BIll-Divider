//
//  BillDivider.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 15/05/22.
//

import SwiftUI

struct BillDivider: View {
    
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @FocusState private var amountIsFocused
    @State private var destinationController = false
    
    @State private var divideEqually = true
    @State private var people = 2
    
    @State private var newCheckData: Check.CheckData? = nil
    
    var tipAmount: Float {
        store.billAmount * store.percentage
    }
    
    var total: Float {
        tipAmount + store.billAmount
    }
    
    var splittedTotal: Float {
        total / Float(people)
    }
    
    var cumulativeRelativesConsumed: Float {
        var sum: Float = 0.0
        for person in store.people {
            sum += person.relativeConsumed
        }
        return sum
    }
    
    @State private var addPersonButton: Bool = false
    
    var body: some View {
        ScrollView {
            if horizontalSizeClass == .regular {
                HStack(alignment: .top) {
                    BillAmountData
                        .frame(maxWidth: 450)
                    Divider()
                    IndividualInformationAndSummary
                    
                }
                .padding()
                
            } else {
                VStack {
                    BillAmountData
                    IndividualInformationAndSummary
                }
                .padding()
            }
        }
        .navigationTitle("divider")
        .sheet(item: $newCheckData) { checkData in
            SaveCheckSheet(store: self.store, checkData: $newCheckData)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    
                    Text("\(self.cumulativeRelativesConsumed * 100, specifier: "%.1f")%")
                        .opacity(!divideEqually ? 100 : 0)
                    
                    Spacer()
                    Button {
                        self.hideKeyboard()
                    } label: {
                        Text("done")
                            .bold()
                    }
                    .accessibilityLabel("dismiss-keyboard")
                    
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    resetEverything()
                } label: {
                    Image(systemName: "trash.slash.fill")
                        .symbolRenderingMode(.hierarchical)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .tint(.red)
                .accessibilityLabel("reset-divider")
            }
        }
        .animation(.easeOut, value: divideEqually)
        .animation(.easeInOut, value: store.people.count)
        .onChange(of: store.people, perform: { people in
            var canContinue = true
            for person in people {
                if person.name.isEmpty {
                    canContinue = false
                }
                if person.consumed == 0 {
                    canContinue = false
                }
            }
            if cumulativeRelativesConsumed >= 1 {
                canContinue = false
            }
            self.addPersonButton = canContinue
        })
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
    }
    
    var BillAmountTextField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("HighlightBackground"))
            TextField("150", value: $store.billAmount, format: .number.precision(.fractionLength(2)))
                .keyboardType(.decimalPad)
                .focused($amountIsFocused)
                .padding(10)
                .accessibilityValue("bill-amount-text-field")
            
        }
    }
    
    var checkSavedSuccessfullyBadge: some View {
        VStack {
            Image(systemName: "checkmark.rectangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.green)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 60, height: 60)
            Text("check_saved_successfully")
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    var BillAmountData: some View {
        VStack {
            HStack {
                Text("bill_amount")
                Spacer()
            } // Bill amount text label
            .accessibilityAddTraits(.isHeader)
            
            BillAmountTextField
                .padding(.bottom)
                .frame(maxHeight: 40)
            
            VStack(alignment: .leading) {
                Stepper(value: $store.percentage, in: 0...1, step: 0.01) {
                    Text("percentage") + Text("\(store.percentage * 100, specifier: "%.0f")%")
                }
                .accessibilityLabel("tip-percentage")
                Text("\(tipAmount, format: .currency(code: self.settings.currencyFormat))")
                    .accessibilityValue("tip-to-add")
            } // Tip stepper and Tip amount text label
            
            Section {
                Text("total") + Text(" \(total, format: .currency(code: self.settings.currencyFormat))")
//                    .accessibilityLabel("total-with-tip")
            } // Green total label
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("HighlightBackground"))
            )
            .foregroundColor(.accentColor)
            
            Section {
                Toggle(isOn: $divideEqually) {
                    Text("divide_equally")
                }
                .accessibilityLabel("divides-the-bill-equally")
                if divideEqually {
                    Stepper(value: $people, in: 2...100) {
                        Text("people") + Text("\(people)")
                    }
                    Text("each_person_pays") + Text(" \(splittedTotal, format: .currency(code: self.settings.currencyFormat))").foregroundColor(.accentColor)
                    Button {
                        self.newCheckData = Check.CheckData(currency: self.settings.currencyFormat, checkAmount: self.store.billAmount, tipPercent: self.store.percentage, dividedEqually: self.divideEqually, amountOfPeople: self.people, people: [])
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("save")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .disabled(self.store.billAmount == 0)
                }
            } // Divide equally toggle and green individual payment label
            .padding(.bottom)
        }
    }
    
    var IndividualInformationAndSummary: some View {
        VStack {
            if !divideEqually && store.billAmount != 0 {
                ForEach($store.people) { $person in
                    IndividualInformation(person: $person, store: store, total: self.store.billAmount, percentage: $store.percentage, tipAmount: self.tipAmount)
                }
                Button {
                    if self.store.people.count == 0 {
                        self.store.people.append(Person(name: "", consumed: 0, relativeConsumed: 0.0))
                    } else {
                        self.store.people.append(Person(name: "", consumed: (1.0 - cumulativeRelativesConsumed) * store.billAmount, relativeConsumed: 1 - cumulativeRelativesConsumed))
                    }
                    
                } label: {
                    Text("add_person")
                }
                .disabled(!addPersonButton)
                
                if self.cumulativeRelativesConsumed == 1 && !self.addPersonButton {
                    Button("summary") {
                        self.store.data = Check.CheckData(currency: self.settings.currencyFormat, checkAmount: self.store.billAmount, tipPercent: self.store.percentage, dividedEqually: self.divideEqually, amountOfPeople: self.people, people: self.store.people)
                        self.destinationController = true
                    }
                    NavigationLink(isActive: $destinationController) {
                        DividerSummary(store: self.store, settings: self.settings, percentage: self.store.percentage)
                    } label: {
                        Text("summary")
                    }
                    .hidden()
                }
            }
        }
    }
    
    func resetEverything() {
        self.store.billAmount = 0
        self.divideEqually = true
        self.people = 2
        self.store.percentage = 0.15
        self.store.people = [Person(name: "Juan", consumed: 0.0, relativeConsumed: 0.0)]
    }
    
}

struct IndividualInformation: View {
    @Binding var person: Person
    @ObservedObject var store: Store
    let total: Float
    @Binding var percentage: Float
    let tipAmount: Float
    var relativeConsumed: Float {
        if total != 0 {
            return person.consumed / total
        }
        return 0
    }
    var body: some View {
        Section {
            HStack {
                Text("\(person.consumed , format: .currency(code: Locale.current.currencyCode ?? "USD")) - \(person.relativeConsumed * 100, specifier: "%.1f")%")
                Spacer()
                if store.people.count > 1 {
                    Button(role: .destructive) {
                        store.people.removeAll(where: { $0.id == person.id })
                    } label: {
                        Text("remove_person")
                        Image(systemName: "trash")
                    }
                }
            }
            .font(.footnote.bold())
            
            PersonTextField
                .frame(maxHeight: 50)
            ConsumedTextField
                .frame(maxHeight: 50)
            
            PersonContribution
                .padding(.bottom, 25)
        }
        .onChange(of: person) { newValue in
            person.consumed = validateAmount(newValue.consumed)
            person.relativeConsumed = self.relativeConsumed
        }
    }
    
    var PersonTextField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("HighlightBackground"))
            TextField(text: $person.name) {
                Text("name")
            }
            .padding(10)
            .accessibilityLabel("person-name-text-field")
        }
    }
    
    var ConsumedTextField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("HighlightBackground"))
            TextField("150", value: $person.consumed, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                .keyboardType(.decimalPad)
                .padding(10)
                .accessibilityLabel("person-consumed-field")
        }
    }
    
    var PersonContribution: some View {
        Text("contribution") + Text("\(self.relativeConsumed * (self.total + self.tipAmount), format: .currency(code: Locale.current.currencyCode ?? "USD"))")
            .accessibilityLabel("contribution-to-make")
    }
}


struct BillDivider_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
//            SidebarNavigationList(store: Store(), settings: UserSettings())
            BillDivider(store: Store(), settings: UserSettings())
        }
//        .previewInterfaceOrientation(.landscapeLeft)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

func validateAmount(_ value: Float) -> Float {
    return abs(value)
}
