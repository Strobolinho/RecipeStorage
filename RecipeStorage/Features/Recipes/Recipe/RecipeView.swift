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
    
    @Query(sort: \MealPlanEntry.day) private var entries: [MealPlanEntry]
    
    @ObservedObject private var viewModel: RecipeViewModel = RecipeViewModel()
    
    let recipe: Recipe
    
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
                    viewModel.showAddToWeekPlannerSheet = true
                } label: {
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 22))
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
            viewModel.showAddToWeekPlannerSheet = false
            viewModel.date = Date()
            viewModel.mealType = .dinner
        } content: {
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

