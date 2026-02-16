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
    
    var body: some View {
        
        List {
            Section {
                DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date])

                Picker("Meal Type", selection: $viewModel.mealType) {
                    ForEach(MealType.allCases, id: \.self) { type in
                        Text(type.title).tag(type)
                    }
                }
            }

            Section {
                Button {
                    let entry = MealPlanEntry(day: viewModel.date, mealType: viewModel.mealType, recipe: recipe)
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
        .presentationDetents([.height(230)])
        .scrollDisabled(true)
    }
}

#Preview {
    AddToWeekplannerSheet(viewModel: RecipeViewModel(), recipe: mockRecipes[0])
}
