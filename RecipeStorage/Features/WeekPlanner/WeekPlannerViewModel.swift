//
//  WeekPlannerViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class WeekPlannerViewModel: ObservableObject {

    // MARK: - Paging config

    private let daysRange: ClosedRange<Int> = -30...30

    // MARK: - UI State

    @Published var selectedIndex: Int
    @Published var date: Date

    @Published var isEditing: Bool = false
    @Published var showEntriesSheet: Bool = false
    @Published var showAddGroceriesDialog: Bool = false

    // MARK: - Init

    init(initialDate: Date = Date()) {
        self.date = initialDate
        self.selectedIndex = abs(daysRange.lowerBound) // bei -30...30 => 30
        // date wird in syncInitial(...) sauber gesetzt, sobald dates verfügbar sind
    }

    // MARK: - Computed

    var dates: [Date] {
        daysRange.compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: Date())
        }
    }

    func weekdayTitle(for date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide))
    }

    // MARK: - Sync helpers

    /// beim ersten Erscheinen: date auf pager-sync
    func syncInitialDateWithSelectedIndex() {
        date = dates[safe: selectedIndex] ?? Date()
    }

    func didSwipe(to newIndex: Int) {
        if let newDate = dates[safe: newIndex] {
            date = newDate
        }
    }

    /// Wenn DatePicker geändert wurde → passenden Index ermitteln (falls im Range)
    func indexForDate(_ target: Date) -> Int? {
        dates.firstIndex { Calendar.current.isDate($0, inSameDayAs: target) }
    }

    func targetIndexForDateChange(_ newValue: Date) -> Int? {
        indexForDate(newValue)
    }

    func jumpToToday() -> Int? {
        date = Date()
        return indexForDate(Date())
    }

    // MARK: - Mealplan filtering

    func entries(for date: Date, in all: [MealPlanEntry]) -> [MealPlanEntry] {
        all.filter { Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    func canAddGroceries(for date: Date, mealplanEntries: [MealPlanEntry]) -> Bool {
        !entries(for: date, in: mealplanEntries).isEmpty
    }

    // MARK: - Grocery merge + insert

    /// Erzeugt aus MealPlanEntries (für den Tag) die GroceryListEntries
    func groceryItemsForDay(mealplanEntriesForDay: [MealPlanEntry]) -> [GroceryListEntry] {
        var result: [GroceryListEntry] = []

        for entry in mealplanEntriesForDay {
            guard let recipe = entry.recipe, let ingredients = recipe.ingredients else { continue }
            for ing in ingredients {
                result.append(
                    GroceryListEntry(
                        name: ing.name,
                        unit: ing.unit,
                        amount: ing.amount,
                        isChecked: false
                    )
                )
            }
        }

        return result
    }

    
    private func key(name: String, unit: String) -> String {
        "\(name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())|\(unit)"
    }

    func addGroceriesForCurrentDay(
        mealplanEntries: [MealPlanEntry],
        groceryEntries: [GroceryListEntry],
        modelContext: ModelContext
    ) {
        let todaysEntries = entries(for: date, in: mealplanEntries)
        let items = groceryItemsForDay(mealplanEntriesForDay: todaysEntries)

        // 1) Items des Tages deduplizieren/aufsummieren
        var summed: [String: GroceryListEntry] = [:]
        for item in items {
            let k = key(name: item.name, unit: item.unit)
            if let existing = summed[k] {
                existing.amount = (existing.amount ?? 0) + (item.amount ?? 0)
            } else {
                summed[k] = item
            }
        }

        // 2) Gegen bestehende Liste mergen
        var working = groceryEntries

        for item in summed.values {
            if let existing = working.first(where: {
                key(name: $0.name, unit: $0.unit) == key(name: item.name, unit: item.unit)
            }) {
                existing.amount = (existing.amount ?? 0) + (item.amount ?? 0)
                existing.isChecked = false
            } else {
                modelContext.insert(item)
                working.append(item)
            }
        }

        do { try modelContext.save() }
        catch { print("❌ save failed:", error) }
    }



    // MARK: - UI Actions

    func openEntriesSheet() {
        showEntriesSheet = true
    }

    func requestAddGroceriesIfPossible(mealplanEntries: [MealPlanEntry]) {
        if canAddGroceries(for: date, mealplanEntries: mealplanEntries) {
            showAddGroceriesDialog = true
        }
    }

    func toggleEditing() {
        isEditing.toggle()
    }
}

// MARK: - Safe Indexing

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
