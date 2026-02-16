//
//  AddIngredientsViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class AddIngredientsViewModel: ObservableObject {

    // MARK: - Suggestions source
    // wird aus IngredientStore gesetzt (View reicht ingredientNames rein)
    @Published var ingredientNames: [String] = []

    // MARK: - Derived / UI

    func nextField(after field: ingredientField?) -> ingredientField? {
        switch field {
        case .ingredientName: return .amount
        case .amount: return nil
        case .newUnit: return nil
        case .none: return .ingredientName
        }
    }

    func ingredientSuggestions(for input: String) -> [String] {
        let normalized = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return [] }

        return ingredientNames
            .filter { $0.lowercased().contains(normalized) }
            .prefix(3)
            .map { $0 }
    }

    func units(from unitStore: UnitStore?) -> [String] {
        unitStore?.ingredientUnits ?? ["Custom Unit", "g", "ml"]
    }

    func isCustomUnitSelected(_ unit: String) -> Bool {
        unit == "Custom Unit"
    }

    // MARK: - Actions

    /// Übernimmt Logik von addNewIngredientUnit()
    func addNewIngredientUnit(
        recipeVM: NewRecipeViewModel,
        unitStore: UnitStore?
    ) {
        guard let unitStore else { return }

        let newUnit = recipeVM.newIngredientUnit
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newUnit.isEmpty else { return }

        if !unitStore.ingredientUnits.contains(newUnit) {
            unitStore.ingredientUnits.append(newUnit)
        }

        recipeVM.ingredientUnit = newUnit
        recipeVM.newIngredientUnit = ""
    }

    func addIngredient(recipeVM: NewRecipeViewModel) {
        recipeVM.addIngredient()
    }

    func deleteIngredient(_ ingredient: Ingredient, recipeVM: NewRecipeViewModel) {
        recipeVM.deleteIngredient(ingredient)
    }

    func moveIngredients(fromOffsets: IndexSet, toOffset: Int, recipeVM: NewRecipeViewModel) {
        recipeVM.ingredients.move(fromOffsets: fromOffsets, toOffset: toOffset)
        recipeVM.reindexIngredients()
    }

    func sortedIngredients(_ ingredients: [Ingredient]) -> [Ingredient] {
        ingredients.sorted { ($0.position ?? 0) < ($1.position ?? 0) }
    }
}
