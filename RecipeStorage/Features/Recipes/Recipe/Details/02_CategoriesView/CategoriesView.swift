//
//  CategoriesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.01.26.
//

import SwiftUI

struct CategoriesView: View {
    
    let recipe: Recipe
    
    var body: some View {
        Section("Categories") {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(Array(recipe.categories), id: \.self) { category in
                        Text(category)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 999)
                                    .fill(.brandPrimary)
                            )
                    }
                }
                .font(.system(size: 10))
            }
        }
    }
}


#Preview {
    Form {
        CategoriesView(recipe: mockRecipes[0])
    }
}
