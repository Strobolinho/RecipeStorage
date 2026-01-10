//
//  SpiceListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 31.12.25.
//

import SwiftUI

struct SpiceListView: View {
    
    let recipe: Recipe
    
    var body: some View {
        if !recipe.spices.isEmpty {
            Section("Spices") {
                ForEach(recipe.spices.sorted { ($0.position ?? 0) < ($1.position ?? 0) }) { spice in
                    HStack {
                        Text(spice.name)
                        
                        Spacer()
                        
                        Text("\(spice.amount) \(spice.unit)")
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        SpiceListView(recipe: mockRecipes[0])
    }
}
