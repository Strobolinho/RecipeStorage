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
    
    @State private var showDeleteDialog: Bool = false
    

    private var uniqueDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var seen = Set<Date>()

        return entries
            .map { calendar.startOfDay(for: $0.day) }
            .filter { $0 >= today }
            .filter { seen.insert($0).inserted }
            .sorted()
    }
    
    private var pastDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var seen = Set<Date>()

        return entries
            .map { calendar.startOfDay(for: $0.day) }
            .filter { $0 < today }
            .filter { seen.insert($0).inserted }
            .sorted().reversed()
    }
                                    
    
    var body: some View {
        VStack {
            Text("Mealplan Entries")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.brandPrimary)
                .padding()
            
            if !uniqueDays.isEmpty || !pastDays.isEmpty {
                VStack {
                    Form {
                        EntryListView(days: uniqueDays, entries: entries, isFromPast: false)
                        
                        
                        EntryListView(days: pastDays, entries: entries, isFromPast: true)
                    }
                    
                    
                    Spacer()
                    
                    
                    Button(role: .destructive) {
                        showDeleteDialog = true
                    } label: {
                        HStack {
                            Text("Delete all Entries").fontWeight(.bold)
                            Image(systemName: "trash")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.brandPrimary)
                    }
                    .alert("Delete all Entries?", isPresented: $showDeleteDialog) {
                        Button("Delete All", role: .destructive) {
                            for entry in entries { modelContext.delete(entry) }
                            do { try modelContext.save() } catch { print(error) }
                        }
                        Button("Delete Past Entries", role: .destructive) {
                            for entry in entries.filter({ $0.day < Calendar.current.startOfDay(for: Date()) }) { modelContext.delete(entry) }
                            do { try modelContext.save() } catch { print(error) }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This will remove meal plan entries permanently.")
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
