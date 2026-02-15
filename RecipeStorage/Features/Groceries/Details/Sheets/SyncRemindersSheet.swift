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
                        .onChange(of: viewModel.selectedListID) { _, newValue in
                            Task { @MainActor in
                                if let newValue {
                                    try? viewModel.updateValue(newValue, in: modelContext)
                                }
                                await viewModel.reloadRemindersForSelection()
                            }
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
        .task { @MainActor in
            do {
                // ✅ 1) Settings laden/erstellen
                try viewModel.loadOrCreate(in: modelContext)

                // ✅ 2) gespeicherten Wert setzen (nur wenn noch gültig)
                if let saved = viewModel.settings?.listID, !saved.isEmpty,
                   viewModel.lists.contains(where: { $0.calendarIdentifier == saved }) {
                    viewModel.selectedListID = saved
                }

            } catch {
                print("❌ loadOrCreate failed:", error)
            }

            // ✅ 3) Reminders starten (lädt Listen etc.)
            await viewModel.start(using: modelContext)

            // ✅ 4) NACHdem lists geladen sind: saved nochmal anwenden (korrektes Timing!)
            if let saved = viewModel.settings?.listID, !saved.isEmpty,
               viewModel.lists.contains(where: { $0.calendarIdentifier == saved }) {
                viewModel.selectedListID = saved
            } else if viewModel.selectedListID == nil {
                viewModel.selectedListID = viewModel.lists.first?.calendarIdentifier
            }

            // ✅ 5) Reminders passend zur Auswahl laden
            await viewModel.reloadRemindersForSelection()
        }

    }
}

#Preview {
    SyncRemindersSheet(viewModel: GroceryListViewModel())
}
