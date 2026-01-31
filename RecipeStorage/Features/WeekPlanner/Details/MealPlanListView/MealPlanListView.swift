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
    
    @Binding var date: Date
    
    @Binding var isEditing: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                MealPlanListSection(entries: breakfast, mealType: "breakfast", isEditing: isEditing, date: $date)
                MealPlanListSection(entries: lunch, mealType: "lunch", isEditing: isEditing, date: $date)
                MealPlanListSection(entries: dinner, mealType: "dinner", isEditing: isEditing, date: $date)
                MealPlanListSection(entries: snacks, mealType: "snacks", isEditing: isEditing, date: $date)
            }
        }
    }
}

#Preview {
    MealPlanListView(
        breakfast: [], lunch: [], dinner: [], snacks: [], date: .constant(Date()),
        isEditing: .constant(false)
    )
}
