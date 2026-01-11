import Foundation
import SwiftData

@Model
final class Recipe {

    // ✅ CloudKit: .unique wird nicht unterstützt -> entfernen
    // ✅ CloudKit: Default am Property setzen
    var id: UUID = UUID()

    @Attribute(.externalStorage) var imageData: Data?

    // ✅ CloudKit: non-optional braucht Default (auch wenn du es im init setzt)
    var name: String = ""
    var servings: Int = 0
    var duration: Int = 0

    var protein: Int = 0
    var carbs: Int = 0
    var fats: Int = 0

    var calories: Int {
        Int((4.1 * Double(protein + carbs)) + (9.3 * Double(fats)))
    }

    var customCalories: Int?

    // ✅ CloudKit: Relationship muss optional sein
    // ✅ CloudKit: Relationship braucht inverse
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]? = []

    // ✅ CloudKit: Relationship muss optional sein
    // ✅ CloudKit: Relationship braucht inverse
    @Relationship(deleteRule: .cascade, inverse: \Spice.recipe)
    var spices: [Spice]? = []

    // ✅ CloudKit: Default
    var steps: [String] = []

    init(
        imageData: Data? = nil,
        name: String,
        servings: Int,
        duration: Int,
        protein: Int,
        carbs: Int,
        fats: Int,
        customCalories: Int?,
        ingredients: [Ingredient],
        spices: [Spice],
        steps: [String]
    ) {
        // id hat Default, aber du kannst es explizit lassen wenn du willst:
        self.id = UUID()

        self.imageData = imageData
        self.name = name
        self.servings = servings
        self.duration = duration
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.customCalories = customCalories

        // ✅ CloudKit: optional relationship
        self.ingredients = ingredients
        self.spices = spices
        self.steps = steps

        // ✅ CloudKit: inverse sauber setzen (macht es robust)
        ingredients.forEach { $0.recipe = self }
        spices.forEach { $0.recipe = self }
    }
}
