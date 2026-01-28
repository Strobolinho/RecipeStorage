//
//  SettingsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Lists") {
                    NavigationLink {
                        CategorySettingsView()
                    } label: {
                        Text("Recipe Categories")
                    }
                    
                    NavigationLink {
                        IngredientsListView()
                    } label: {
                        Text("Ingredients")
                    }
                 
                    NavigationLink {
                        MealPlanEntriesView()
                    } label: {
                        Text("Mealplan Entries")
                    }
                }
                
                Section("Controls Playground") {
                    NavigationLink {
                        ControlsPlaygroundView()
                    } label: {
                        Text("Controls Playground")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
