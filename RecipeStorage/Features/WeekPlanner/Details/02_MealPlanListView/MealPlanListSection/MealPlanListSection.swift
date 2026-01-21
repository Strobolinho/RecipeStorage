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
                NavigationLink {
                    RecipeView(recipe: entries[0].recipe!)
                } label: {
                    MealPlanRecipeCardView(imageData: entries[0].recipe!.imageData, recipe: entries[0].recipe!)
                }
            } else {
                EmptyRecipeCardView()
            }
        }
        .frame(maxWidth: 350, alignment: .leading)
        
    }
}

#Preview {
    MealPlanListSection(entries: [MealPlanEntry(day: Date(), mealType: .dinner, recipe: mockRecipes[0])], mealType: "Breakfast")
}
