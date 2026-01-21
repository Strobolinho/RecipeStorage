//
//  MealPlanList.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 19.01.26.
//

import SwiftUI

struct MealPlanListView: View {
    
    let breakfast: [MealPlanEntry]
    let lunch: [MealPlanEntry]
    let dinner: [MealPlanEntry]
    let snacks: [MealPlanEntry]
    
    var body: some View {
        
        VStack(spacing: 20) {
            MealPlanListSection(entries: breakfast, mealType: "Breakfast")
            
            MealPlanListSection(entries: lunch, mealType: "Lunch")
            
            MealPlanListSection(entries: dinner, mealType: "Dinner")
            
            MealPlanListSection(entries: snacks, mealType: "Snacks")
        }
        
    }
}

#Preview {
    MealPlanListView(
        breakfast: [], lunch: [], dinner: [], snacks: []
    )
}
