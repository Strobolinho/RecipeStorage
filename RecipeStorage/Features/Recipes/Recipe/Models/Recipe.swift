//
//  Recipe.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation

struct Recipe: Identifiable {
    let id: UUID

    let name: String
    let imageName: String
    let servings: Int
    let duration: Int

    let protein: Int
    let carbs: Int
    let fats: Int

    var calories: Int {
        Int(
            (4.1 * Double(protein + carbs)) + (9.3 * Double(fats))
        )
    }
    
    let customCalories: Int?

    let ingredients: [Ingredient]
    let spices: [Spice]
    let steps: [String]

    init(
        name: String,
        imageName: String,
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
        self.imageName = imageName
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
