//
//  RecipesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct RecipesView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    
    @Query private var categoryStores: [CategoryStore]
    private var categoryStore: CategoryStore? { categoryStores.first }

    private var categories: [String] {
        categoryStore?.categories ?? ["High Protein", "Low Calorie", "Vegetarian", "Vegan", "Low Carb"]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if !recipes.isEmpty {
                    ScrollView(.vertical) {
                        HorizontalRecipeScrollbarView(
                            title: "Alle Rezepte 🍽️",
                            recipes: recipes
                        )

                        ForEach(categories, id: \.self) { category in
                            let filtered = recipes.filter { $0.categories.contains(category) }
                            
                            if !filtered.isEmpty {
                                HorizontalRecipeScrollbarView(title: category, recipes: filtered)
                            }
                        }
                        
                        VStack {}.frame(height: 50)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 70))
                            .foregroundStyle(.brandPrimary)

                        Text("No Recipes available")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Create your first Recipe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.brandPrimary)
                    }
                    .padding()
                }

                NewRecipeButtonView()
            }
        }
        .task {
            backfillIngredientPositionsIfNeeded()
        }
    }

    private func backfillIngredientPositionsIfNeeded() {
        let descriptor = FetchDescriptor<Recipe>()
        let recipes = (try? modelContext.fetch(descriptor)) ?? []

        for recipe in recipes {
            
            let ingredients = recipe.ingredients ?? []
            let spices = recipe.spices ?? []
            
            for (idx, ing) in ingredients.enumerated() {
                if ing.position == nil {
                    ing.position = idx
                }
            }
            for (idx, sp) in spices.enumerated() {
                if sp.position == nil {
                    sp.position = idx
                }
            }
        }

        try? modelContext.save()
    }
}



#Preview {
    RecipesView()
}


