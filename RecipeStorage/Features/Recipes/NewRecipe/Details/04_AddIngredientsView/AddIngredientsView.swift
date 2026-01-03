//
//  AddIngredientsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct AddIngredientsView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    
    var body: some View {
        
        Form {
            Section("New Ingredients") {
                TextField("Ingredient Name", text: $viewModel.ingredientName)
                
                TextField("Amount", value: $viewModel.ingredientAmount, format: .number)
                    .keyboardType(.numberPad)
                
                Picker("Unit", selection: $viewModel.ingredientUnit) {
                    ForEach(viewModel.ingredientUnits, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                if viewModel.ingredientUnit == "Custom Unit" {
                    HStack {
                        TextField("New Unit", text: $viewModel.newIngredientUnit)
                        Button {
                            viewModel.addNewIngredientUnit()
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }
                
                Button {
                    viewModel.addIngredient()
                } label: {
                    Text("Add Ingredient")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        
            if !viewModel.ingredients.isEmpty {
                Section("Added Ingredients") {
                    ForEach(viewModel.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.amount) \(ingredient.unit)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddIngredientsView(viewModel: NewRecipeViewModel())
}
