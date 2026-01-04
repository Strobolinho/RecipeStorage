//
//  MacrosView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct SetMacrosView: View {
    
    @ObservedObject  var viewModel: NewRecipeViewModel
    var focusedField: FocusState<newRecipeField?>.Binding
    
    var body: some View {
        
        Section("Macros") {
            
            if viewModel.isCustomCalories {
                TextField("Custom Calories", value: $viewModel.customCalories, format: .number)
                    .keyboardType(.numberPad)
            } else {
                HStack {
                    Text("Calories:")
                    Spacer()
                    Text("\(viewModel.calories) kcal")
                }
            }
            
            Toggle("Custom Calories", isOn: $viewModel.isCustomCalories)
            
            TextField("Protein", value: $viewModel.protein, format: .number)
                .keyboardType(.numberPad)
                .focused(focusedField, equals: .protein)
            
            TextField("Carbs", value: $viewModel.carbs, format: .number)
                .keyboardType(.numberPad)
                .focused(focusedField, equals: .carbs)
            
            TextField("Fats", value: $viewModel.fats, format: .number)
                .keyboardType(.numberPad)
                .focused(focusedField, equals: .fats)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var vm = NewRecipeViewModel()
        @FocusState var focus: newRecipeField?

        var body: some View {
            Form {
                SetMacrosView(viewModel: vm, focusedField: $focus)
            }
        }
    }

    return PreviewWrapper()
}
