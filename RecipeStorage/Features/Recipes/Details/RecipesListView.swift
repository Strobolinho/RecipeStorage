//
//  RecipesListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.02.26.
//

import SwiftUI
import SwiftData

struct RecipesListView: View {
    
    let recipes: [Recipe]
    
    // Wenn man von WeekPlannerView kommt
    let isAddingToWeekPlanner: Bool
    let date: Date
    let mealType: String
    @Binding var isPresented: Bool
    
    @State private var searchText: String = ""
    
    let categories: [String]
    
    var body: some View {
        
        VStack {
            TextField("Search for Recipes...", text: $searchText)
                .padding()
                .padding(.horizontal)
                .foregroundStyle(.brandPrimary)
                .font(.title2)
                .fontWeight(.semibold)
                .background {
                    RoundedRectangle(cornerRadius: 999)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                        .padding(.horizontal)
                }
            
            ScrollView(.vertical) {
                let filteredAll = searchText != "" ? recipes.filter( { $0.name.lowercased().contains(searchText.lowercased()) } ) : recipes
                
                HorizontalRecipeScrollbarView(
                    title: "All Recipes 🍽️",
                    recipes: filteredAll,
                    isAddingToWeekPlanner: isAddingToWeekPlanner,
                    date: date,
                    mealType: mealType,
                    isPresented: $isPresented
                )
                
                ForEach(categories, id: \.self) { category in
                    let filteredCategorized = searchText != "" ? recipes.filter( { $0.categories.contains(category) && $0.name.lowercased().contains(searchText.lowercased()) } ) : recipes.filter( { $0.categories.contains(category) } )
                    
                    if !filteredCategorized.isEmpty {
                        HorizontalRecipeScrollbarView(
                            title: category,
                            recipes: filteredCategorized,
                            isAddingToWeekPlanner: isAddingToWeekPlanner,
                            date: date,
                            mealType: mealType,
                            isPresented: $isPresented
                        )
                    }
                }
                
                VStack {}.frame(height: 50)
            }
        }
    }
}

#Preview {
    RecipesListView(recipes: mockRecipes, isAddingToWeekPlanner: false, date: Date(), mealType: "Dinner", isPresented: .constant(false), categories: ["High Protein", "Low Carb", "Low Calories"])
}
