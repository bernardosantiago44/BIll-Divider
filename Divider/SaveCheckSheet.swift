//
//  SaveCheckSheet.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 09/06/22.
//

import SwiftUI

struct SaveCheckSheet: View {
    
    @ObservedObject var store: Store
    @State private var checkIdentifiableName = ""
    @State private var selectedCategory: String = ""
    @State private var notes = ""
    @State private var canContinue = false
    @FocusState private var titleTextField
    @Binding var checkData: Check.CheckData?
    var allCategories: [Category] {
        store.premadeCategories + store.customCategories
    }
    var category: Category {
        allCategories.filter { Category in
            Category.id.elementsEqual(selectedCategory)
        }[0]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("title", text: $checkIdentifiableName)
                        .focused($titleTextField)
                        .onSubmit {
                            if self.canContinue {
                                saveWithData()
                            }
                        }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            categoryPicker
                        }
                    }
                }
                if self.checkData != nil {
                    Section {
                        Text("saving_currency_info") + Text("\(Locale.current.localizedString(forCurrencyCode: self.checkData!.currency) ?? "no_set_currency").")
                    }
                }
                
                Section {
                    TextField("notes", text: $notes)
                        .multilineTextAlignment(.leading)
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            saveWithData()
                        } label: {
                            Text("save")
                                .font(.title3)
                                .padding(.horizontal)
                        }
                        .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .disabled(!canContinue)
                        
                        Spacer()
                    }

                }
            }
            .navigationTitle("save_record")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: checkIdentifiableName) { newValue in
                validateData()
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        self.checkData = nil
                    }, label: {
                        Text("cancel")
                            .bold()
                    })
                    .tint(.red)
                }
            }
        }
    }
    
    private func validateData() {
        self.canContinue = !checkIdentifiableName.noSpace.isEmpty && self.checkData != nil
    }
    
    private func saveWithData() {
        if let checkData = checkData {
            let check = Check(data: checkData, identifiableName: self.checkIdentifiableName, category: self.category, notes: self.notes)
            self.store.savingCheckResponseStatus = saveCheck(check)
            self.store.checks.append(check)
            self.checkData = nil
            
        }
        self.checkData = nil
    }
    
    func resetEverything() {
        self.store.people = [Person(name: "Juan", consumed: 0.0, relativeConsumed: 0.0)]
    }
    
    var categoryPicker: some View {
        Group {
            ForEach(self.allCategories) { category in
                ZStack {
                    Capsule()
                        .foregroundColor(selectedCategory == category.id ? Color(category.categoryColor).opacity(0.2) : Color("HighlightBackground"))
                    
                    HStack {
                        Image(systemName: category.categoryIcon)
                            .foregroundColor(Color(category.categoryColor))
                        Text(LocalizedStringKey(category.categoryName))
                    }
                    .padding(12)
                }
                .onTapGesture {
                    self.selectedCategory = category.id
                }
            }
        }
        .onAppear {
            self.selectedCategory = store.premadeCategories[0].id
        }
    }
}

struct SaveCheckSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("a")
            .sheet(isPresented: .constant(true)) {
                SaveCheckSheet(store: Store(), checkData: .constant(Check.CheckData(currency: "eur", checkAmount: 100, tipPercent: 0.15, dividedEqually: false, amountOfPeople: 1, people: [
                    Person(name: "Juan", consumed: 100, relativeConsumed: 1.0)
                ])))
            }
    }
}
