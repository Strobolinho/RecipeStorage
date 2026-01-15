//
//  IngredientStore.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.01.26.
//

import Foundation


@MainActor
final class IngredientStore: ObservableObject {
    @Published var ingredientNames: [String] = []
}
