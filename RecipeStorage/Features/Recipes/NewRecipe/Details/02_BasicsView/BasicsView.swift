//
//  BasicsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct BasicsView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    var focusedField: FocusState<newRecipeField?>.Binding
    
    var body: some View {
        
        Section("Basic Data") {
            TextField("Recipe Name", text: $viewModel.name)
                .focused(focusedField, equals: .recipeName)

            TextField("Servings", value: $viewModel.servings, format: .number)
                .keyboardType(.numberPad)
                .focused(focusedField, equals: .servings)
            
            TextField("Duration", value: $viewModel.duration, format: .number)
                .keyboardType(.numberPad)
                .focused(focusedField, equals: .duration)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var vm = NewRecipeViewModel()
        @FocusState var focus: newRecipeField?

        var body: some View {
            Form {
                BasicsView(viewModel: vm, focusedField: $focus)
            }
        }
    }

    return PreviewWrapper()
}
