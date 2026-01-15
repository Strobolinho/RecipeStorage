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
                Section("Recipe Categories") {
                    NavigationLink {
                        CategorySettingsView()
                    } label: {
                        Text("Recipe Category Settings")
                    }
                }
                
                Section("Ingredients") {
                    NavigationLink {
                        IngredientsListView()
                    } label: {
                        Text("Ingredients")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
