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
    @Published var showNewGroceryItemTextField: Bool = false
    
    @Published var groceryName: String = ""
    @Published var groceryAmount: Int? = nil
    @Published var groceryUnit: String = "g"
    @Published var newGroceryUnit: String = ""
       
    
    @Published var lists: [EKCalendar] = []
    @Published var selectedListID: String? = nil
    @Published var reminders: [EKReminder] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    

    private let service = RemindersService()
    
    @Published var settings: DefaultReminderList?

        func loadOrCreate(in context: ModelContext) throws {
            let key = "singleton"

            let descriptor = FetchDescriptor<DefaultReminderList>(
                predicate: #Predicate { $0.key == key }
            )

            if let existing = try context.fetch(descriptor).first {
                self.settings = existing
            } else {
                let created = DefaultReminderList(key: key, listID: "")
                context.insert(created)
                try context.save()
                self.settings = created
            }
        }

        func updateValue(_ newValue: String, in context: ModelContext) throws {
            settings?.listID = newValue
            try context.save()
        }
    
    func isCustomUnitSelected(_ unit: String) -> Bool {
        unit == "Custom Unit"
    }
    
    func addNewUnit(
        unitStore: UnitStore?
    ) {
        guard let unitStore else { return }

        let newUnit = newGroceryUnit
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newUnit.isEmpty else { return }

        if !unitStore.ingredientUnits.contains(newUnit) {
            unitStore.ingredientUnits.append(newUnit)
        }

        groceryUnit = newUnit
        newGroceryUnit = ""
    }

    func start(using context: ModelContext) async {
        do {
            // 1) Permission
            try await service.requestAccess()

            // 2) Listen laden
            lists = service.fetchLists()

            // 3) Settings laden/erstellen (damit settings?.listID verfügbar ist)
            try loadOrCreate(in: context)

            // 4) gespeicherte ID anwenden, wenn gültig
            let savedID = settings?.listID ?? ""
            if !savedID.isEmpty,
               lists.contains(where: { $0.calendarIdentifier == savedID }) {
                selectedListID = savedID
            } else {
                // Fallback: erste Liste
                selectedListID = lists.first?.calendarIdentifier

                // optional: fallback direkt speichern
                if let selectedListID {
                    try? updateValue(selectedListID, in: context)
                }
            }

            // 5) Reminders laden
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
    
    func units(from unitStore: UnitStore?) -> [String] {
        unitStore?.ingredientUnits ?? ["Custom Unit", "g", "ml"]
    }
}
