//
//  RecipesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct RecipesView: View {

    let recipes: [Recipe] = mockRecipes

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                HorizontalRecipeScrollbarView(
                    title: "Alle Rezepte 🍽️",
                    recipes: recipes
                )
                
                HorizontalRecipeScrollbarView(
                    title: "Proteinreich 💪",
                    recipes: recipes.filter { recipe in
                        recipe.protein >= 150
                    }
                )
                
                HorizontalRecipeScrollbarView(
                    title: "Kalorienarm 🔥",
                    recipes: recipes.filter { recipe in
                        (recipe.calories / recipe.servings) < 600
                    }
                )
                
                HorizontalRecipeScrollbarView(
                    title: "Low Carb 🚫🍞",
                    recipes: recipes.filter { recipe in
                        recipe.carbs < 120
                    }
                )
            }
        }
    }
}


#Preview {
    RecipesView()
}
