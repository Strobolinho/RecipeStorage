//
//  StepsListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 31.12.25.
//

import SwiftUI

struct StepsListView: View {
    
    let recipe: Recipe
    
    var body: some View {
        Section("Steps") {
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                HStack {
                    Text("\(index+1)")
                        .foregroundStyle(.brandPrimary)
                        .background {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.brandPrimary)
                                .opacity(0.1)
                        }
                        .padding(.trailing, 8)
                    
                    Text(step)
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}


#Preview {
    StepsListView(recipe: mockRecipes[0])
}
