//
//  Store.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/04/22.
//

import Foundation

class Store: ObservableObject {
    
    /// A floating-point number holding the bill amount of a record.
    @Published var billAmount: Float = 0.0
    
    /// A floating-point number holding the tip percentage to be added to a bill.
    /// This number goes from 0.0 (0%) to 1.0 (100%)
    @Published var percentage: Float = 0.15
    
    /// An array holding the name, consumed amount (float) and relative consumed amount (0 - 1) of a person.
    @Published var people: [Person] = [Person(name: "Juan", consumed: 0.0, relativeConsumed: 0.0)]
    
    /// An array holding the saved records in the local device of the user.
    @Published var checks: [Check] = retrieveSavedChecksData()
    
    /// The status of a saved Check.
    @Published var savingCheckResponseStatus: ActionResponse? 
    /// The status of a deleted Check.
    @Published var deletingResponseStatus: ActionResponse?
    
    /// The status of a saved Category
    @Published var savingCategoryResponseStatus: ActionResponse?
    /// The status of a deleted Category
    @Published var deletingCategoryResponseStatus: ActionResponse?
    
    /// An array holding the App's default categories.
    var premadeCategories: [Category] = [
        
        Category(id: "food_and_drinks_ED968FE9", categoryName: "food_and_drinks", categoryIcon: "fork.knife", categoryColor: "yellow"),
        Category(id: "fun_69808436", categoryName: "fun", categoryIcon: "person.2.fill", categoryColor: "blue"),
        Category(id: "coffee_A20FCC79", categoryName: "coffee", categoryIcon: "cup.and.saucer.fill", categoryColor: "brown")
    
    ]
    
    /// An array holding the user's custom categories.
    @Published var customCategories: [Category] = retrieveSavedCategoriesData()
    
    @Published var newCategoryData: Category.Data? = nil
    
    /// An optional value holding the data of a recently created check.
    @Published var data: Check.CheckData? = nil
    
    /// Sample people data for debbuging. This will never be shown in production.
    var sampleData: [Person] = [
        Person(name: "Juan", consumed: 350, relativeConsumed: 0.35),
        Person(name: "Pepe", consumed: 450, relativeConsumed: 0.45),
        Person(name: "Somerealreallylongname", consumed: 200, relativeConsumed: 0.20)
    ]
    
    /// Sample check data for debugging. This will never be shown in production.
    var sampleCheckData: [Check] = [
        Check(date: Date().addingTimeInterval(-186400),
              identifiableName: "Delicity market",
              category: Category(categoryName: "food_and_drinks", categoryIcon: "fork.knife", categoryColor: "yellow"),
              currency: "usd",
              checkAmount: 275.0,
              tipPercent: 0.15,
              dividedEqually: true,
              amountOfPeople: 2,
              people: [], notes: ""),
        Check(date: Date().addingTimeInterval(-342172),
              identifiableName: "McDonalds",
              category: Category(categoryName: "food_and_drinks", categoryIcon: "fork.knife", categoryColor: "yellow"),
              currency: "mxn",
              checkAmount: 512,
              tipPercent: 0.15,
              dividedEqually: false,
              amountOfPeople: 2,
              people: [
                Person(name: "Juan", consumed: 96, relativeConsumed: 0.19),
                Person(name: "Robin", consumed: 115, relativeConsumed: 0.22),
                Person(name: "Alida", consumed: 130, relativeConsumed: 0.25),
                Person(name: "Tim", consumed: 160, relativeConsumed: 0.31),
                Person(name: "last", consumed: 15.36, relativeConsumed: 0.03)
              ], notes: "Tim had the biggest burger I had ever seen in my entire life.")
    ]
    
    /// A list of icons to choose for custom categories.
    var icons = Bundle.main.decode([String].self, from: "icons.json")
    
    /// The privacy policy, localized in English and Spanish.
    let privacy = Bundle.main.decode(Privacy.self, from: "Privacy.json")
}


