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
                        
                    } label: {
                        Text("Recipe Category Settings")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
