//
//  MacroCalorieCircleView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct MacroCalorieCircleView: View {
    
    let protein: Int
    let carbs: Int
    let fats: Int
    let customCalories: Int
    
    var calories: Int {
        Int(
            (Double(protein + carbs) * 4.1) + (Double(fats) * 9.3)
        )
    }
    
    func calcMacroPercentage(amount: Int, multiplier: Double) -> Double {
        return ((Double(amount) * multiplier) / Double(calories))
    }
    
    var body: some View {
        
        ZStack {
            RingSegment(
                start: 0.005,
                end: calcMacroPercentage(
                    amount: protein,
                    multiplier: 4.1) - 0.005,
                color: .protein
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: protein,
                    multiplier: 4.1) + 0.005,
                end: calcMacroPercentage(
                    amount: protein + carbs,
                    multiplier: 4.1) - 0.005,
                color: .carbs
            )
            
            RingSegment(
                start: calcMacroPercentage(
                    amount: protein + carbs,
                    multiplier: 4.1) + 0.005,
                end: 0.995,
                color: .fats
            )
            
            VStack {
                if customCalories > 0 {
                    Text("\(customCalories)")
                } else {
                    Text("\(calories)")
                }
                Text("kcal")
            }
        }
        .frame(width: 67)
    }
}

#Preview {
    MacroCalorieCircleView(
        protein: 148,
        carbs: 188,
        fats: 77,
        customCalories: 0
    )
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
