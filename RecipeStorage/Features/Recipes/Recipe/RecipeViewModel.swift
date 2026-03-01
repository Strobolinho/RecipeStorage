//
//  RecipeViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.01.26.
//

import Foundation


@MainActor
final class RecipeViewModel: ObservableObject {
    
    @Published var showDeleteDialog = false
    
    @Published var showAddGroceriesDialog = false
    
    @Published var showAddToWeekPlannerSheet: Bool = false
    
    @Published var date: Date = Date()
    
    @Published var mealType: MealType = .dinner
    
    @Published var portions: Double = 1.0
}
