//
//  RemindersImportView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.02.26.
//

import SwiftUI
import EventKit

struct RemindersImportView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = GroceryListViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                if let msg = viewModel.errorMessage {
                    Text(msg)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                // Picker nur anzeigen, wenn es Listen gibt
                if !viewModel.lists.isEmpty {
                    Picker("Liste", selection: $viewModel.selectedListID) {
                        ForEach(viewModel.lists, id: \.calendarIdentifier) { list in
                            Text(list.title).tag(Optional(list.calendarIdentifier))
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    .onChange(of: viewModel.selectedListID) { _, _ in
                        Task { await viewModel.reloadRemindersForSelection() }
                    }
                }

                if viewModel.isLoading {
                    ProgressView().padding(.top, 20)
                }

                List {
                    ForEach(viewModel.reminders.filter({ $0.isCompleted == false }), id: \.calendarItemIdentifier) { reminder in
                        ReminderRow(reminder: reminder)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Erinnerungen")
            .task { await viewModel.start(using: modelContext) }
        }
    }
}


#Preview {
    RemindersImportView()
}


private struct ReminderRow: View {
    let reminder: EKReminder

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reminder.title ?? "(Ohne Titel)")
                .font(.headline)

            HStack(spacing: 12) {
                if let date = reminder.dueDateComponents?.date {
                    Label(date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if reminder.isCompleted {
                    Label("Erledigt", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
