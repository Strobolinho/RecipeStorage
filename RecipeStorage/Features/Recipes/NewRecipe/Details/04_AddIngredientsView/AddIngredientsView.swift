//
//  AddIngredientsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI
import SwiftData


enum ingredientField: Hashable {
    case ingredientName
    case amount
    case newUnit
}


struct AddIngredientsView: View {
    
    @Query private var unitStores: [UnitStore]
    private var unitStore: UnitStore? { unitStores.first }
    
    @ObservedObject var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: ingredientField?
    
    @EnvironmentObject private var ingredientsStore: IngredientStore
    
    private func focusNext() {
        switch focusedField {
        case .ingredientName: focusedField = .amount
        case .amount: focusedField = nil
        default: focusedField = nil
        }
    }
    
    private func addNewIngredientUnit() {
        guard let unitStore else { return }
        
        let newUnit = viewModel.newIngredientUnit
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newUnit.isEmpty else { return }

        if !unitStore.ingredientUnits.contains(newUnit) {
            unitStore.ingredientUnits.append(newUnit)
        }

        viewModel.ingredientUnit = newUnit
        viewModel.newIngredientUnit = ""
    }
    
    
    private var ingredientSuggestions: [String] {
        let input = viewModel.ingredientName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard !input.isEmpty else { return [] }
        
        return ingredientsStore.ingredientNames
            .filter { $0.lowercased().contains(input) }
            .prefix(3)
            .map { $0 }
    }

    
    var body: some View {
        
        Form {
            Section("New Ingredients") {
                TextField("Ingredient Name", text: $viewModel.ingredientName)
                    .focused($focusedField, equals: .ingredientName)
                
                if focusedField == .ingredientName && !ingredientSuggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(ingredientSuggestions, id: \.self) { suggestion in
                            Button {
                                viewModel.ingredientName = suggestion
                                focusedField = .amount
                            } label: {
                                Text(suggestion)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 999)
                                            .foregroundStyle(.brandPrimary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                TextField("Amount", value: $viewModel.ingredientAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
                
                Picker("Unit", selection: $viewModel.ingredientUnit) {
                    ForEach(unitStore?.ingredientUnits ?? ["Custom Unit", "g", "ml"], id: \.self) { unit in
                        Text(unit)
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
                            addNewIngredientUnit()
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
                    ForEach(viewModel.ingredients.sorted { ($0.position ?? 0) < ($1.position ?? 0) }) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.amount) \(ingredient.unit)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteIngredient(ingredient)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        viewModel.ingredients.move(fromOffsets: indices, toOffset: newOffset)
                        viewModel.reindexIngredients()
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
            focusedField = .ingredientName
        }
    }
}


#Preview {
    AddIngredientsView(viewModel: NewRecipeViewModel())
        .environmentObject({
            let store = IngredientStore()
            store.ingredientNames = ["Tomato", "Tomato Sauce", "Salt", "Sugar", "Olive Oil"]
            return store
        }())
}
