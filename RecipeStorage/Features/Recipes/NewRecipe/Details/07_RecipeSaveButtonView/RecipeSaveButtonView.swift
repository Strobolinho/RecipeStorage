//
//  RecipeSaveButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 07.01.26.
//


import SwiftUI
import SwiftData

struct RecipeSaveButtonView: View {

    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: NewRecipeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Section {
            Button {
                guard viewModel.isValid,
                      let servings = viewModel.servings,
                      let duration = viewModel.duration,
                      let protein = viewModel.protein,
                      let carbs = viewModel.carbs,
                      let fats = viewModel.fats
                else { return }

                let recipe = Recipe(
                    imageData: viewModel.imageData,
                    name: viewModel.name,
                    servings: servings,
                    duration: duration,
                    protein: protein,
                    carbs: carbs,
                    fats: fats,
                    customCalories: viewModel.customCalories,
                    ingredients: viewModel.ingredients,
                    spices: viewModel.spices,
                    steps: viewModel.steps
                )

                modelContext.insert(recipe)
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
        RecipeSaveButtonView(viewModel: NewRecipeViewModel())
    }
    .modelContainer(for: Recipe.self, inMemory: true)
}
