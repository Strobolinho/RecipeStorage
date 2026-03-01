//
//  SpiceListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 31.12.25.
//

import SwiftUI

struct SpiceListView: View {
    
    let recipe: Recipe
    let multiplier: Double
    
    var body: some View {
        
        let spices = (recipe.spices ?? []).sorted { ($0.position ?? 0) < ($1.position ?? 0) }
        
        if !spices.isEmpty {
            Section("Spices") {
                ForEach(spices) { spice in
                    HStack {
                        Text(spice.name)
                        
                        Spacer()
                        
                        Text("\((spice.amount * multiplier).formatted(.number.precision(.fractionLength(0...1)))) \(spice.unit)")
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        SpiceListView(recipe: mockRecipes[0], multiplier: 1.0)
    }
}
