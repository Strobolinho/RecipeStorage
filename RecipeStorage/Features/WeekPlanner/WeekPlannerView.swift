//
//  WeekPlannerView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct WeekPlannerView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealPlanEntry.day) private var mealplanEntries: [MealPlanEntry]
    @Query(sort: \GroceryListEntry.name) private var groceryEntries: [GroceryListEntry]

    // MARK: - Paging

    /// Wie viele Tage vor/zurück du swipen kannst (hier: 60 Tage Gesamt)
    private let daysRange = -30...30

    private var dates: [Date] {
        daysRange.compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: Date())
        }
    }

    /// Index in `dates` (heute ist bei -30...30 -> Index 30)
    @State private var selectedIndex: Int = 30

    /// Aktuelles Datum (für DatePicker etc.)
    @State private var date: Date = Date()

    @State private var isEditing: Bool = false

    @State private var showEntriesSheet: Bool = false
    @State private var showAddGroceriesDialog: Bool = false

    func addGroceryItem(_ newGroceryItem: GroceryListEntry) {
        if let existing = groceryEntries.first(where: { $0.name == newGroceryItem.name && $0.unit == newGroceryItem.unit }) {
            existing.amount! += newGroceryItem.amount!
            existing.isChecked = false
        } else {
            modelContext.insert(newGroceryItem)
        }

        do { try modelContext.save() }
        catch { print("❌ save failed:", error) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text(date.formatted(.dateTime.weekday(.wide)))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
                    .padding(.top, -50)

                TabView(selection: $selectedIndex) {
                    ForEach(dates.indices, id: \.self) { index in
                        DayPlannerPageView(
                            date: dates[index],
                            entries: mealplanEntries,
                            isEditing: $isEditing
                        )
                        .tag(index)
                        .padding(.top, 4)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    // sicherstellen, dass header + pager synchron starten
                    date = dates[safe: selectedIndex] ?? Date()
                }
                .onChange(of: selectedIndex) { _, newValue in
                    // Wenn geswiped wurde -> DatePicker-Header aktualisieren
                    if let newDate = dates[safe: newValue] {
                        date = newDate
                    }
                }
                .onChange(of: date) { _, newValue in
                    // Wenn DatePicker geändert -> Pager auf den passenden Tag springen (wenn im Range)
                    if let idx = indexForDate(newValue) {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            selectedIndex = idx
                        }
                    }
                }
            }
            .toolbar {

                // ✅ Leading: alles in EIN ToolbarItem bündeln
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                jumpToToday()
                            }
                        } label: {
                            Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                                .font(.system(size: 18))
                        }

                        Button {
                            showEntriesSheet = true
                        } label: {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 18))
                        }
                    }
                }

                // ✅ Principal: auf volle Breite zwingen => optisch mittig
                ToolbarItem(placement: .principal) {
                    DayHeaderView(date: $date)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // ✅ Trailing: alles in EIN ToolbarItem bündeln
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            if mealplanEntries.filter({ Calendar.current.isDate($0.day, inSameDayAs: date) }).count > 0 {
                                showAddGroceriesDialog = true
                            }
                        } label: {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 18))
                        }
                        .alert("Are you sure you want to add these groceries?", isPresented: $showAddGroceriesDialog) {
                            Button("Add to Grocery List", role: .confirm) {
                                for entry in mealplanEntries.filter({ Calendar.current.isDate($0.day, inSameDayAs: date) }) {
                                    for groceryItem in entry.recipe!.ingredients! {
                                        addGroceryItem(
                                            GroceryListEntry(
                                                name: groceryItem.name,
                                                unit: groceryItem.unit,
                                                amount: groceryItem.amount,
                                                isChecked: false
                                            )
                                        )
                                    }
                                }
                            }
                            Button("Cancel", role: .cancel) { showAddGroceriesDialog = false }
                        }

                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                isEditing.toggle()
                            }
                        } label: {
                            Image(systemName: isEditing ? "checkmark.circle" : "square.and.pencil.circle")
                                .font(.system(size: 22))
                        }
                    }
                }
            }
            .sheet(isPresented: $showEntriesSheet) {
                MealPlanEntriesView()
            }
        }
    }

    // MARK: - Helpers

    private func jumpToToday() {
        date = Date()
        if let idx = indexForDate(Date()) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                selectedIndex = idx
            }
        }
    }

    private func indexForDate(_ target: Date) -> Int? {
        dates.firstIndex { Calendar.current.isDate($0, inSameDayAs: target) }
    }
}

// MARK: - Safe Indexing

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}


#Preview {
    WeekPlannerView()
}
