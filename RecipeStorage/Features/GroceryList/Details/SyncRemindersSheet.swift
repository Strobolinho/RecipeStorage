//
//  SyncRemindersSheet.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 12.02.26.
//

import SwiftUI
import SwiftData

struct SyncRemindersSheet: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GroceryListEntry.name) private var entries: [GroceryListEntry]
    
    @ObservedObject var viewModel: GroceryListViewModel
    
    var body: some View {
        
        VStack {
            if let msg = viewModel.errorMessage {
                Text(msg)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }
            
            if viewModel.isLoading {
                ProgressView().padding(.top, 20)
            }
            
            Text("Sync Reminder List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
                    .padding(.top)
            
            Form {
                if !viewModel.lists.isEmpty {
                    
                    Section {
                        Picker("Reminder List", selection: $viewModel.selectedListID) {
                            ForEach(viewModel.lists, id: \.calendarIdentifier) { list in
                                Text(list.title).tag(Optional(list.calendarIdentifier))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.semibold)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal)
                        .onChange(of: viewModel.selectedListID) { _, _ in
                            Task { await viewModel.reloadRemindersForSelection() }
                        }
                    }
                    
                    Section {
                        Button {
                            Task {
                                let reminders = await viewModel.syncRemindersList()
                                
                                for rem in reminders {
                                    if !(entries.map { $0.name }.contains(rem)) {
                                        modelContext.insert(
                                            GroceryListEntry(name: rem, unit: "", amount: 0, isChecked: false)
                                        )
                                    }
                                }
                                
                                do { try modelContext.save() }
                                catch { print("❌ save failed:", error) }
                            }
                        } label: {
                            Text("Sync")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .scrollDisabled(true)
            .presentationDetents([.height(220)])
            .padding(.top, -30)
        }
    }
}

#Preview {
    SyncRemindersSheet(viewModel: GroceryListViewModel())
}
