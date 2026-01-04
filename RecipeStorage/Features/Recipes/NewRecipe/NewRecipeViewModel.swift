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
    @Published var ingredientUnits: [String] = ["Custom Unit", "g", "ml", "Stück"]
    @Published var newIngredientUnit: String = ""
    
    // Spices
    @Published var spices: [Spice] = []
    
    // New Spice Inputs
    @Published var spiceName: String = ""
    @Published var spiceAmount: Int? = nil
    @Published var spiceUnit: String = "TL"

    // Spice Units
    @Published var spiceUnits: [String] = ["Custom Unit", "TL", "EL", "Prise"]
    @Published var newSpiceUnit: String = ""
    
    
    var calories: Int {
        let p = Double(protein ?? 0)
        let c = Double(carbs ?? 0)
        let f = Double(fats ?? 0)
        let total = (p + c) * 4.1 + f * 9.3
        return Int(total)
    }
    
    
    func addNewIngredientUnit() {
        if (newIngredientUnit != "") && !(ingredientUnits.contains(newIngredientUnit)) {
            ingredientUnits.append(newIngredientUnit)
            ingredientUnit = newIngredientUnit
            newIngredientUnit = ""
        } else {
            return
        }
    }
    
    func addIngredient() {
        if (!ingredientName.isEmpty &&
            ingredientUnit != "Custom Unit"), let amount = ingredientAmount {
            ingredients.append(
                Ingredient(name: ingredientName, amount: amount, unit: ingredientUnit)
            )
            ingredientName = ""
            ingredientAmount = nil
            ingredientUnit = "g"
        }
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
    }
    
    
    func addNewSpiceUnit() {
        if (newSpiceUnit != "") && !(spiceUnits.contains(newSpiceUnit)) {
            spiceUnits.append(newSpiceUnit)
            spiceUnit = newSpiceUnit
            newSpiceUnit = ""
        } else {
            return
        }
    }
    
    func addSpice() {
        if (!spiceName.isEmpty &&
            spiceUnit != "Custom Unit"), let amount = spiceAmount {
            spices.append(
                Spice(name: spiceName, amount: amount, unit: spiceUnit)
            )
            spiceName = ""
            spiceAmount = nil
            spiceUnit = "TL"
        }
    }
    
    func deleteSpice(_ spice: Spice) {
        spices.removeAll { $0.id == spice.id }
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
