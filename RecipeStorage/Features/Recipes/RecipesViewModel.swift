//
//  RecipesViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.02.26.
//

import Foundation
import SwiftData

@MainActor
final class RecipesViewModel: ObservableObject {

    // MARK: - Public state (optional)
    @Published private(set) var categories: [String] = []

    // MARK: - Defaults
    private let defaultCategories: [String] = [
        "High Protein", "Low Calorie", "Vegetarian", "Vegan", "Low Carb"
    ]

    // Guard damit Backfill nicht bei jedem Re-Appear / Task neu läuft
    private var didRunBackfill = false

    // MARK: - Public API

    /// Lädt Kategorien aus dem CategoryStore (falls vorhanden), sonst Fallback.
    func loadCategories(using modelContext: ModelContext) {
        let descriptor = FetchDescriptor<CategoryStore>()
        let stores = (try? modelContext.fetch(descriptor)) ?? []
        let store = stores.first

        let loaded = store?.categories ?? defaultCategories
        categories = loaded.isEmpty ? defaultCategories : loaded
    }

    /// Setzt fehlende `position` Werte bei Ingredients/Spices (Migration/Backfill).
    /// Läuft standardmäßig nur einmal pro ViewModel-Lebenszeit.
    func backfillIngredientPositionsIfNeeded(using modelContext: ModelContext) {
        guard didRunBackfill == false else { return }
        didRunBackfill = true

        let descriptor = FetchDescriptor<Recipe>()
        let recipes = (try? modelContext.fetch(descriptor)) ?? []

        var didChangeAnything = false

        for recipe in recipes {
            let ingredients = recipe.ingredients ?? []
            let spices = recipe.spices ?? []

            for (idx, ing) in ingredients.enumerated() {
                if ing.position == nil {
                    ing.position = idx
                    didChangeAnything = true
                }
            }

            for (idx, sp) in spices.enumerated() {
                if sp.position == nil {
                    sp.position = idx
                    didChangeAnything = true
                }
            }
        }

        guard didChangeAnything else { return }

        do {
            try modelContext.save()
        } catch {
            // Nicht crashen – höchstens loggen
            print("❌ Backfill save failed:", error)
        }
    }

    /// Convenience: wenn du in der View nur 1x `.task` machen willst.
    func onAppear(using modelContext: ModelContext) {
        loadCategories(using: modelContext)
        backfillIngredientPositionsIfNeeded(using: modelContext)
    }
}
