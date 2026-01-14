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
    let onAddCategoryTap: () -> Void

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
                LazyHStack(spacing: 10) {

                    ForEach(categories, id: \.self) { category in
                        let isSelected = viewModel.categories.contains(category)

                        Button {
                            toggle(category)
                        } label: {
                            Text(category)
                                .foregroundStyle(isSelected ? .black : .recipeTitle)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 999)
                                .fill(isSelected ? .brandPrimary : .brandPrimary.opacity(0.2))
                        )
                    }
                    .font(.system(size: 10))

                    Button {
                        onAddCategoryTap()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 25))
                            .foregroundStyle(.brandPrimary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    Form {
        CategoriesScrollView(viewModel: NewRecipeViewModel()) { }
    }
}
