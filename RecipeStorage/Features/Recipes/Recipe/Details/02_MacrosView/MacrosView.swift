//
//  MacrosView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI


struct MacrosView: View {
    var body: some View {
        Section("Macros") {
            HStack {
                MacroCalorieCircleView(
                    protein: 148,
                    carbs: 188,
                    fats: 77,
                    customCalories: 0
                )
                
                Spacer()
                
                MacroDetailView(macroName: "Protein", macroAmount: 78, color: .protein)
                
                Spacer()
                
                MacroDetailView(macroName: "Carbs", macroAmount: 150, color: .carbs)
                
                Spacer()
                
                MacroDetailView(macroName: "Fats", macroAmount: 45, color: .fats)
            }
        }
    }
}

#Preview {
    MacrosView()
}
