//
//  Records.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 21/05/22.
//

import SwiftUI

struct Records: View {
    
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    @State private var data: [Check] = []
    @State private var indexSetToRemove: IndexSet?
    @State private var deleteConfirmationDialogPresented = false
    @State private var deleteStatus: ActionResponse?
    @State private var search = ""
    @State private var filterMode: FilterMode? = nil
    @State private var selectedCategory = ""
    @State private var editMode: EditMode = .inactive
    var allCategories: [Category] {
        store.premadeCategories + store.customCategories
    }
    var filteredData: [Check] {
        if let filterMode = filterMode {
            switch filterMode {
            case .text:
                return filterDataWithText(search)
            case .category:
                return filterDataWithCategory(selectedCategory)
            }
        }
        return store.checks
    }
    
    var body: some View {
        ZStack {
            Group {
                if store.checks.isEmpty {
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.accentColor)
                            .frame(width: 50, height: 50)
                        Text("empty_record_data_information")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: 500)
                } else {
                    List {
                        Section {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    HorizontalCategoryFilter
                                }
                            }
                        }
                        
                        Section {
                            ForEach(filteredData) { check in
                                NavigationLink {
                                    RecordDetailView(store: self.store, settings: self.settings, check: check)
                                } label: {
                                    HStack {
                                        Image(systemName: check.category.categoryIcon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color(check.category.categoryColor))
                                            .frame(width: 30, height: 30)
                                        VStack(alignment: .leading) {
                                            Text(check.identifiableName)
                                            Text(check.date, style: .date)
                                        }
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                self.indexSetToRemove = indexSet
                                self.deleteConfirmationDialogPresented = true
                            }
                        }
                    }
                    .toolbar {
                        EditButton()
                    }
                    .searchable(text: $search)
                    .environment(\.editMode, $editMode)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("records")
            .navigationViewStyle(.stack)
            .confirmationDialog("delete_selected_check", isPresented: $deleteConfirmationDialogPresented, titleVisibility: .visible) {
                Button(role: .destructive) {
                    if let indexSetToRemove = indexSetToRemove {
                        deleteSelectedChecks(indexSet: indexSetToRemove)
                    }
                } label: {
                    Text("delete")
                }
                
                Button("cancel", role: .cancel) {
                    self.indexSetToRemove = nil
                }
            }
            .animation(.easeOut, value: store.checks)
            .animation(.easeOut, value: selectedCategory)
            
            if self.store.deletingResponseStatus != nil {
                withAnimation(.easeInOut) {
                    DeletingResponseOverlay(store: self.store)
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { self.store.deletingResponseStatus = nil })
                        }
                }
            }
        }
        .onChange(of: search) { value in
            if !value.isEmpty {
                self.filterMode = .text
                self.selectedCategory = ""
                return
            }
            self.filterMode = nil
            self.selectedCategory = ""
        }
        
        
    }
    
    var HorizontalCategoryFilter: some View {
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
                    if self.selectedCategory == category.id {
                        self.selectedCategory = ""
                        self.filterMode = nil
                        return
                    }
                    self.filterMode = .category
                    self.selectedCategory = category.id
                }
            }
        }
    }
    
    func deleteSelectedChecks(indexSet: IndexSet) {
        var copiedData = store.checks
        self.store.checks.remove(atOffsets: indexSet)
        copiedData = copiedData.filter({ !store.checks.contains($0) })
        for datum in copiedData {
            self.store.deletingResponseStatus = deleteCheckFromDirectory(check: datum)
        }
    }
    
    func filterDataWithText(_ text: String) -> [Check] {
        return store.checks.filter({ $0.identifiableName.forSorting.contains(text.forSorting) })
    }
    
    func filterDataWithCategory(_ category: String) -> [Check] {
        if category.isEmpty { return store.checks }
        return store.checks.filter({ $0.category.id.elementsEqual(category) })
    }
    
}

struct Records_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Records(store: Store(), settings: UserSettings())
        }
    }
}
