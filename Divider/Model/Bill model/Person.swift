//
//  Person.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/04/22.
//

import Foundation

struct Person: Identifiable, Equatable, Codable {
    var id: UUID
    var name: String
    var consumed: Float
    var relativeConsumed: Float
    
    init(name: String, consumed: Float, relativeConsumed: Float) {
        self.id = UUID()
        self.name = name
        self.consumed = consumed
        self.relativeConsumed = relativeConsumed
    }
    
    init(name: String, relativeConsumed: Float) {
        self.id = UUID()
        self.name = name
        self.consumed = 0
        self.relativeConsumed = relativeConsumed
    }
}
