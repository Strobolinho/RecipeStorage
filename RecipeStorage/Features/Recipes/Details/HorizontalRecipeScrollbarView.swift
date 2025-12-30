//
//  HorizontalRecipeScrollbar.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import SwiftUI

struct HorizontalRecipeScrollbarView: View {
    
    let title: String
    let recipes: [Recipe]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .foregroundStyle(.brandPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
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
            .frame(height: 220)
        }
        .padding(.vertical)
    }
}

#Preview {
    HorizontalRecipeScrollbarView(title: "Alle Rezepte", recipes: mockRecipes)
}
