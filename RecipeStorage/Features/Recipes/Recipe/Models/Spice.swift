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
    @Attribute(.unique) var id: UUID
    
    var name: String
    var amount: Int
    var unit: String
    var position: Int?

    init(name: String, amount: Int, unit: String, position: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.unit = unit
        self.position = position
    }
}
