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
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeView(recipe: recipe)
                    } label: {
                        RecipeCardView(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 260)
    }
}


#Preview {
    RecipesView()
}
