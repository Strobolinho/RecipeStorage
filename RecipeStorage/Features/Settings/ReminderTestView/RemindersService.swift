//
//  RemindersService.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.02.26.
//

import Foundation
import EventKit

final class RemindersService {
    private let store = EKEventStore()

    /// Fragt Zugriff an (iOS 17+). Wirft Fehler, wenn iOS es blockt.
    func requestAccess() async throws {
        _ = try await store.requestFullAccessToReminders()
    }

    /// Liefert alle Reminder-Listen (entsprechen Listen in der Erinnerungen-App)
    func fetchLists() -> [EKCalendar] {
        store.calendars(for: .reminder)
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    /// Lädt alle Reminder aus genau einer Liste
    func fetchReminders(in list: EKCalendar) async throws -> [EKReminder] {
        let predicate = store.predicateForReminders(in: [list])

        return try await withCheckedThrowingContinuation { continuation in
            store.fetchReminders(matching: predicate) { reminders in
                continuation.resume(returning: reminders ?? [])
            }
        }
    }
}
