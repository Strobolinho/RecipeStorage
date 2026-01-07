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
    
    @StateObject private var viewModel = NewRecipeViewModel()
    @FocusState private var focusedField: newRecipeField?
    
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
            ImageView(viewModel: viewModel)
            
            BasicsView(viewModel: viewModel, focusedField: $focusedField)
            
            SetMacrosView(viewModel: viewModel, focusedField: $focusedField)
            
            AddIngredientsButtonView(viewModel: viewModel)
            
            AddSpicesButtonView(viewModel: viewModel)
            
            AddStepsView(viewModel: viewModel, focusedField: $focusedField)
            
            RecipeSaveButtonView(viewModel: viewModel)
        }
        .navigationTitle("New Recipe")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NewRecipeView()
}
