//
//  RwcipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI
import SwiftData

struct RecipeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteDialog = false
    
    let recipe: Recipe
    
    var body: some View {
        VStack {
            RecipeTopImageView(
                imageData: recipe.imageData,
                recipe: recipe
            )
            
            Form {
                MacrosView(recipe: recipe)
                
                IngredientListView(recipe: recipe)
                
                SpiceListView(recipe: recipe)
                
                StepsListView(recipe: recipe)
                
                Button(role: .destructive) {
                    showDeleteDialog = true
                } label: {
                    HStack {
                        Text("Delete Recipe").fontWeight(.bold)
                        Image(systemName: "trash")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.brandPrimary)
                }
                .confirmationDialog("Rezept wirklich löschen?", isPresented: $showDeleteDialog) {
                    Button("Löschen", role: .destructive) {
                        modelContext.delete(recipe)
                        dismiss()
                    }
                    Button("Abbrechen", role: .cancel) {}
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    RecipeView(recipe: mockRecipes[0])
}
