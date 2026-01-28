//
//  DayPlannerPageView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.01.26.
//

import SwiftUI

struct DayPlannerPageView: View {

    let date: Date
    let entries: [MealPlanEntry]
    @Binding var isEditing: Bool

    private var breakfast: [MealPlanEntry] {
        entries.filter { $0.mealType == .breakfast && Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    private var lunch: [MealPlanEntry] {
        entries.filter { $0.mealType == .lunch && Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    private var dinner: [MealPlanEntry] {
        entries.filter { $0.mealType == .dinner && Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    private var snacks: [MealPlanEntry] {
        entries.filter { $0.mealType == .snacks && Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    var body: some View {
        MealPlanListView(
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner,
            snacks: snacks,
            // MealPlanListView erwartet bei dir ein Binding<Date>.
            // Hier bleibt das Datum fix pro Page:
            date: .constant(date),
            isEditing: $isEditing
        )
    }
}

#Preview {
    DayPlannerPageView(date: .now, entries: [], isEditing: .constant(false))
}
