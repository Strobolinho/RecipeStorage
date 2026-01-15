//
//  RecipeStorageApp.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

@main
struct RecipeStorageApp: App {

    @StateObject private var ingredientsStore = IngredientStore()

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            Ingredient.self,
            Spice.self,
            UnitStore.self,
            CategoryStore.self
        ])

        let config = ModelConfiguration(
            schema: schema,
            cloudKitDatabase: .automatic
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainer konnte nicht erstellt werden: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(ingredientsStore)
                .task {
                    loadIngredientNames()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    
    @MainActor
    private func loadIngredientNames() {
        do {
            let context = sharedModelContainer.mainContext
            let recipes = try context.fetch(FetchDescriptor<Recipe>())

            let names = recipes
                .flatMap { $0.ingredients! }
                .map { $0.name }

            ingredientsStore.ingredientNames = Array(Set(names)).sorted()
        } catch {
            print("Fehler beim Laden der Ingredients:", error)
        }
    }
}
