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

    var body: some View {
        NavigationStack {
            ZStack {
                if !recipes.isEmpty {
                    RecipesListView(
                        recipes: recipes,
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
