import Foundation
import SwiftData

@Model
final class Recipe {

    var id: UUID = UUID()

    @Attribute(.externalStorage) var imageData: Data?

    var name: String = ""
    var duration: Int = 0
    var categories: Set<String> = []

    // NEU (ab jetzt im UI verwenden)
    var servings: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fats: Double = 0

    var customCalories: Int?

    var calories: Int {
        let value = 4.1 * (protein + carbs) + 9.3 * fats
        return Int(value.rounded())
    }

    @Relationship(deleteRule: .nullify, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]? = []

    @Relationship(deleteRule: .nullify, inverse: \Spice.recipe)
    var spices: [Spice]? = []

    var steps: [String] = []

    @Relationship(deleteRule: .nullify)
    var mealPlanEntries: [MealPlanEntry]? = []

    init(
        imageData: Data? = nil,
        name: String,
        servings: Double,
        duration: Int,
        categories: Set<String>,
        protein: Double,
        carbs: Double,
        fats: Double,
        customCalories: Int?,
        ingredients: [Ingredient],
        spices: [Spice],
        steps: [String]
    ) {
        self.id = UUID()
        self.imageData = imageData
        self.name = name
        self.duration = duration
        self.categories = categories

        self.servings = servings
        self.protein = Double(protein)
        self.carbs = Double(carbs)
        self.fats = Double(fats)

        self.customCalories = customCalories
        self.ingredients = ingredients
        self.spices = spices
        self.steps = steps

        ingredients.forEach { $0.recipe = self }
        spices.forEach { $0.recipe = self }
    }
}
