//
//  NewRecipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI

struct NewRecipeView: View {
    
    @State private var name: String = ""
    @State private var servings: Int? = nil
    @State private var duration: Int? = nil
    
    @State private var protein: Int? = nil
    @State private var carbs: Int? = nil
    @State private var fats: Int? = nil
    
    private var calories: Int {
        let p = Double(protein ?? 0)
        let c = Double(carbs ?? 0)
        let f = Double(fats ?? 0)

        let total = (p + c) * 4.1 + f * 9.3
        return Int(total)
    }
    
    @State private var isCustomCalories: Bool = false
    @State private var customCalories: Int? = nil


    
    var body: some View {
        Form {
            Section("Recipe Image") {
                Text("Platzhalter")
            }
            
            Section("Basic Data") {
                TextField("Recipe Name", text: $name)

                TextField("Servings", value: $servings, format: .number)
                    .keyboardType(.numberPad)
                
                TextField("Duration", value: $duration, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Macros") {
                
                if isCustomCalories {
                    TextField("Custom Calories", value: $customCalories, format: .number)
                        .keyboardType(.numberPad)
                } else {
                    HStack {
                        Text("Calories:")
                        Spacer()
                        Text("\(calories) kcal")
                    }
                }
                
                Toggle("Custom Calories", isOn: $isCustomCalories)
                
                TextField("Protein", value: $protein, format: .number)
                    .keyboardType(.numberPad)
                
                TextField("Carbs", value: $carbs, format: .number)
                    .keyboardType(.numberPad)
                
                TextField("Fats", value: $fats, format: .number)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("New Recipe")
    }
}

#Preview {
    NewRecipeView()
}
