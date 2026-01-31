//
//  MealPlanEntriesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 25.01.26.
//

import SwiftUI
import SwiftData

struct MealPlanEntriesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealPlanEntry.day) private var entries: [MealPlanEntry]
    
    private var uniqueDays: [Date] {
        let calendar = Calendar.current
        var seen = Set<Date>()

        return entries
            .map { calendar.startOfDay(for: $0.day) }
            .filter { seen.insert($0).inserted }
    }

    
    private func delete_entry(_ entry: MealPlanEntry) {
        modelContext.delete(entry)
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete MealPlanEntry:", error)
        }
    }
    
    
    var body: some View {
        VStack {
            Text("Mealplan Entries")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.brandPrimary)
                .padding()
            
            if !entries.isEmpty {
                Form {
                    ForEach(uniqueDays, id: \.self) { day in
                        Section("\(day.formatted(.dateTime.year().month().day()))") {
                            ForEach(
                                entries
                                    .filter { Calendar.current.isDate($0.day, inSameDayAs: day) }
                                    .sorted { $0.mealType.sortOrder < $1.mealType.sortOrder }
                            ) { entry in
                                HStack {
                                    Text("\(entry.mealType.title)")
                                        .foregroundStyle(entry.mealType.color)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(entry.recipe?.name ?? "—")
                                        .padding(.leading, 3)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete_entry(entry)
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .tint(.brandPrimary)
                    }
                }
            } else {
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 70))
                        .foregroundStyle(.brandPrimary)
                    
                    Text("No Meals added to Calendar")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Add Meals in Weekplanner")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.brandPrimary)
                }
                .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    MealPlanEntriesView()
}
