//
//  GroceryListViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 04.02.26.
//

import Foundation
import SwiftData
import EventKit


@MainActor
final class GroceryListViewModel: ObservableObject {
    
    //    var entries: [GroceryListEntry] = [
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //        GroceryListEntry(name: "Eier", unit: "Stueck", amount: 3, isChecked: false),
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //    ]
    
    @Published var showAddGrocerySheet: Bool = false
    @Published var showDeleteAllDialog: Bool = false
    @Published var showSyncRemindersListSheet: Bool = false
    
    @Published var groceryName: String = ""
    @Published var groceryAmount: Int? = nil
    @Published var groceryUnit: String = ""
       
    
    @Published var lists: [EKCalendar] = []
    @Published var selectedListID: String? = nil
    @Published var reminders: [EKReminder] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    

    private let service = RemindersService()

    func start() async {
        do {
            // 1) Permission
            try await service.requestAccess()

            // 2) Listen laden
            lists = service.fetchLists()

            // 3) Default-Auswahl setzen
            if selectedListID == nil {
                selectedListID = lists.first?.calendarIdentifier
            }

            // 4) Reminders laden
            await reloadRemindersForSelection()

        } catch {
            errorMessage = """
            Zugriff auf Erinnerungen nicht möglich.
            \(error.localizedDescription)
            """
        }
    }

    func reloadRemindersForSelection() async {
        guard let id = selectedListID,
              let list = lists.first(where: { $0.calendarIdentifier == id }) else {
            reminders = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let r = try await service.fetchReminders(in: list)

            // Sortierung: zuerst fällige, dann Titel
            reminders = r.sorted { a, b in
                let da = a.dueDateComponents?.date ?? .distantFuture
                let db = b.dueDateComponents?.date ?? .distantFuture
                if da != db { return da < db }
                return (a.title ?? "").localizedCaseInsensitiveCompare(b.title ?? "") == .orderedAscending
            }
        } catch {
            errorMessage = "Fehler beim Laden der Erinnerungen: \(error.localizedDescription)"
        }
    }
    
    
    func syncRemindersList() async -> [String] {
        
        await reloadRemindersForSelection()
        
        var reminderList: [String] = []
        
        for rem in reminders.filter({ $0.isCompleted == false }) {
            reminderList.append(rem.title)
        }
        
        return reminderList
    }
}
