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

    enum NewGroceryItemField: Hashable {
        case groceryItemName
        case groceryItemAmount
        case groceryItemUnit
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
        viewModel.groceryUnit = ""
        focusedField = nil
    }

    var body: some View {

        NavigationStack {
            Group {
                if !entries.isEmpty {
                    List {
                        Section("Open Items") {
                            ForEach(entries.filter { !$0.isChecked }) { entry in
                                GroceryListEntryView(entry: entry)
                            }
                        }

                        Section("Collected Items") {
                            ForEach(entries.filter { $0.isChecked }) { entry in
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
                        Image(systemName: "cart.badge.plus")
                    }
                    .font(.system(size: 18))
                }

                ToolbarItem(placement: .principal) {
                    Text("Groceries")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.brandPrimary)
                }
            }
            .sheet(isPresented: $viewModel.showAddGrocerySheet, onDismiss: {
                resetSheetFields()
            }) {
                Form {
                    Section {
                        TextField("Grocery Name", text: $viewModel.groceryName)
                            .focused($focusedField, equals: .groceryItemName)
                            .submitLabel(.next)
                            .onSubmit { focusNext() }

                        TextField("Amount", value: $viewModel.groceryAmount, format: .number)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .groceryItemAmount)

                        TextField("Unit", text: $viewModel.groceryUnit)
                            .focused($focusedField, equals: .groceryItemUnit)
                            .submitLabel(.done)
                            .onSubmit { focusedField = nil }
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

                // ✅ Keyboard Toolbar MUSS im Sheet sitzen
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("<") { focusPrevious() }
                        Button(">") { focusNext() }
                        Spacer()
                        Button("Done") { focusedField = nil }
                    }
                }

                // ✅ Fokus 1 Tick später setzen
                .onAppear {
                    DispatchQueue.main.async {
                        focusedField = .groceryItemName
                    }
                }
            }
        }
    }
}

#Preview {
    GroceryListView()
}
