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
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                MealPlanListSection(entries: breakfast, mealType: "Breakfast", isEditing: isEditing)
                MealPlanListSection(entries: lunch, mealType: "Lunch", isEditing: isEditing)
                MealPlanListSection(entries: dinner, mealType: "Dinner", isEditing: isEditing)
                MealPlanListSection(entries: snacks, mealType: "Snacks", isEditing: isEditing)
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
        }
    }
}

#Preview {
    MealPlanListView(
        breakfast: [], lunch: [], dinner: [], snacks: []
    )
}
