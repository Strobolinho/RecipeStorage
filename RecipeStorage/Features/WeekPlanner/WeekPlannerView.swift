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
    @Query(sort: \MealPlanEntry.day) private var entries: [MealPlanEntry]

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
                            entries: entries,
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            isEditing.toggle()
                        }
                    } label: {
                        Image(systemName: isEditing ? "checkmark.circle" : "square.and.pencil.circle")
                            .font(.system(size: 22))
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                jumpToToday()
                            }
                        } label: {
                            Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                                .font(.system(size: 22))
                        }
                        
                        Button {
                            showEntriesSheet = true
                        } label: {
                            Image(systemName: "calendar.circle")
                                .font(.system(size: 22))
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    DayHeaderView(date: $date)
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
