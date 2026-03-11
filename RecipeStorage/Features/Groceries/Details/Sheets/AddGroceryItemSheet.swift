//
//  AddGroceryItemSheet.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 12.02.26.
//

import SwiftUI
import SwiftData

struct AddGroceryItemSheet: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GroceryListEntry.name) private var entries: [GroceryListEntry]
    
    @Query private var unitStores: [UnitStore]
    private var unitStore: UnitStore? { unitStores.first }
    
    @ObservedObject var viewModel: GroceryListViewModel
    
    var focusedField: FocusState<NewGroceryItemField?>.Binding

    private func resetSheetFields() {
        viewModel.groceryName = ""
        viewModel.groceryAmount = nil
        viewModel.groceryUnit = "g"
        
        if viewModel.updateGroceryItem {
            viewModel.showAddGrocerySheet = false
        } else {
            focusedField.wrappedValue = .groceryItemName
        }
        
        viewModel.updateGroceryItem = false
    }
    
    
    func addGroceryItem(_ newGroceryItem: GroceryListEntry) {
        if let existing = entries.first(where: { $0.name == newGroceryItem.name && $0.unit == newGroceryItem.unit }) {
            existing.amount! += newGroceryItem.amount!
            existing.isChecked = false
        } else {
            modelContext.insert(newGroceryItem)
        }

        do { try modelContext.save() }
        catch { print("❌ save failed:", error) }
    }
    
    
    var body: some View {
        
        let units = viewModel.units(from: unitStore)
        
        Form {
            Section {
                TextField("Grocery Name", text: $viewModel.groceryName)
                    .focused(focusedField, equals: .groceryItemName)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField.wrappedValue = .groceryItemAmount
                    }

                TextField("Amount", value: $viewModel.groceryAmount, format: .number)
                    .keyboardType(.decimalPad)
                    .focused(focusedField, equals: .groceryItemAmount)

                Picker("Unit", selection: $viewModel.groceryUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .onChange(of: viewModel.groceryUnit) {
                    if viewModel.isCustomUnitSelected(viewModel.groceryUnit) {
                        DispatchQueue.main.async {
                            focusedField.wrappedValue = .customUnit
                        }
                    }
                }

                if viewModel.isCustomUnitSelected(viewModel.groceryUnit) {
                    HStack {
                        TextField("New Unit", text: $viewModel.newGroceryUnit)
                            .focused(focusedField, equals: .customUnit)

                        Button {
                            viewModel.addNewUnit(unitStore: unitStore)
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }
            }

            Section {
                Button {
                    if viewModel.groceryName != ""  {

                        if let entry = viewModel.groceryEntryToDelete {
                            modelContext.delete(entry)
                            
                            viewModel.groceryEntryToDelete = nil
                        }
                        addGroceryItem(
                            GroceryListEntry(
                                name: viewModel.groceryName,
                                unit: viewModel.groceryUnit,
                                amount: viewModel.groceryAmount ?? 0
                            )
                        )
                        
                        resetSheetFields()
                    }
                } label: {
                    Text(viewModel.updateGroceryItem ? "Update" : "Add")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.brandPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .scrollDisabled(true)
        .presentationDetents([.height(270)])
        .task {
            if !viewModel.updateGroceryItem {
                try? await Task.sleep(for: .milliseconds(500))
                focusedField.wrappedValue = .groceryItemName
            }
        }
        .onDisappear {
            resetSheetFields()
        }
        
    }
}
