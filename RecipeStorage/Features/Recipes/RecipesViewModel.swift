//
//  RecipesViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 04.01.26.
//

import SwiftUI


final class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = mockRecipes
}
