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
                
                Button(role: .destructive) {
                    viewModel.showDeleteDialog = true
                } label: {
                    HStack {
                        Text("Delete Recipe").fontWeight(.bold)
                        Image(systemName: "trash")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.brandPrimary)
                }
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
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showAddGroceriesDialog = true
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 18))
                }
                .alert("Are you sure you want to add these groceries?", isPresented: $viewModel.showAddGroceriesDialog) {
                    Button("Add to Grocery List", role: .confirm) {
                        for ingredient in recipe.ingredients! {
                            addGroceryItem(GroceryListEntry(name: ingredient.name, unit: ingredient.unit, amount: ingredient.amount))
                        }
                    }
                    Button(role: .cancel) {}
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.date = Date()
                    viewModel.mealType = .dinner
                    viewModel.showAddToWeekPlannerSheet = true
                } label: {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 17))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NewRecipeView(recipeToEdit: recipe)
                } label: {
                    Image(systemName: "square.and.pencil.circle")
                        .font(.system(size: 22))
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddToWeekPlannerSheet) {
            List {
                Section {
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: [.date])

                    Picker("Meal Type", selection: $viewModel.mealType) {
                        ForEach(MealType.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                }

                Section {
                    Button {
                        let entry = MealPlanEntry(day: viewModel.date, mealType: viewModel.mealType, recipe: recipe)
                        modelContext.insert(entry)
                        try? modelContext.save()

                        viewModel.showAddToWeekPlannerSheet = false
                    } label: {
                        Text("Add to Week Planner")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.bold)
                    }
                }
            }
            .presentationDetents([.height(230)])
            .scrollDisabled(true)
        }
    }
}

#Preview {
    RecipeView(recipe: mockRecipes[0])
}

