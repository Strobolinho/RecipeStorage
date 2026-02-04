//
//  GroceryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct GroceryListView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GroceryListEntry.name) private var entries: [GroceryListEntry]
    
    @StateObject private var viewModel = GroceryListViewModel()
    
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
            
        NavigationStack {
            Group {
                if !entries.isEmpty {
                    List {
                        Section("Open Items") {
                            ForEach(entries.filter { $0.isChecked == false } ) { entry in
                                GroceryListEntryView(entry: entry)
                            }
                        }
                        
                        Section("Collected Items") {
                            ForEach(entries.filter { $0.isChecked == true } ) { entry in
                                GroceryListEntryView(entry: entry)
                            }
                        }
                    }
                    .padding(.top, -30)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "cart.fill.badge.questionmark")
                            .font(.system(size: 70))
                            .foregroundStyle(.brandPrimary)
                        
                        Text("No Groceries added to the List")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Add your Groceries")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.brandPrimary)
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showDeleteAllDialog = true
                    } label: {
                        Image(systemName: "trash.circle")
                    }
                    .font(.system(size: 22))
                    .alert("Are you sure you want to delete all groceries?", isPresented: $viewModel.showDeleteAllDialog) {
                        Button("Delete all", role: .destructive) {
                            for entry in entries {
                                modelContext.delete(entry)
                            }
                        }
                        Button(role: .cancel) {}
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showAddGrocerySheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .font(.system(size: 22))
                }
                ToolbarItem(placement: .principal) {
                    Text("Groceries")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.brandPrimary)
                }
            }
            .sheet(isPresented: $viewModel.showAddGrocerySheet) {
                viewModel.showAddGrocerySheet = false
                viewModel.groceryName = ""
                viewModel.groceryAmount = nil
                viewModel.groceryUnit = ""
            } content: {
                List {
                    Section {
                        TextField("Grocery Name", text: $viewModel.groceryName)
                        
                        TextField("Amount", value: $viewModel.groceryAmount, format: .number)
                            .keyboardType(.numberPad)
                        
                        TextField("Unit", text: $viewModel.groceryUnit)
                    }
                    
                    Section {
                        Button {
                            if viewModel.groceryName != "" && viewModel.groceryAmount ?? 0 > 0 && viewModel.groceryUnit != "" {
                                addGroceryItem(GroceryListEntry(name: viewModel.groceryName, unit: viewModel.groceryUnit, amount: viewModel.groceryAmount ?? 0))
                                viewModel.showAddGrocerySheet = false
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
            }
        }
    }
}


#Preview {
    GroceryListView()
}
