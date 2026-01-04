//
//  AddSpicesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI


enum spiceField: Hashable {
    case spiceName
    case amount
    case newUnit
}


struct AddSpicesView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: spiceField?
    
    private func focusNext() {
        switch focusedField {
        case .spiceName: focusedField = .amount
        case .amount: focusedField = nil
        default: focusedField = nil
        }
    }
    
    var body: some View {
        
        Form {
            Section("New Spices") {
                TextField("Spice Name", text: $viewModel.spiceName)
                    .focused($focusedField, equals: .spiceName)
                
                TextField("Amount", value: $viewModel.spiceAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
                
                Picker("Unit", selection: $viewModel.spiceUnit) {
                    ForEach(viewModel.spiceUnits, id: \.self) {
                        Text("\($0)")
                    }
                }
                .onChange(of: viewModel.spiceUnit) {
                    if viewModel.spiceUnit == "Custom Unit" {
                        DispatchQueue.main.async {
                            focusedField = .newUnit
                        }
                    }
                }
                
                if viewModel.spiceUnit == "Custom Unit" {
                    HStack {
                        TextField("New Unit", text: $viewModel.newSpiceUnit)
                            .focused($focusedField, equals: .newUnit)
                        
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
                    focusedField = .spiceName
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteSpice(spice)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        viewModel.spices.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .onAppear {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
        AddSpicesView(viewModel: NewRecipeViewModel())
}
