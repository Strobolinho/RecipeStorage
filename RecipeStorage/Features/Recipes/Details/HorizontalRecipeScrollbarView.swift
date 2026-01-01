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
                .foregroundStyle(.brandPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)


            if recipes.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(recipes.sorted { $0.name < $1.name }) { recipe in
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
            } else {
                Text("Keine Rezepte verfügbar...")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    HorizontalRecipeScrollbarView(title: "Alle Rezepte", recipes: mockRecipes)
}
