//
//  RecipesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct RecipesView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]

    @StateObject private var viewModel = RecipesViewModel()

    // Wenn man von WeekPlannerView kommt
    let isAddingToWeekPlanner: Bool
    let date: Date
    let mealType: String
    @Binding var isPresented: Bool

    init(
        isAddingToWeekPlanner: Bool = false,
        date: Date = Date(),
        mealType: String = "Dinner",
        isPresented: Binding<Bool> = .constant(false)
    ) {
        self.isAddingToWeekPlanner = isAddingToWeekPlanner
        self.date = date
        self.mealType = mealType
        self._isPresented = isPresented
    }
    
    private func addRecipeToEntries(recipe: Recipe, date: Date, mealType: String, multiplier: Double = 1.0) {
        
        let entry = MealPlanEntry(day: date, mealType: MealType(rawValue: mealType.lowercased())!, recipe: recipe, multiplier: (multiplier / recipe.servings))
        
        modelContext.insert(entry)
        try? modelContext.save()
        
        isPresented = false
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if !recipes.isEmpty {
                    RecipesListView(
                        recipes: recipes,
                        viewModel: viewModel,
                        isAddingToWeekPlanner: isAddingToWeekPlanner,
                        date: date,
                        mealType: mealType,
                        isPresented: $isPresented,
                        categories: viewModel.categories
                    )
                } else {
                    EmptyRecipesScreenView()
                        .padding()
                }

                if !isAddingToWeekPlanner {
                    NewRecipeButtonView()
                }
            }
            .sheet(item: $viewModel.selectedRecipeForWeekPlanner) { recipe in
                List {
                    Section("Servings") {
                        TwoDecimalPicker(
                            value: $viewModel.multiplier,
                            intRange: 0...Int(recipe.servings * 5)
                        )
                    }

                    Section {
                        Button {
                            addRecipeToEntries(recipe: recipe, date: date, mealType: mealType, multiplier: viewModel.multiplier)
                            
                            viewModel.selectedRecipeForWeekPlanner = nil
                        } label: {
                            Text("Add to Week Planner")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fontWeight(.bold)
                        }
                    }
                }
                .scrollDisabled(true)
                .presentationDetents([.height(360)])
            }
        }
        .task {
            viewModel.onAppear(using: modelContext)
        }
        .toolbar(isAddingToWeekPlanner ? .hidden : .visible, for: .tabBar)
    }
}

#Preview {
    RecipesView()
}
