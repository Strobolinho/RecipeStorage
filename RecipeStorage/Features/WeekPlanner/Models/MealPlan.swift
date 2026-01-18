//
//  MealPlan.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 18.01.26.
//

import Foundation
import SwiftData


enum MealType: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack

    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch:     return "Lunch"
        case .dinner:    return "Dinner"
        case .snack:     return "Snack"
        }
    }
}


@Model
final class MealPlanEntry {

    var id: UUID = UUID()

    /// Am besten immer "Start of day" speichern (00:00), damit du sauber nach Tagen filtern kannst
    var day: Date = Date()

    var mealType: MealType = MealType.lunch
    
    @Relationship(deleteRule: .nullify, inverse: \Recipe.mealPlanEntries)
    var recipe: Recipe? = nil

    init(day: Date, mealType: MealType, recipe: Recipe? = nil) {
        self.id = UUID()

        self.day = Calendar.current.startOfDay(for: day)
        self.mealType = mealType
        self.recipe = recipe
    }
    
    
}
