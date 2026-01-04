//
//  Ingredient.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation


struct Ingredient: Identifiable {
    let id: UUID
    let name: String
    let amount: Int
    let unit: String

    init(name: String, amount: Int, unit: String) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

