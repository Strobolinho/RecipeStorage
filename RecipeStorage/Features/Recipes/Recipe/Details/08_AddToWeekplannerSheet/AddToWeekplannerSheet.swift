//
//  AddToWeekplannerSheet.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI

struct AddToWeekplannerSheet: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var viewModel: RecipeViewModel
    
    let recipe: Recipe
    
    @State private var showMultiplierPicker = false
    
    @State private var selectedDetent: PresentationDetent = .height(280)
    
    var body: some View {
        
        List {
            Section {
                DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date])

                Picker("Meal Type", selection: $viewModel.mealType) {
                    ForEach(MealType.allCases, id: \.self) { type in
                        Text(type.title).tag(type)
                    }
                }
                
                Button {
                    withAnimation {
                        showMultiplierPicker.toggle()
                        selectedDetent = showMultiplierPicker ? .height(500) : .height(280)
                    }
                } label: {
                    HStack {
                        Text("Multiplier")
                        Spacer()
                        Text(viewModel.multiplier.formatted(.number.precision(.fractionLength(0...2))))
                            .foregroundStyle(.secondary)
                    }
                }

                if showMultiplierPicker {
                    TwoDecimalPicker(value: $viewModel.multiplier, intRange: 0...5)
                        .frame(height: 180)
                }
            }

            Section {
                Button {
                    var ingredientsEdited: [Ingredient] = []
                    var spicesEdited: [Spice] = []
                    
                    for ing in recipe.ingredients! {
                        ingredientsEdited.append(
                            Ingredient(name: ing.name, amount: ing.amount * viewModel.multiplier, unit: ing.unit, position: ing.position)
                        )
                    }
                    
                    if let spices = recipe.spices {
                        for spi in spices {
                            spicesEdited.append(
                                Spice(name: spi.name, amount: spi.amount * viewModel.multiplier, unit: spi.unit, position: spi.position)
                            )
                        }
                    }
                    
                    let recipeEdited = Recipe(imageData: recipe.imageData, name: recipe.name, servings: recipe.servings * viewModel.multiplier, duration: recipe.duration, categories: recipe.categories, protein: recipe.protein * viewModel.multiplier, carbs: recipe.carbs * viewModel.multiplier, fats: recipe.fats * viewModel.multiplier, customCalories: recipe.customCalories, ingredients: ingredientsEdited, spices: spicesEdited, steps: recipe.steps)
                    
                    let entry = MealPlanEntry(day: viewModel.date, mealType: viewModel.mealType, recipe: recipeEdited)
                    
                    modelContext.insert(entry)
                    try? modelContext.save()
                    
                    viewModel.showAddToWeekPlannerSheet = false
                    
                } label: {
                    Text("Add to Week Planner")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(.bold)
                }
            }
        }
        .presentationDetents(
            [.height(280), .height(500)],
            selection: $selectedDetent
        )
        .scrollDisabled(true)
    }
}

#Preview {
    AddToWeekplannerSheet(viewModel: RecipeViewModel(), recipe: mockRecipes[0])
}
