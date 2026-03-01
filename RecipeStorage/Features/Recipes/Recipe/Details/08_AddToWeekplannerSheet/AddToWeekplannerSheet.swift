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
                        Text("Servings")
                        Spacer()
                        Text(viewModel.portions.formatted(.number.precision(.fractionLength(0...2))))
                            .foregroundStyle(.secondary)
                    }
                }

                if showMultiplierPicker {
                    TwoDecimalPicker(value: $viewModel.portions, intRange: 0...(Int(recipe.servings) * 5))
                        .frame(height: 180)
                }
            }

            Section {
                Button {
                    
                    let multiplier: Double = viewModel.portions / recipe.servings
                    
                    let entry = MealPlanEntry(day: viewModel.date, mealType: viewModel.mealType, recipe: recipe, multiplier: multiplier)
                    
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
        .onAppear {
            viewModel.portions = recipe.servings
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
