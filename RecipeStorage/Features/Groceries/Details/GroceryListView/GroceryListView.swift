//
//  GroceryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.02.26.
//

import SwiftUI
import SwiftData

struct GroceryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var entries: [GroceryListEntry]
    
    @ObservedObject var viewModel: GroceryListViewModel
    
    var focusedField: FocusState<NewGroceryItemField?>.Binding

    var openItems: [GroceryListEntry] { entries.filter { !$0.isChecked } }
    var collectedItems: [GroceryListEntry] { entries.filter { $0.isChecked } }
    
    
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
        List {
            Section("Open Items") {
                ForEach(openItems) { entry in
                    GroceryListEntryView(entry: entry)
                }
                
                if viewModel.showNewGroceryItemTextField {
                    TextField("New Grocery Item", text: $viewModel.groceryName)
                        .focused(focusedField, equals: .groceryItemName)
                        .onSubmit {
                            addGroceryItem(
                                GroceryListEntry(name: viewModel.groceryName, unit: "", amount: 0)
                            )
                            
                            viewModel.groceryName = ""
                            focusedField.wrappedValue = .groceryItemName
                        }
                }
            }

            Section("Collected Items") {
                ForEach(collectedItems) { entry in
                    GroceryListEntryView(entry: entry)
                }
            }
        }
    }
}
