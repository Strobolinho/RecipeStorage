//
//  Recipe.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation
import SwiftData


@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    
    @Attribute(.externalStorage) var imageData: Data?

    var name: String
    var servings: Int
    var duration: Int

    var protein: Int
    var carbs: Int
    var fats: Int

    var calories: Int {
        Int(
            (4.1 * Double(protein + carbs)) + (9.3 * Double(fats))
        )
    }
    
    var customCalories: Int?

    @Relationship(deleteRule: .cascade) var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade) var spices: [Spice]
    var steps: [String]

    init(
        imageData: Data? = nil,
        name: String,
        servings: Int,
        duration: Int,
        protein: Int,
        carbs: Int,
        fats: Int,
        customCalories: Int?,
        ingredients: [Ingredient],
        spices: [Spice],
        steps: [String]
    ) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        self.servings = servings
        self.duration = duration
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.customCalories = customCalories
        self.ingredients = ingredients
        self.spices = spices
        self.steps = steps
    }
}
