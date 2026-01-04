//
//  NewRecipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI


enum newRecipeField: Hashable {
    case recipeName
    case servings
    case duration
    case customCalories
    case protein
    case carbs
    case fats
    case steps
}


struct NewRecipeView: View {
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    @StateObject private var viewModel = NewRecipeViewModel()
    @FocusState private var focusedField: newRecipeField?
    @Environment(\.dismiss) private var dismiss
    
    private func focusNext() {
        switch focusedField {
        case .recipeName: focusedField = .servings
        case .servings: focusedField = .duration
        case .duration: do {
            if viewModel.isCustomCalories {
                focusedField = .customCalories
            } else {
                focusedField = .protein
            }
        }
        case .customCalories: focusedField = .protein
        case .protein: focusedField = .carbs
        case .carbs: focusedField = .fats
        case .fats: focusedField = .steps
        case .steps: focusedField = nil
        default: focusedField = nil
        }
    }
    
    
    var body: some View {
        Form {
            ImageView()
            
            BasicsView(viewModel: viewModel, focusedField: $focusedField)
            
            SetMacrosView(viewModel: viewModel, focusedField: $focusedField)
            
            AddIngredientsButtonView(viewModel: viewModel)
            
            AddSpicesButtonView(viewModel: viewModel)
            
            AddStepsView(viewModel: viewModel, focusedField: $focusedField)
            
            Section {
                Button {
                    guard viewModel.isValid else { return }
                    
                    recipesViewModel.recipes.append(
                        Recipe(
                            name: viewModel.name,
                            imageName: "kaiserschmarrn",
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
        .navigationTitle("New Recipe")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }
}

#Preview {
    NewRecipeView(recipesViewModel: RecipesViewModel())
}
