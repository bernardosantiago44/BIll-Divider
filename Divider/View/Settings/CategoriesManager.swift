//
//  CategoriesManager.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 15/06/22.
//

import SwiftUI

struct CategoriesManager: View {
    @ObservedObject var store: Store
    @State private var newCategoryData: Category.Data?
    @State private var showNewCategorySheet = false
    
    @State private var indexSetToRemove: IndexSet?
    @State private var deleteConfirmationDialog = false
    
    var body: some View {
        ZStack {
            if self.store.customCategories.isEmpty {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.accentColor)
                        .frame(width: 50, height: 50)
                    Text("create_custom_categories_information")
                        .foregroundColor(.primary.opacity(0.7))
                }
                .padding()
                .multilineTextAlignment(.center)
                .onTapGesture {
                    self.showNewCategorySheet = true
                }
                .frame(maxWidth: 600)
                .accessibilityLabel("create-category-button")
                
            } else {
                List {
                    Section {
                        ForEach(store.customCategories) { category in
                            HStack {
                                Image(systemName: category.categoryIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(category.categoryColor))
                                Text(category.categoryName)
                                Spacer()
                                Text("\(self.store.checks.filter({ $0.category == category }).count)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(.trailing)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            self.indexSetToRemove = indexSet
                            self.deleteConfirmationDialog = true
                        })
                    .navigationTitle("categories")
                    } header: {
                        EditButton()
                    }
                }
                
                .listStyle(.insetGrouped)
            }
            
            if let savingResponseSatus = self.store.savingCategoryResponseStatus {
                CategorySavingResponseOverlay(responseStatus: savingResponseSatus)
                    .padding(30)
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { self.store.savingCategoryResponseStatus = nil })
                    }
            }
            
            if let deletingResponseStatus = store.deletingCategoryResponseStatus {
                CategoryDeletingResponseOverlay(responseStatus: deletingResponseStatus)
                    .padding(30)
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.store.deletingCategoryResponseStatus = nil
                        }
                    }
            }
        }
        .confirmationDialog("delete_selected_category", isPresented: $deleteConfirmationDialog, titleVisibility: .visible, actions: {
            Button(role: .destructive) {
                if let indexSetToRemove = indexSetToRemove {
                    // delete categories
                    deleteSelectedCategories(indexSetToRemove)
                }
            } label: {
                Text("delete")
            }

        })
        .sheet(isPresented: $showNewCategorySheet, content: {
            CreateNewCategorySheet(store: self.store, showNewCategorySheet: $showNewCategorySheet)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    self.showNewCategorySheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }
                .accessibilityLabel("create-category-button")
            }
        }
        .animation(.easeOut, value: store.savingCategoryResponseStatus)
    }
    
    func deleteSelectedCategories(_ indexSet: IndexSet) {
        var copiedData = store.customCategories
        self.store.customCategories.remove(atOffsets: indexSet)
        copiedData = copiedData.filter({ !store.customCategories.contains($0) })
        
        for datum in copiedData {
            self.store.deletingCategoryResponseStatus = deleteCategoryFromDirectory(category: datum)
        }
    }
}

struct CreateNewCategorySheet: View {
    
    @ObservedObject var store: Store
    @Binding var showNewCategorySheet: Bool
    @State private var categoryName = ""
    @State private var categoryColor: String = "red"
    @State private var categoryIcon = "airplane"
    var canContinue: Bool {
        categoryName.replacingOccurrences(of: " ", with: "").isEmpty
    }
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 40), alignment: .center)]
    let colors: [String] = ["red", "orange", "yellow", "green", "darkBlue", "blue", "purple", "pink", "brown"]
    var icons: [String] {
        store.icons
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                ZStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(categoryColor))
                    Image(systemName: categoryIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolVariant(.fill)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                
                TextField("category_name", text: self.$categoryName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color("HighlightBackground")))
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Divider()
                
                colorPicker
                    .padding(.horizontal)
                
                Divider()
                
                iconPicker
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .animation(.easeOut, value: categoryColor)
            .animation(.easeOut, value: categoryIcon)
            .navigationTitle("create_new_category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let newCategory = Category(categoryName: self.categoryName, categoryIcon: self.categoryIcon, categoryColor: self.categoryColor)
                        self.store.customCategories.append(newCategory)
                        self.store.savingCategoryResponseStatus = saveCategory(newCategory)
                        self.showNewCategorySheet = false
                    } label: {
                        Text("add")
                    }
                    .disabled(self.canContinue)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .destructive) {
                        self.showNewCategorySheet = false
                    } label: {
                        Text("cancel")
                            .bold()
                    }
                    .tint(.red)
                }
            }
        }
    }
    
    var colorPicker: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle()
                        .fill(Color(color))
                        .frame(width: 40, height: 40)
                    
                    if self.categoryColor == color {
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.5), lineWidth: 4)
                            .frame(width: 55, height: 55)
                    }
                    Circle().opacity(0)
                        .frame(width: 55, height: 55)
                }
                .onTapGesture {
                    self.categoryColor = color
                }
            }
        }
    }
    
    var iconPicker: some View {
        LazyVGrid(columns: columns) {
            ForEach(icons, id: \.self) { icon in
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .symbolVariant(.fill)
                        .foregroundColor(.primary.opacity(0.8))
                        .frame(width: 20, height: 20)
                    if self.categoryIcon == icon {
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.5), lineWidth: 4)
                            .frame(width: 55, height: 55)
                    }
                    Circle().opacity(0)
                        .frame(width: 55, height: 55)
                }
                .onTapGesture {
                    self.categoryIcon = icon
                }
            }
        }
    }
}

struct CategoriesManager_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesManager(store: Store())
        }
//        CreateNewCategorySheet(data: .constant(Category.Data(categoryName: "Groceries", categoryIcon: "cart", categoryColor: "yellow")), icons: Store().icons)
//            .preferredColorScheme(.light)
    }
}
