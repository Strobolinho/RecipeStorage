//
//  MacrosView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct SetMacrosView: View {
    
    @StateObject private var viewModel = NewRecipeViewModel()
    
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
            
            TextField("Carbs", value: $viewModel.carbs, format: .number)
                .keyboardType(.numberPad)
            
            TextField("Fats", value: $viewModel.fats, format: .number)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    Form {
        SetMacrosView()
    }
}
