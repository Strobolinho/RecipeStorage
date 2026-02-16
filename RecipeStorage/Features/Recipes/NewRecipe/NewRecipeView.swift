//
//  NewRecipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI
import SwiftData

enum newRecipeField: Hashable {
    case recipeName, servings, duration, customCalories, protein, carbs, fats, steps
}

struct NewRecipeView: View {

    @Query private var unitStores: [UnitStore]
    @Query private var categoryStores: [CategoryStore]
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: newRecipeField?

    let recipeToEdit: Recipe?

    init(recipeToEdit: Recipe? = nil) {
        self.recipeToEdit = recipeToEdit
        _viewModel = StateObject(wrappedValue: NewRecipeViewModel(recipe: recipeToEdit))
    }

    private var categoryStore: CategoryStore? { categoryStores.first }

    var body: some View {
        Form {
            ImageView(viewModel: viewModel)
            BasicsView(viewModel: viewModel, focusedField: $focusedField)
            SetMacrosView(viewModel: viewModel, focusedField: $focusedField)
            AddIngredientsButtonView(viewModel: viewModel)
            AddSpicesButtonView(viewModel: viewModel)
            AddStepsView(viewModel: viewModel, focusedField: $focusedField)

            CategoriesScrollView(viewModel: viewModel) {
                viewModel.openAddCategorySheet()
            }

            RecipeSaveButtonView(viewModel: viewModel, recipeToEdit: recipeToEdit)
        }
        .navigationTitle("New Recipe")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") {
                    focusedField = viewModel.nextField(after: focusedField)
                }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.ensureStores(
                unitStores: unitStores,
                categoryStores: categoryStores,
                modelContext: modelContext
            )
        }
        .sheet(isPresented: $viewModel.showAddCategorySheet) {
            NewCategorySheet(viewModel: viewModel, categoryStore: categoryStore)
        }
    }
}

#Preview {
    NewRecipeView()
}
