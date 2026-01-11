//
//  Units.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 10.01.26.
//

import SwiftData

@Model
final class UnitStore {

    // ✅ CloudKit: Default muss am Property stehen (nicht nur im init)
    var ingredientUnits: [String] = ["Custom Unit", "g", "ml", "Stück"]
    var spiceUnits: [String] = ["Custom Unit", "TL", "EL", "Prise"]

    init(
        ingredientUnits: [String] = ["Custom Unit", "g", "ml", "Stück"],
        spiceUnits: [String] = ["Custom Unit", "TL", "EL", "Prise"]
    ) {
        self.ingredientUnits = ingredientUnits
        self.spiceUnits = spiceUnits
    }
}
