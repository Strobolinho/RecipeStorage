//
//  categoryStore.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.01.26.
//

import SwiftData

@Model
final class CategoryStore {

    // ✅ CloudKit: Default muss am Property stehen (nicht nur im init)
    var categories: [String] = ["High Protein", "Low Calorie", "Vegetarian", "Vegan", "Low Carb"]

    init(
        categories: [String] = ["High Protein", "Low Calorie", "Vegetarian", "Vegan", "Low Carb"]
    ) {
        self.categories = categories
    }
}
