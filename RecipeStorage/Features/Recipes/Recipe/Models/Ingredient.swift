//
//  Ingredient.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    @Attribute(.unique) var id: UUID
    
    var name: String
    var amount: Int
    var unit: String

    init(name: String, amount: Int, unit: String) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

