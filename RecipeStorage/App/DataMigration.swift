//
//  DataMigration.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 25.02.26.
//

//import SwiftData
//import Foundation
//
//@MainActor
//enum DataMigration {
//
//    static func migrateMacrosIfNeeded(container: ModelContainer) {
//        let context = container.mainContext
//
//        do {
//            // Nur Rezepte migrieren, die noch nicht migriert sind
//            let predicate = #Predicate<Recipe> { $0.macrosMigrated == false }
//            let recipes = try context.fetch(FetchDescriptor<Recipe>(predicate: predicate))
//
//            guard recipes.isEmpty == false else {
//                print("✅ Migration: nichts zu tun")
//                return
//            }
//
//            for recipe in recipes {
//                // Recipe -> Double Felder
//                recipe.servings = Double(recipe.servings)
//                recipe.protein  = Double(recipe.protein)
//                recipe.carbsValue    = Double(recipe.carbs)
//                recipe.fatsValue     = Double(recipe.fats)
//
//                // Ingredient / Spice amounts
//                recipe.ingredients?.forEach { ing in
//                    ing.amount = Double(ing.amount)
//                }
//                recipe.spices?.forEach { sp in
//                    sp.amountValue = Double(sp.amount)
//                }
//
//                recipe.macrosMigrated = true
//            }
//
//            try context.save()
//            print("✅ Migration: \(recipes.count) Rezepte migriert")
//
//        } catch {
//            print("❌ Migration Fehler:", error)
//        }
//    }
//}
