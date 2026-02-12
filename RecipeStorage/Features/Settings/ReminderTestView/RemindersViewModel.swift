//
//  RemindersViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.02.26.
//

import Foundation
import EventKit
import SwiftUI

@MainActor
final class RemindersViewModel: ObservableObject {
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
}
