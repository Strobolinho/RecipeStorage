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
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Recipe.self, Ingredient.self, Spice.self, UnitStore.self])
    }
}
