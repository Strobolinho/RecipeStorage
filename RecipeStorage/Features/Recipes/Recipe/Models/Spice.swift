//
//  Spices.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation
import SwiftData

@Model
final class Spice {

    var id: UUID = UUID()

    var name: String = ""

    var amount: Double = 0

    var unit: String = ""
    var position: Int?

    var recipe: Recipe?

    init(name: String, amount: Double, unit: String, position: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.unit = unit
        self.position = position
    }
}
