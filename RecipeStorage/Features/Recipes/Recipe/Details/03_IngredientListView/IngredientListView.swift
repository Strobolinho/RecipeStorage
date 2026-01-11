//
//  IngredientListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 31.12.25.
//

import SwiftUI

struct IngredientListView: View {
    
    let recipe: Recipe
    
    var body: some View {
        Section("Ingredients") {
            let ingredients = (recipe.ingredients ?? []).sorted { ($0.position ?? 0) < ($1.position ?? 0) }
            
            ForEach(ingredients) { ingredient in
                HStack {
                    Text(ingredient.name)
                    
                    Spacer()
                    
                    Text("\(ingredient.amount) \(ingredient.unit)")
                }
            }
        }
    }
}

#Preview {
    IngredientListView(recipe: mockRecipes[0])
}
