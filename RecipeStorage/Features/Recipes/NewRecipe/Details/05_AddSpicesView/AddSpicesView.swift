//
//  AddSpicesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct AddSpicesView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    
    var body: some View {
        
        Form {
            Section("New Spices") {
                TextField("Spice Name", text: $viewModel.spiceName)
                
                TextField("Amount", value: $viewModel.spiceAmount, format: .number)
                    .keyboardType(.numberPad)
                
                Picker("Unit", selection: $viewModel.spiceUnit) {
                    ForEach(viewModel.spiceUnits, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                if viewModel.spiceUnit == "Custom Unit" {
                    HStack {
                        TextField("New Unit", text: $viewModel.newSpiceUnit)
                        Button {
                            viewModel.addNewSpiceUnit()
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }
                
                Button {
                    viewModel.addSpice()
                } label: {
                    Text("Add Ingredient")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            if !viewModel.spices.isEmpty {
                Section("Added Spices") {
                    ForEach(viewModel.spices) { spice in
                        HStack {
                            Text(spice.name)
                            Spacer()
                            Text("\(spice.amount) \(spice.unit)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
        AddSpicesView(viewModel: NewRecipeViewModel())
}
