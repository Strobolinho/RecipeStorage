//
//  RecipesListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.02.26.
//

import SwiftUI
import SwiftData

struct RecipesListView: View {
    
    let recipes: [Recipe]
    
    // Wenn man von WeekPlannerView kommt
    let isAddingToWeekPlanner: Bool
    let date: Date
    let mealType: String
    @Binding var isPresented: Bool
    
    
    let categories: [String]
    
    var body: some View {
        
        ScrollView(.vertical) {
            HorizontalRecipeScrollbarView(
                title: "All Recipes 🍽️",
                recipes: recipes,
                isAddingToWeekPlanner: isAddingToWeekPlanner,
                date: date,
                mealType: mealType,
                isPresented: $isPresented
            )

            ForEach(categories, id: \.self) { category in
                let filtered = recipes.filter { $0.categories.contains(category) }
                
                if !filtered.isEmpty {
                    HorizontalRecipeScrollbarView(
                        title: category,
                        recipes: filtered,
                        isAddingToWeekPlanner: isAddingToWeekPlanner,
                        date: date,
                        mealType: mealType,
                        isPresented: $isPresented
                    )
                }
            }
            
            VStack {}.frame(height: 50)
        }
    }
}

#Preview {
    RecipesListView(recipes: mockRecipes, isAddingToWeekPlanner: false, date: Date(), mealType: "Dinner", isPresented: .constant(false), categories: ["High Protein", "Low Carb", "Low Calories"])
}
