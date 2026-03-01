//
//  MacrosView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI


struct MacrosView: View {
    
    let recipe: Recipe
    let multiplier: Double
    
    var body: some View {
        Section("Macros") {
            HStack {
                MacroCalorieCircleView(recipe: recipe, multiplier: multiplier)
                
                Spacer()
                
                MacroDetailView(macroName: "Protein", macroAmount: recipe.protein, color: .protein, multiplier: multiplier)
                
                Spacer()
                
                MacroDetailView(macroName: "Carbs", macroAmount: recipe.carbs, color: .carbs, multiplier: multiplier)
                
                Spacer()
                
                MacroDetailView(macroName: "Fats", macroAmount: recipe.fats, color: .fats, multiplier: multiplier)
            }
        }
    }
}

#Preview {
    MacrosView(recipe: mockRecipes[0], multiplier: 1.0)
}
