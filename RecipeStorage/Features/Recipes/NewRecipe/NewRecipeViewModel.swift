//
//  NewRecipeViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import Foundation
import SwiftUI


@MainActor
final class NewRecipeViewModel: ObservableObject {
    
    // Basic Data
    @Published var name: String = ""
    @Published var imageData: Data? = nil
    @Published var servings: Int? = nil
    @Published var duration: Int? = nil

    // Macros
    @Published var protein: Int? = nil
    @Published var carbs: Int? = nil
    @Published var fats: Int? = nil

    @Published var isCustomCalories: Bool = false
    @Published var customCalories: Int? = nil

    // Ingredients
    @Published var ingredients: [Ingredient] = []

    // New Ingredient Inputs
    @Published var ingredientName: String = ""
    @Published var ingredientAmount: Int? = nil
    @Published var ingredientUnit: String = "g"

    // Ingredient Units
    @Published var newIngredientUnit: String = ""
    
    // Spices
    @Published var spices: [Spice] = []
    
    // New Spice Inputs
    @Published var spiceName: String = ""
    @Published var spiceAmount: Int? = nil
    @Published var spiceUnit: String = "TL"

    // Spice Units
    @Published var newSpiceUnit: String = ""
    
    // Steps
    @Published var steps: [String] = []
    @Published var step: String = ""
    
    var calories: Int {
        let p = Double(protein ?? 0)
        let c = Double(carbs ?? 0)
        let f = Double(fats ?? 0)
        let total = (p + c) * 4.1 + f * 9.3
        return Int(total)
    }
    
    init(recipe: Recipe? = nil) {
        if let recipe { load(from: recipe) }
    }
    
    func load(from recipe: Recipe) {
            imageData = recipe.imageData
            name = recipe.name
            servings = recipe.servings
            duration = recipe.duration
            protein = recipe.protein
            carbs = recipe.carbs
            fats = recipe.fats
            customCalories = recipe.customCalories
            ingredients = recipe.ingredients
            spices = recipe.spices
            steps = recipe.steps
        }
    
    var isValid: Bool {
        guard
            !name.trimmingCharacters(in: .whitespaces).isEmpty,
            let servings, servings > 0,
            let imageData,
            let duration, duration >= 0,
            let protein, protein >= 0,
            let carbs, carbs >= 0,
            let fats, fats >= 0,
            !ingredients.isEmpty,
            !steps.isEmpty
        else {
            return false
        }
        
        return true
    }
    
    func addIngredient() {
        guard !ingredientName.isEmpty,
              ingredientUnit != "Custom Unit",
              let amount = ingredientAmount
        else { return }

        let nextPos = ingredients.count

        ingredients.append(
            Ingredient(name: ingredientName, amount: amount, unit: ingredientUnit, position: nextPos)
        )

        ingredientName = ""
        ingredientAmount = nil
        ingredientUnit = "g"
    }

    func reindexIngredients() {
        for i in ingredients.indices {
            ingredients[i].position = i
        }
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
    }
    
    func addSpice() {
        guard !spiceName.isEmpty,
              spiceUnit != "Custom Unit",
              let amount = spiceAmount
        else { return }

        let nextPos = spices.count

        spices.append(
            Spice(name: spiceName, amount: amount, unit: spiceUnit, position: nextPos)
        )

        spiceName = ""
        spiceAmount = nil
        spiceUnit = "g"
    }

    func reindexSpices() {
        for i in spices.indices {
            spices[i].position = i
        }
    }
    
    func deleteSpice(_ spice: Spice) {
        spices.removeAll { $0.id == spice.id }
    }
    
    
    func deleteStep(at index: Int) {
        guard steps.indices.contains(index) else { return }
        steps.remove(at: index)
    }
}

extension View {
    func keyboardDoneButton(_ action: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done", action: action)
            }
        }
    }
}
