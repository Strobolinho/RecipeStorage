//
//  GroceryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct GroceriesView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GroceryListEntry.name) private var entries: [GroceryListEntry]

    @StateObject private var viewModel = GroceryListViewModel()
    

    var body: some View {

        NavigationStack {
            Group {
                if !entries.isEmpty {
                    GroceryListView(entries: entries)
                        .padding(.top, -30)
                } else {
                    EmptyGroceryListView()
                        .padding()
                }
            }
            .toolbar {
                GroceriesToolbar(showSyncRemindersListSheet: $viewModel.showSyncRemindersListSheet, showDeleteAllDialog: $viewModel.showDeleteAllDialog, showAddGrocerySheet: $viewModel.showAddGrocerySheet)
            }
            .alert("Are you sure you want to delete all groceries?", isPresented: $viewModel.showDeleteAllDialog) {
                Button("Delete all", role: .destructive) {
                    for entry in entries {
                        modelContext.delete(entry)
                    }
                }
                Button(role: .cancel) {}
            }
            .sheet(isPresented: $viewModel.showSyncRemindersListSheet, onDismiss: {
                viewModel.showSyncRemindersListSheet = false
            }) {
                SyncRemindersSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showAddGrocerySheet) {
                AddGroceryItemSheet(viewModel: viewModel)
            }
            .task { await viewModel.start(using: modelContext) }
        }
    }
}

#Preview {
    GroceriesView()
}
