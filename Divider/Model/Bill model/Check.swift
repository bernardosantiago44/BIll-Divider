//
//  Check.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/05/22.
//

import Foundation

struct Check: Identifiable, Codable, Equatable {
    var id: UUID
    /// The date when the check data was created.
    var date: Date
    /// Non-unique name.
    var identifiableName: String
    var category: Category
    
    ///The currency in which the Bill was saved.
    ///This value can be then converted to other
    ///currencies if the User Defaults key value
    ///changes or if the user explicitly selects another currency.
    var currency: String
    
    /// The total of the bill.
    var checkAmount: Float
    /// A float from 0 - 1 representing the relative tip.
    var tipPercent: Float
    var dividedEqually: Bool
    var amountOfPeople: Int
    var people: [Person]
    
    /// Extra information that they user may add.
    var notes: String
    
    init(date: Date,
         identifiableName: String,
         category: Category,
         currency: String,
         checkAmount: Float,
         tipPercent: Float,
         dividedEqually: Bool,
         amountOfPeople: Int,
         people: [Person],
         notes: String
    ) {
        
        self.id = UUID()
        self.date = date
        self.identifiableName = identifiableName
        self.category = category
        self.currency = currency
        self.checkAmount = checkAmount
        self.tipPercent = tipPercent
        self.dividedEqually = dividedEqually
        self.amountOfPeople = amountOfPeople
        self.people = people
        self.notes = notes
    }
}

extension Check {
    struct CheckData: Identifiable {
        var id = UUID()
        var currency: String
        var checkAmount: Float
        var tipPercent: Float
        var dividedEqually: Bool
        var amountOfPeople: Int
        var people: [Person]
    }
    var data: CheckData {
        CheckData(currency: currency, checkAmount: checkAmount, tipPercent: tipPercent,
                  dividedEqually: dividedEqually,
                  amountOfPeople: amountOfPeople,
                  people: people)
    }
    
    init(data: CheckData, identifiableName: String, category: Category, notes: String) {
        self.id = data.id
        self.date = Date.now
        self.identifiableName = identifiableName
        self.category = category
        self.currency = data.currency
        self.checkAmount = data.checkAmount
        self.tipPercent = data.tipPercent
        self.dividedEqually = data.dividedEqually
        self.amountOfPeople = data.amountOfPeople
        self.people = data.people
        self.notes = notes
    }
}
