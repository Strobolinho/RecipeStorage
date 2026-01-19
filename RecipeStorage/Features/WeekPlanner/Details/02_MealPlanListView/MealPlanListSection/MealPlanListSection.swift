//
//  MealPlanListSection.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 19.01.26.
//

import SwiftUI


struct MealPlanListSection: View {
    
    let entries: [MealPlanEntry]
    let mealType: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(mealType)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.brandPrimary)
            
            if !entries.isEmpty {
                MealPlanRecipeCardView(imageData: entries[0].recipe!.imageData, recipe: entries[0].recipe!)
            } else {
                Text("No Recipes stored yet...")
                    .font(.subheadline)
                    .foregroundStyle(.recipeTitle)
                    .padding(.top, 5)
            }
        }
        .frame(maxWidth: 350, alignment: .leading)
        .padding(.bottom, 20)
        
    }
}

#Preview {
    MealPlanListSection(entries: [MealPlanEntry(day: Date(), mealType: .dinner, recipe: mockRecipes[0])], mealType: "Breakfast")
}
