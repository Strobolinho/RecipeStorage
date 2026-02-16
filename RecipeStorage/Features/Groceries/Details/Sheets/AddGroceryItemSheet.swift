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
    
    
    enum NewGroceryItemField: Hashable {
        case groceryItemName
        case groceryItemAmount
        case groceryItemUnit
        case customUnit
    }

    @FocusState private var focusedField: NewGroceryItemField?

    private func focusNext() {
        switch focusedField {
        case .groceryItemName:   focusedField = .groceryItemAmount
        case .groceryItemAmount: focusedField = .groceryItemUnit
        case .groceryItemUnit:   focusedField = nil
        default:                 focusedField = nil
        }
    }

    private func focusPrevious() {
        switch focusedField {
        case .groceryItemName:   focusedField = .groceryItemName // bleibt halt dort
        case .groceryItemAmount: focusedField = .groceryItemName
        case .groceryItemUnit:   focusedField = .groceryItemAmount
        default:                 focusedField = nil
        }
    }

    private func resetSheetFields() {
        viewModel.groceryName = ""
        viewModel.groceryAmount = nil
        viewModel.groceryUnit = "g"
        focusedField = .groceryItemName
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
                    .focused($focusedField, equals: .groceryItemName)
                    .submitLabel(.next)
                    .onSubmit { focusNext() }

                TextField("Amount", value: $viewModel.groceryAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .groceryItemAmount)

                Picker("Unit", selection: $viewModel.groceryUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .onChange(of: viewModel.groceryUnit) {
                    if viewModel.isCustomUnitSelected(viewModel.groceryUnit) {
                        DispatchQueue.main.async {
                            focusedField = .customUnit
                        }
                    }
                }

                if viewModel.isCustomUnitSelected(viewModel.groceryUnit) {
                    HStack {
                        TextField("New Unit", text: $viewModel.newGroceryUnit)
                            .focused($focusedField, equals: .customUnit)

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
                    Text("Add")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.brandPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .scrollDisabled(true)
        .presentationDetents([.height(270)])

        
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("<") { focusPrevious() }
                Button(">") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }

        
        .onAppear {
            DispatchQueue.main.async {
                focusedField = .groceryItemName
            }
        }
        
        .onDisappear {
            resetSheetFields()
        }
        
    }
}

#Preview {
    AddGroceryItemSheet(viewModel: GroceryListViewModel())
}
