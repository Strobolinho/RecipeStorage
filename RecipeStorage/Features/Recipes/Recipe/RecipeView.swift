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
                image: recipe.imageName,
                name: recipe.name
            )
            
            Form {
                MacrosView(recipe: recipe)
            }
        }
    }
}

#Preview {
    RecipeView(recipe: mockRecipes[0])
}

