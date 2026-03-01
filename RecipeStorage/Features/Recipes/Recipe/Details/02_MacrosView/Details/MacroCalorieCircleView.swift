//
//  MacroCalorieCircleView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct MacroCalorieCircleView: View {
    
    let recipe: Recipe
    let multiplier: Double
    
    func calcMacroPercentage(amount: Double, multiplierMacro: Double) -> Double {
        return ((amount * multiplierMacro) / Double(recipe.calories))
    }
    
    var body: some View {
        
        ZStack {
            RingSegment(
                start: 0.005,
                end: calcMacroPercentage(
                    amount: recipe.protein,
                    multiplierMacro: 4.1) - 0.005,
                color: .protein
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: recipe.protein,
                    multiplierMacro: 4.1) + 0.005,
                end: calcMacroPercentage(
                    amount: recipe.protein + recipe.carbs,
                    multiplierMacro: 4.1) - 0.005,
                color: .carbs
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: recipe.protein + recipe.carbs,
                    multiplierMacro: 4.1) + 0.005,
                end: 0.995,
                color: .fats
            )
            
            VStack {
                Text("\(Int(Double(recipe.customCalories ?? recipe.calories) * multiplier))")
                Text("kcal")
            }
        }
        .frame(width: 67)
    }
}

#Preview {
    MacroCalorieCircleView(recipe: mockRecipes[0], multiplier: 1.0)
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
