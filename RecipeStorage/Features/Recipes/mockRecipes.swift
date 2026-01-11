import SwiftUI

var mockRecipes: [Recipe] = [

    Recipe(
        imageData: UIImage(named: "lasagna")?.jpegData(compressionQuality: 0.8),
        name: "Lasagne",
        servings: 4,
        duration: 60,
        categories: ["High Protein"],
        protein: 152,
        carbs: 248,
        fats: 136,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Lasagneplatten", amount: 300, unit: "g", position: 0),
            Ingredient(name: "Rinderhackfleisch", amount: 600, unit: "g", position: 1),
            Ingredient(name: "Tomatensauce", amount: 700, unit: "ml", position: 2),
            Ingredient(name: "Mozzarella", amount: 250, unit: "g", position: 3),
            Ingredient(name: "Olivenöl", amount: 2, unit: "tbsp", position: 4)
        ],
        spices: [
            Spice(name: "Salz", amount: 2, unit: "tsp", position: 0),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp", position: 1),
            Spice(name: "Oregano", amount: 2, unit: "tsp", position: 2),
            Spice(name: "Muskat", amount: 1, unit: "pinch", position: 3)
        ],
        steps: [
            "Backofen auf 180°C Ober-/Unterhitze vorheizen.",
            "Hackfleisch in einer Pfanne anbraten und würzen.",
            "Lasagneplatten, Sauce und Fleisch schichten.",
            "Mit Käse bestreuen und im Ofen goldbraun backen."
        ]
    ),

    Recipe(
        imageData: UIImage(named: "smashBurger")?.jpegData(compressionQuality: 0.8),
        name: "Smash Burger",
        servings: 2,
        duration: 25,
        categories: [],
        protein: 90,
        carbs: 66,
        fats: 84,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Rinderhackfleisch (20 % Fett)", amount: 400, unit: "g", position: 0),
            Ingredient(name: "Burger Buns", amount: 2, unit: "pcs", position: 1),
            Ingredient(name: "Cheddar Käse", amount: 4, unit: "pcs", position: 2),
            Ingredient(name: "Butter", amount: 1, unit: "tbsp", position: 3)
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp", position: 0),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp", position: 1)
        ],
        steps: [
            "Pfanne sehr stark erhitzen.",
            "Hackfleisch zu Kugeln formen und in der Pfanne smashen.",
            "Wenden, würzen und Käse darauf schmelzen lassen.",
            "Burger zusammenbauen und servieren."
        ]
    ),

    Recipe(
        imageData: UIImage(named: "flammkuchenBaguettes")?.jpegData(compressionQuality: 0.8),
        name: "Flammkuchen-Baguettes",
        servings: 2,
        duration: 20,
        categories: [],
        protein: 56,
        carbs: 110,
        fats: 60,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Baguette", amount: 1, unit: "pcs", position: 0),
            Ingredient(name: "Crème fraîche", amount: 200, unit: "g", position: 1),
            Ingredient(name: "Speckwürfel", amount: 150, unit: "g", position: 2),
            Ingredient(name: "Zwiebel", amount: 1, unit: "pcs", position: 3)
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp", position: 0),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp", position: 1),
            Spice(name: "Muskat", amount: 1, unit: "pinch", position: 2)
        ],
        steps: [
            "Baguette längs halbieren.",
            "Crème fraîche gleichmäßig verstreichen.",
            "Mit Speckwürfeln und Zwiebeln belegen.",
            "Im Ofen knusprig backen."
        ]
    ),

    Recipe(
        imageData: UIImage(named: "chickenTeriyaki")?.jpegData(compressionQuality: 0.8),
        name: "Hähnchen Teriyaki mit Reis",
        servings: 3,
        duration: 35,
        categories: [],
        protein: 138,
        carbs: 210,
        fats: 36,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Hähnchenbrust", amount: 600, unit: "g", position: 0),
            Ingredient(name: "Basmatireis", amount: 300, unit: "g", position: 1),
            Ingredient(name: "Teriyaki Sauce", amount: 150, unit: "ml", position: 2),
            Ingredient(name: "Sesamöl", amount: 1, unit: "tbsp", position: 3)
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp", position: 0),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp", position: 1),
            Spice(name: "Knoblauchpulver", amount: 1, unit: "tsp", position: 2)
        ],
        steps: [
            "Reis nach Packungsanleitung kochen.",
            "Hähnchen in Stücke schneiden und anbraten.",
            "Mit Teriyaki Sauce ablöschen und köcheln lassen.",
            "Mit Reis servieren."
        ]
    ),

    Recipe(
        imageData: UIImage(named: "carbonara")?.jpegData(compressionQuality: 0.8),
        name: "Pasta Carbonara",
        servings: 4,
        duration: 25,
        categories: [],
        protein: 124,
        carbs: 360,
        fats: 148,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Spaghetti", amount: 400, unit: "g", position: 0),
            Ingredient(name: "Guanciale", amount: 200, unit: "g", position: 1),
            Ingredient(name: "Eier", amount: 4, unit: "pcs", position: 2),
            Ingredient(name: "Parmesan", amount: 120, unit: "g", position: 3)
        ],
        spices: [
            Spice(name: "Pfeffer", amount: 2, unit: "tsp", position: 0),
            Spice(name: "Salz", amount: 1, unit: "tsp", position: 1)
        ],
        steps: [
            "Spaghetti in Salzwasser kochen.",
            "Guanciale knusprig anbraten.",
            "Eier mit Parmesan verrühren.",
            "Pasta mit Guanciale mischen und Eiermasse unterziehen."
        ]
    ),

    Recipe(
        imageData: UIImage(named: "salmonPotatoes")?.jpegData(compressionQuality: 0.8),
        name: "Lachs mit Ofenkartoffeln",
        servings: 2,
        duration: 40,
        categories: [],
        protein: 88,
        carbs: 120,
        fats: 72,
        customCalories: nil,
        ingredients: [
            Ingredient(name: "Lachsfilet", amount: 400, unit: "g", position: 0),
            Ingredient(name: "Kartoffeln", amount: 600, unit: "g", position: 1),
            Ingredient(name: "Olivenöl", amount: 3, unit: "tbsp", position: 2),
            Ingredient(name: "Zitrone", amount: 1, unit: "pcs", position: 3)
        ],
        spices: [
            Spice(name: "Salz", amount: 2, unit: "tsp", position: 0),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp", position: 1),
            Spice(name: "Paprikapulver", amount: 1, unit: "tsp", position: 2)
        ],
        steps: [
            "Backofen auf 200°C vorheizen.",
            "Kartoffeln schneiden und mit Öl und Gewürzen mischen.",
            "Lachs würzen und auf das Blech legen.",
            "Alles im Ofen goldbraun backen."
        ]
    )
]
