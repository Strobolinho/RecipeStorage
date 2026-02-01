//
//  MealPlan.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 18.01.26.
//

import Foundation
import SwiftData
import SwiftUI


enum MealType: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snacks

    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch:     return "Lunch"
        case .dinner:    return "Dinner"
        case .snacks:     return "Snacks"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .breakfast: return 0
        case .lunch: return 1
        case .dinner: return 2
        case .snacks: return 3
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return Color.breakfast
        case .lunch: return Color.lunch
        case .dinner: return Color.dinner
        case .snacks: return Color.snacks
        }
    }
}


@Model
final class MealPlanEntry {

    var id: UUID = UUID()

    /// Am besten immer "Start of day" speichern (00:00), damit man sauber nach Tagen filtern kann
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
