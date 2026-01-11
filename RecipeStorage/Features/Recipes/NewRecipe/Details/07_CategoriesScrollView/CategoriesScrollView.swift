//
//  CategoriesScrollView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.01.26.
//

import SwiftUI
import SwiftData

struct CategoriesScrollView: View {
    
    @Query private var categoryStores: [CategoryStore]
    private var categoryStore: CategoryStore? { categoryStores.first }
    
    private var categories: [String] {
        categoryStore?.categories ?? ["High Protein", "Low Calorie", "Vegetarian", "Vegan", "Low Carb"]
    }

    @ObservedObject var viewModel: NewRecipeViewModel
    
    private func toggle(_ category: String) {
        if viewModel.categories.contains(category) {
            viewModel.categories.remove(category)
        } else {
            viewModel.categories.insert(category)
        }
    }
    
    
    var body: some View {
        Section("Categories") {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(categories, id: \.self) { category in
                        let isSelected = viewModel.categories.contains(category)
                        
                        Button {
                            toggle(category)
                        } label: {
                            Text(category)
                                .foregroundStyle(isSelected ? .black : .recipeTitle)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 999)
                                .fill(isSelected ? .brandPrimary : .brandPrimary.opacity(0.2))
                        )
                    }
                }
            }
        }
    }
}


#Preview {
    Form {
        CategoriesScrollView(viewModel: NewRecipeViewModel())
    }
}
