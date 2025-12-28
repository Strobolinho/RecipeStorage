//
//  ContentView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
            
            WeekPlannerView()
                .tabItem {
                    Label("Week Planner", systemImage: "calendar")
                }
            
            GroceryListView()
                .tabItem {
                    Label("Grocery List", systemImage: "cart")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(.brandPrimary)
    }
}

#Preview {
    MainTabView()
}
