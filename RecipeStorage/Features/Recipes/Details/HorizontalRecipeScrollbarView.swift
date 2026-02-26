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
                                    RecipeView(recipe: recipe)
                                } label: {
                                    RecipeCardView(recipe: recipe)
                                }
                            } else {
                                Button {
                                    addRecipeToEntries(recipe: recipe, date: date, mealType: mealType)
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
    
    private func addRecipeToEntries(recipe: Recipe, date: Date, mealType: String, multiplier: Double = 1.0) {
        
        var ingredientsEdited: [Ingredient] = []
        var spicesEdited: [Spice] = []
        
        for ing in recipe.ingredients! {
            ingredientsEdited.append(
                Ingredient(name: ing.name, amount: ing.amount * multiplier, unit: ing.unit, position: ing.position)
            )
        }
        
        if let spices = recipe.spices {
            for spi in spices {
                spicesEdited.append(
                    Spice(name: spi.name, amount: spi.amount * multiplier, unit: spi.unit, position: spi.position)
                )
            }
        }
        
        let recipeEdited = Recipe(imageData: recipe.imageData, name: recipe.name, servings: recipe.servings * multiplier, duration: recipe.duration, categories: recipe.categories, protein: recipe.protein * multiplier, carbs: recipe.carbs * multiplier, fats: recipe.fats * multiplier, customCalories: recipe.customCalories, ingredients: ingredientsEdited, spices: spicesEdited, steps: recipe.steps)
        
        let entry = MealPlanEntry(day: date, mealType: MealType(rawValue: mealType.lowercased())!, recipe: recipeEdited)
        
        modelContext.insert(entry)
        try? modelContext.save()
        
        isPresented = false
    }
}

#Preview {
    HorizontalRecipeScrollbarView(
        title: "Alle Rezepte",
        recipes: mockRecipes,
        isAddingToWeekPlanner: false,
        date: Date(),
        mealType: "Dinner",
        isPresented: .constant(false)
    )
}
