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
    
    @EnvironmentObject var ingredientsStore: IngredientStore
    
    @Query(sort: \MealPlanEntry.day) private var mealPlanEntries: [MealPlanEntry]
    @Query(sort: \GroceryListEntry.name) private var groceryEntries: [GroceryListEntry]
    
    @StateObject private var viewModel = RecipeViewModel()
    
    @StateObject private var groceriesViewModel = GroceryListViewModel()
    
    let recipe: Recipe
    
    
    func addGroceryItem(_ newGroceryItem: GroceryListEntry) {
        if let existing = groceryEntries.first(where: { $0.name == newGroceryItem.name && $0.unit == newGroceryItem.unit }) {
            existing.amount! += newGroceryItem.amount!
            existing.isChecked = false
        } else {
            modelContext.insert(newGroceryItem)
        }

        do { try modelContext.save() }
        catch { print("❌ save failed:", error) }
    }
    
    
    var body: some View {
        VStack {
            RecipeTopImageView(
                imageData: recipe.imageData,
                recipe: recipe
            )
            
            Form {
                CategoriesView(recipe: recipe)
                
                MacrosView(recipe: recipe)
                
                IngredientListView(recipe: recipe)
                
                SpiceListView(recipe: recipe)
                
                StepsListView(recipe: recipe)
                
                DeleteRecipeButtonView(viewModel: viewModel)
                .confirmationDialog("Rezept wirklich löschen?", isPresented: $viewModel.showDeleteDialog) {
                    Button("Löschen", role: .destructive) {
                        modelContext.delete(recipe)
                        
                        ingredientsStore.load(from: modelContext.container)
                        
                        dismiss()
                    }
                    Button("Abbrechen", role: .cancel) {}
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            RecipeToolbar(viewModel: viewModel, recipe: recipe)
        }
        .alert("Are you sure you want to add these groceries?", isPresented: $viewModel.showAddGroceriesDialog) {
            Button("Add to Grocery List", role: .confirm) {
                for ingredient in recipe.ingredients! {
                    addGroceryItem(GroceryListEntry(name: ingredient.name, unit: ingredient.unit, amount: ingredient.amount))
                }
            }
            Button(role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.showAddToWeekPlannerSheet) {
            AddToWeekplannerSheet(viewModel: viewModel, recipe: recipe)
        }
    }
}

#Preview {
    RecipeView(recipe: mockRecipes[0])
}

