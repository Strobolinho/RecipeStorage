//
//  HorizontalRecipeScrollbar.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import SwiftUI
import SwiftData

struct HorizontalRecipeScrollbarView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var viewModel: RecipesViewModel
    
    let title: String
    let recipes: [Recipe]
    let isAddingToWeekPlanner: Bool
    let date: Date
    let mealType: String
    @Binding var isPresented: Bool

    
    var body: some View {
        if !recipes.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(recipes.sorted { $0.name < $1.name }) { recipe in
                            if !isAddingToWeekPlanner {
                                NavigationLink {
                                    RecipeView(recipe: recipe, multiplier: 1.0)
                                } label: {
                                    RecipeCardView(recipe: recipe)
                                }
                            } else {
                                Button {
                                    viewModel.multiplier = recipe.servings
                                    viewModel.selectedRecipeForWeekPlanner = recipe
                                } label: {
                                    RecipeCardView(recipe: recipe)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 220)
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    HorizontalRecipeScrollbarView(
        viewModel: RecipesViewModel(),
        title: "Alle Rezepte",
        recipes: mockRecipes,
        isAddingToWeekPlanner: false,
        date: Date(),
        mealType: "Dinner",
        isPresented: .constant(false)
    )
}
