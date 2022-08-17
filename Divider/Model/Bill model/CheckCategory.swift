//
//  CheckCategory.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/05/22.
//

import Foundation

struct Category: Equatable, Codable, Hashable, Identifiable {
    var id: String
    var categoryName: String
    var categoryIcon: String
    var categoryColor: String
    
    init(id: String = UUID().uuidString, categoryName: String, categoryIcon: String, categoryColor: String) {
        self.id = id
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
    }
}

extension Category {
    struct Data: Identifiable {
        var id = UUID()
        var categoryName: String
        var categoryIcon: String
        var categoryColor: String
    }
    var data: Data {
        Data(categoryName: categoryName, categoryIcon: categoryIcon, categoryColor: categoryColor)
    }
    
    init(data: Data) {
        self.id = UUID().uuidString
        self.categoryName = data.categoryName
        self.categoryIcon = data.categoryIcon
        self.categoryColor = data.categoryColor
    }
}

enum Categories: String {
    case foodAndDrinks = "food_and_drinks"
    case fun = "fun"
}
