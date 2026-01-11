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

    // ✅ CloudKit: .unique raus + Default
    var id: UUID = UUID()

    // ✅ CloudKit: Defaults
    var name: String = ""
    var amount: Int = 0
    var unit: String = ""
    var position: Int?

    // ✅ CloudKit: Inverse Relationship (muss optional sein)
    var recipe: Recipe?

    init(name: String, amount: Int, unit: String, position: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.unit = unit
        self.position = position
    }
}
