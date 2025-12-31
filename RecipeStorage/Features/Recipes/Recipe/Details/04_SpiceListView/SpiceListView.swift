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
        Section("Spices") {
            ForEach(recipe.spices) { spice in
                HStack {
                    Text(spice.name)
                    
                    Spacer()
                    
                    Text("\(spice.amount) \(spice.unit)")
                }
            }
        }
    }
}

#Preview {
    SpiceListView(recipe: mockRecipes[0])
}
