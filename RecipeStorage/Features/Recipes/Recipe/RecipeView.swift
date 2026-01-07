//
//  RwcipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct RecipeView: View {
    
    let recipe: Recipe
    
    var body: some View {
        VStack {
            RecipeTopImageView(
                imageData: recipe.imageData,
                name: recipe.name
            )
            
            Form {
                MacrosView(recipe: recipe)
                
                IngredientListView(recipe: recipe)
                
                SpiceListView(recipe: recipe)
                
                StepsListView(recipe: recipe)
            }
            
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    RecipeView(recipe: mockRecipes[0])
}
