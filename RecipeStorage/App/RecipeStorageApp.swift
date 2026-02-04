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
            CategoryStore.self,
            MealPlanEntry.self,
            GroceryListEntry.self
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
                    ingredientsStore.load(from: sharedModelContainer)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
