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
}


struct NewRecipeView: View {
    
    @StateObject private var viewModel = NewRecipeViewModel()
    @FocusState private var focusedField: newRecipeField?
    
    private func focusNext() {
        switch focusedField {
        case .recipeName: focusedField = .servings
        case .servings: focusedField = .duration
        case .duration: focusedField = .protein
        case .protein: focusedField = .carbs
        case .carbs: focusedField = .fats
        case .fats: focusedField = nil
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
    NewRecipeView()
}


