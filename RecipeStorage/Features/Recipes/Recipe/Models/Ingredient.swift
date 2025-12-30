//
//  Ingredient.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation


struct Ingredient: Identifiable {
    let id = UUID()
    
    let name: String
    let amount: Int
    let unit: String
}
