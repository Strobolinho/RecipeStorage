//
//  mockRecipes.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import Foundation


let mockRecipes: [Recipe] = [

    Recipe(
        name: "Lasagne",
        imageName: "lasagna",
        servings: 4,
        duration: 60,
        protein: 152,
        carbs: 248,
        fats: 136,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Lasagneplatten", amount: 300, unit: "g"),
            Ingredient(name: "Rinderhackfleisch", amount: 600, unit: "g"),
            Ingredient(name: "Tomatensauce", amount: 700, unit: "ml"),
            Ingredient(name: "Mozzarella", amount: 250, unit: "g"),
            Ingredient(name: "Olivenöl", amount: 2, unit: "tbsp")
        ],
        spices: [
            Spice(name: "Salz", amount: 2, unit: "tsp"),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp"),
            Spice(name: "Oregano", amount: 2, unit: "tsp"),
            Spice(name: "Muskat", amount: 1, unit: "pinch")
        ],
        steps: [
            "Backofen auf 180°C Ober-/Unterhitze vorheizen.",
            "Hackfleisch in einer Pfanne anbraten und würzen.",
            "Lasagneplatten, Sauce und Fleisch schichten.",
            "Mit Käse bestreuen und im Ofen goldbraun backen."
        ]
    ),

    Recipe(
        name: "Smash Burger",
        imageName: "smashBurger",
        servings: 2,
        duration: 25,
        protein: 90,
        carbs: 66,
        fats: 84,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Rinderhackfleisch (20 % Fett)", amount: 400, unit: "g"),
            Ingredient(name: "Burger Buns", amount: 2, unit: "pcs"),
            Ingredient(name: "Cheddar Käse", amount: 4, unit: "pcs"),
            Ingredient(name: "Butter", amount: 1, unit: "tbsp")
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp"),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp")
        ],
        steps: [
            "Pfanne sehr stark erhitzen.",
            "Hackfleisch zu Kugeln formen und in der Pfanne smashen.",
            "Wenden, würzen und Käse darauf schmelzen lassen.",
            "Burger zusammenbauen und servieren."
        ]
    ),

    Recipe(
        name: "Flammkuchen-Baguettes",
        imageName: "flammkuchenBaguettes",
        servings: 2,
        duration: 20,
        protein: 56,
        carbs: 110,
        fats: 60,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Baguette", amount: 1, unit: "pcs"),
            Ingredient(name: "Crème fraîche", amount: 200, unit: "g"),
            Ingredient(name: "Speckwürfel", amount: 150, unit: "g"),
            Ingredient(name: "Zwiebel", amount: 1, unit: "pcs")
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp"),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp"),
            Spice(name: "Muskat", amount: 1, unit: "pinch")
        ],
        steps: [
            "Baguette längs halbieren.",
            "Crème fraîche gleichmäßig verstreichen.",
            "Mit Speckwürfeln und Zwiebeln belegen.",
            "Im Ofen knusprig backen."
        ]
    ),
    
    Recipe(
        name: "Hähnchen Teriyaki mit Reis",
        imageName: "chickenTeriyaki",
        servings: 3,
        duration: 35,
        protein: 138,
        carbs: 210,
        fats: 36,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Hähnchenbrust", amount: 600, unit: "g"),
            Ingredient(name: "Basmatireis", amount: 300, unit: "g"),
            Ingredient(name: "Teriyaki Sauce", amount: 150, unit: "ml"),
            Ingredient(name: "Sesamöl", amount: 1, unit: "tbsp")
        ],
        spices: [
            Spice(name: "Salz", amount: 1, unit: "tsp"),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp"),
            Spice(name: "Knoblauchpulver", amount: 1, unit: "tsp")
        ],
        steps: [
            "Reis nach Packungsanleitung kochen.",
            "Hähnchen in Stücke schneiden und anbraten.",
            "Mit Teriyaki Sauce ablöschen und köcheln lassen.",
            "Mit Reis servieren."
        ]
    ),

    Recipe(
        name: "Pasta Carbonara",
        imageName: "carbonara",
        servings: 4,
        duration: 25,
        protein: 124,
        carbs: 360,
        fats: 148,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Spaghetti", amount: 400, unit: "g"),
            Ingredient(name: "Guanciale", amount: 200, unit: "g"),
            Ingredient(name: "Eier", amount: 4, unit: "pcs"),
            Ingredient(name: "Parmesan", amount: 120, unit: "g")
        ],
        spices: [
            Spice(name: "Pfeffer", amount: 2, unit: "tsp"),
            Spice(name: "Salz", amount: 1, unit: "tsp")
        ],
        steps: [
            "Spaghetti in Salzwasser kochen.",
            "Guanciale knusprig anbraten.",
            "Eier mit Parmesan verrühren.",
            "Pasta mit Guanciale mischen und Eiermasse unterziehen."
        ]
    ),

    Recipe(
        name: "Lachs mit Ofenkartoffeln",
        imageName: "salmonPotatoes",
        servings: 2,
        duration: 40,
        protein: 88,
        carbs: 120,
        fats: 72,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Lachsfilet", amount: 400, unit: "g"),
            Ingredient(name: "Kartoffeln", amount: 600, unit: "g"),
            Ingredient(name: "Olivenöl", amount: 3, unit: "tbsp"),
            Ingredient(name: "Zitrone", amount: 1, unit: "pcs")
        ],
        spices: [
            Spice(name: "Salz", amount: 2, unit: "tsp"),
            Spice(name: "Pfeffer", amount: 1, unit: "tsp"),
            Spice(name: "Paprikapulver", amount: 1, unit: "tsp")
        ],
        steps: [
            "Backofen auf 200°C vorheizen.",
            "Kartoffeln schneiden und mit Öl und Gewürzen mischen.",
            "Lachs würzen und auf das Blech legen.",
            "Alles im Ofen goldbraun backen."
        ]
    ),

    Recipe(
        name: "Chili con Carne",
        imageName: "chiliConCarne",
        servings: 4,
        duration: 50,
        protein: 176,
        carbs: 160,
        fats: 120,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Rinderhackfleisch", amount: 800, unit: "g"),
            Ingredient(name: "Kidneybohnen", amount: 400, unit: "g"),
            Ingredient(name: "Mais", amount: 300, unit: "g"),
            Ingredient(name: "Tomaten aus der Dose", amount: 800, unit: "g")
        ],
        spices: [
            Spice(name: "Salz", amount: 2, unit: "tsp"),
            Spice(name: "Chilipulver", amount: 2, unit: "tsp"),
            Spice(name: "Paprikapulver", amount: 2, unit: "tsp"),
            Spice(name: "Kreuzkümmel", amount: 1, unit: "tsp")
        ],
        steps: [
            "Hackfleisch scharf anbraten.",
            "Tomaten, Bohnen und Mais hinzufügen.",
            "Gewürze einrühren und köcheln lassen.",
            "Abschmecken und servieren."
        ]
    ),

    Recipe(
        name: "Vegetarisches Curry mit Kichererbsen",
        imageName: "chickpeaCurry",
        servings: 3,
        duration: 30,
        protein: 66,
        carbs: 198,
        fats: 54,
        customCalories: 0,
        ingredients: [
            Ingredient(name: "Kichererbsen", amount: 480, unit: "g"),
            Ingredient(name: "Kokosmilch", amount: 400, unit: "ml"),
            Ingredient(name: "Basmatireis", amount: 250, unit: "g"),
            Ingredient(name: "Paprika", amount: 2, unit: "pcs")
        ],
        spices: [
            Spice(name: "Currypulver", amount: 2, unit: "tbsp"),
            Spice(name: "Salz", amount: 1, unit: "tsp"),
            Spice(name: "Ingwer", amount: 1, unit: "tsp")
        ],
        steps: [
            "Reis kochen.",
            "Gemüse anbraten und Kichererbsen hinzufügen.",
            "Mit Kokosmilch und Gewürzen köcheln lassen.",
            "Mit Reis servieren."
        ]
    )

]
