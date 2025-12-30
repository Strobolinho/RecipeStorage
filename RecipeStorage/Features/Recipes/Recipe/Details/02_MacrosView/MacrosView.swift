//
//  MacrosView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI


struct MacrosView: View {
    
    let recipe: Recipe
    
    var body: some View {
        Section("Macros") {
            HStack {
                MacroCalorieCircleView(recipe: recipe)
                
                Spacer()
                
                MacroDetailView(macroName: "Protein", macroAmount: recipe.protein, color: .protein)
                
                Spacer()
                
                MacroDetailView(macroName: "Carbs", macroAmount: recipe.carbs, color: .carbs)
                
                Spacer()
                
                MacroDetailView(macroName: "Fats", macroAmount: recipe.fats, color: .fats)
            }
        }
    }
}

#Preview {
    MacrosView(recipe: mockRecipes[0])
}
