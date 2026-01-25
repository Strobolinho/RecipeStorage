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
    
    private var breakfast: [MealPlanEntry] {entries.filter({ ($0.mealType == .breakfast) && ($0.day.formatted(.dateTime.year().month().day()) == date.formatted(.dateTime.year().month().day())) })}
    
    private var lunch: [MealPlanEntry] {entries.filter({ ($0.mealType == .lunch) && ($0.day.formatted(.dateTime.year().month().day()) == date.formatted(.dateTime.year().month().day())) })}
    
    private var dinner: [MealPlanEntry] {entries.filter({ ($0.mealType == .dinner) && ($0.day.formatted(.dateTime.year().month().day()) == date.formatted(.dateTime.year().month().day())) })}
    
    private var snacks: [MealPlanEntry] {entries.filter({ ($0.mealType == .snacks) && ($0.day.formatted(.dateTime.year().month().day()) == date.formatted(.dateTime.year().month().day())) })}
    

    
    @State private var date: Date = Date()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                HStack {
                    Button {
                        goToPreviousDay()
                    } label: {
                        Image(systemName: "arrowtriangle.left.circle")
                            .font(.system(size: 30))
                    }
                    .padding(.leading, 40)
                    
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .scaleEffect(1.3)
                    
                    Button {
                        goToNextDay()
                    } label: {
                        Image(systemName: "arrowtriangle.right.circle")
                            .font(.system(size: 30))
                    }
                    .padding(.trailing, 40)
                }
                
                MealPlanListView(breakfast: breakfast, lunch: lunch, dinner: dinner, snacks: snacks, date: $date)
            }
        }
    }
    
    private func goToPreviousDay() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        }
    }

    private func goToNextDay() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        }
    }
}

#Preview {
    WeekPlannerView()
}
