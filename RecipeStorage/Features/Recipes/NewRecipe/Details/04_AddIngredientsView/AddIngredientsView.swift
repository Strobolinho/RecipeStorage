//
//  AddIngredientsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI


enum ingredientField: Hashable {
    case ingredientName
    case amount
    case newUnit
}


struct AddIngredientsView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: ingredientField?
    
    var body: some View {
        
        Form {
            Section("New Ingredients") {
                TextField("Ingredient Name", text: $viewModel.ingredientName)
                    .focused($focusedField, equals: .ingredientName)
                
                TextField("Amount", value: $viewModel.ingredientAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
                
                Picker("Unit", selection: $viewModel.ingredientUnit) {
                    ForEach(viewModel.ingredientUnits, id: \.self) {
                        Text("\($0)")
                    }
                }
                .onChange(of: viewModel.ingredientUnit) {
                    if viewModel.ingredientUnit == "Custom Unit" {
                        DispatchQueue.main.async {
                            focusedField = .newUnit
                        }
                    }
                }
                
                
                if viewModel.ingredientUnit == "Custom Unit" {
                    HStack {
                        TextField("New Unit", text: $viewModel.newIngredientUnit)
                            .focused($focusedField, equals: .newUnit)
                        
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
                    focusedField = .ingredientName
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
        .onAppear {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    AddIngredientsView(viewModel: NewRecipeViewModel())
}
