//
//  Units.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 10.01.26.
//

import SwiftData


@Model
final class UnitStore {
    var ingredientUnits: [String]
    var spiceUnits: [String]
    
    init(
        ingredientUnits: [String] = ["Custom Unit", "g", "ml", "Stück"],
        spiceUnits: [String] = ["Custom Unit", "TL", "EL", "Prise"]
    ) {
        self.ingredientUnits = ingredientUnits
        self.spiceUnits = spiceUnits
    }
}
