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
                        viewModel.showSyncRemindersListSheet = true
                    } label : {
                        Image(systemName: "list.bullet.circle")
                    }
                    .font(.system(size: 22))
                }
                
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
            .sheet(isPresented: $viewModel.showSyncRemindersListSheet, onDismiss: {
                viewModel.showSyncRemindersListSheet = false
            }) {
                SyncRemindersSheet(viewModel: viewModel)
            }
            
            .sheet(isPresented: $viewModel.showAddGrocerySheet) {
                AddGroceryItemSheet(viewModel: viewModel)
            }
            .task { await viewModel.start() }
        }
    }
}

#Preview {
    GroceryListView()
}
