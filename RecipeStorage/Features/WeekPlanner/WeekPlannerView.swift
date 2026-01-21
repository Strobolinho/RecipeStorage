//
//  WeekPlannerView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct WeekPlannerView: View {

    @StateObject private var viewModel = CalendarScrollViewModel()
    
    private let entry1: MealPlanEntry = MealPlanEntry(day: Date(), mealType: .snacks, recipe: mockRecipes[0])
    private let entry2: MealPlanEntry = MealPlanEntry(day: Date(), mealType: .dinner, recipe: mockRecipes[1])
    private let entry3: MealPlanEntry = MealPlanEntry(day: Date(), mealType: .breakfast, recipe: mockRecipes[2])
    private let entry4: MealPlanEntry = MealPlanEntry(day: Date(), mealType: .snacks, recipe: mockRecipes[3])
    
    private var entries: [MealPlanEntry] {
        [entry1, entry2, entry3, entry4]
    }
    
    private var breakfast: [MealPlanEntry] {entries.filter({ $0.mealType == .breakfast })}
    private var lunch: [MealPlanEntry] {entries.filter({ $0.mealType == .lunch })}
    private var dinner: [MealPlanEntry] {entries.filter({ $0.mealType == .dinner })}
    private var snacks: [MealPlanEntry] {entries.filter({ $0.mealType == .snacks })}

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 30) {
                    CalendarScrollView(viewModel: viewModel, width: geo.size.width)
                    
                    MealPlanListView(breakfast: breakfast, lunch: lunch, dinner: dinner, snacks: snacks)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WeekPlannerView()
}
