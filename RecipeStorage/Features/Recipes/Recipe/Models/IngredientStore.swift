//
//  IngredientStore.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.01.26.
//

import SwiftUI
import SwiftData


@MainActor
final class IngredientStore: ObservableObject {
    @Published var ingredientNames: [String] = []
    
    func load(from container: ModelContainer) {
        do {
            let context = container.mainContext
            let recipes = try context.fetch(FetchDescriptor<Recipe>())

            let ingredientNames = recipes
                .flatMap { $0.ingredients ?? [] }
                .map { $0.name }

            self.ingredientNames = Array(Set(ingredientNames)).sorted()
        } catch {
            print("Ingredient load failed:", error)
        }
    }
}
