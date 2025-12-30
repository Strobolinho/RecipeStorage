//
//  MacroCalorieCircleView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct MacroCalorieCircleView: View {
    
    let recipe: Recipe
    
    func calcMacroPercentage(amount: Int, multiplier: Double) -> Double {
        return ((Double(amount) * multiplier) / Double(recipe.calories))
    }
    
    var body: some View {
        
        ZStack {
            RingSegment(
                start: 0.005,
                end: calcMacroPercentage(
                    amount: recipe.protein,
                    multiplier: 4.1) - 0.005,
                color: .protein
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: recipe.protein,
                    multiplier: 4.1) + 0.005,
                end: calcMacroPercentage(
                    amount: recipe.protein + recipe.carbs,
                    multiplier: 4.1) - 0.005,
                color: .carbs
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: recipe.protein + recipe.carbs,
                    multiplier: 4.1) + 0.005,
                end: 0.995,
                color: .fats
            )
            
            VStack {
                if recipe.customCalories > 0 {
                    Text("\(recipe.customCalories)")
                } else {
                    Text("\(recipe.calories)")
                }
                Text("kcal")
            }
        }
        .frame(width: 67)
    }
}

#Preview {
    MacroCalorieCircleView(recipe: mockRecipes[0])
}


struct RingSegment: View {
    
    let start: Double
    let end: Double
    let color: Color
    
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: 5
                )
            )
            .rotationEffect(.degrees(-90))
    }
}
