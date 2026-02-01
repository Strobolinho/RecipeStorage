//
//  EntryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.02.26.
//

import SwiftUI

struct EntryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    let days: [Date]
    let entries: [MealPlanEntry]
    let isFromPast: Bool
    
    
    private func delete_entry(_ entry: MealPlanEntry) {
        modelContext.delete(entry)
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete MealPlanEntry:", error)
        }
    }
    
    
    var body: some View {
        
        ForEach(days, id: \.self) { day in
            Section(day.formatted(.dateTime.weekday().year().month().day())) {
                let dayEntries = entries
                    .filter { Calendar.current.isDate($0.day, inSameDayAs: day) }
                    .sorted { $0.mealType.sortOrder < $1.mealType.sortOrder }

                ForEach(dayEntries) { entry in
                    HStack {
                        Text(entry.mealType.title)
                            .foregroundStyle(entry.mealType.color)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(entry.recipe?.name ?? "—")
                            .padding(.leading, 3)
                    }
                    .opacity(isFromPast ? 0.5 : 1)
                    .blur(radius: isFromPast ? 1 : 0)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) { delete_entry(entry) } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
            }
            .tint(.brandPrimary)
        }
    }
}

#Preview {
    EntryListView(days: [], entries: [], isFromPast: false)
}
