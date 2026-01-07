//
//  RecipeSaveButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 07.01.26.
//

import SwiftUI

struct RecipeSaveButtonView: View {
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    @ObservedObject var viewModel = NewRecipeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Section {
            Button {
                guard viewModel.isValid else { return }
                
                recipesViewModel.recipes.append(
                    Recipe(
                        imageData: viewModel.imageData,
                        name: viewModel.name,
                        servings: viewModel.servings!,
                        duration: viewModel.duration!,
                        protein: viewModel.protein!,
                        carbs: viewModel.carbs!,
                        fats: viewModel.fats!,
                        customCalories: viewModel.customCalories,
                        ingredients: viewModel.ingredients,
                        spices: viewModel.spices,
                        steps: viewModel.steps
                    )
                )
                
                dismiss()
            } label: {
                Text("Save Recipe")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
            }
            .disabled(!viewModel.isValid)
        }
    }
}

#Preview {
    Form {
        RecipeSaveButtonView(recipesViewModel: RecipesViewModel(), viewModel: NewRecipeViewModel())
    }
}
