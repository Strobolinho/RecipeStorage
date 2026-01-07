//
//  RecipesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct RecipesView: View {

    @Query(sort: \Recipe.name) private var recipes: [Recipe]

    var body: some View {
        NavigationStack {
            ZStack {
                if !recipes.isEmpty {
                    ScrollView(.vertical) {
                        HorizontalRecipeScrollbarView(
                            title: "Alle Rezepte 🍽️",
                            recipes: recipes
                        )
                        
                        HorizontalRecipeScrollbarView(
                            title: "Proteinreich 💪",
                            recipes: recipes.filter { recipe in
                                ((Double(recipe.protein) / Double(recipe.calories)) * 10 ) >= 0.75
                            }
                        )
                        
                        HorizontalRecipeScrollbarView(
                            title: "Kalorienarm 🥗",
                            recipes: recipes.filter { recipe in
                                (recipe.calories / recipe.servings) < 600
                            }
                        )
                        
                        HorizontalRecipeScrollbarView(
                            title: "Low Carb 🚫🍞",
                            recipes: recipes.filter { recipe in
                                (recipe.carbs / recipe.servings) < 30
                            }
                        )
                        
                        HorizontalRecipeScrollbarView(
                            title: "Low Fat 🚫🥑",
                            recipes: recipes.filter { recipe in
                                (recipe.fats / recipe.servings) < 15
                            }
                        )
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
    }
}


#Preview {
    RecipesView()
}


