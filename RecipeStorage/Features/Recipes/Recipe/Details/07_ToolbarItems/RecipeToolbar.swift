//
//  RecipeToolbar.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI

struct RecipeToolbar: ToolbarContent {
    
    @ObservedObject var viewModel: RecipeViewModel
    let recipe: Recipe
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.showAddGroceriesDialog = true
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18))
            }
            
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.date = Date()
                viewModel.mealType = .dinner
                viewModel.showAddToWeekPlannerSheet = true
            } label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 17))
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                NewRecipeView(recipeToEdit: recipe)
            } label: {
                Image(systemName: "square.and.pencil.circle")
                    .font(.system(size: 22))
            }
        }
    }
}
