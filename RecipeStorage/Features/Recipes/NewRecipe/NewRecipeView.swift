//
//  NewRecipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI
import SwiftData

enum newRecipeField: Hashable {
    case recipeName
    case servings
    case duration
    case customCalories
    case protein
    case carbs
    case fats
    case steps
}

struct NewRecipeView: View {

    @Query private var unitStores: [UnitStore]
    @Query private var categoryStores: [CategoryStore]
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: newRecipeField?

    let recipeToEdit: Recipe?

    @State private var showAddCategorySheet = false
    @State private var draftCategoryName = ""

    init(recipeToEdit: Recipe? = nil) {
        self.recipeToEdit = recipeToEdit
        _viewModel = StateObject(wrappedValue: NewRecipeViewModel(recipe: recipeToEdit))
    }

    private func focusNext() {
        switch focusedField {
        case .recipeName: focusedField = .servings
        case .servings: focusedField = .duration
        case .duration:
            if viewModel.isCustomCalories {
                focusedField = .customCalories
            } else {
                focusedField = .protein
            }
        case .customCalories: focusedField = .protein
        case .protein: focusedField = .carbs
        case .carbs: focusedField = .fats
        case .fats: focusedField = .steps
        case .steps: focusedField = nil
        default: focusedField = nil
        }
    }

    var body: some View {
        Form {
            ImageView(viewModel: viewModel)

            BasicsView(viewModel: viewModel, focusedField: $focusedField)

            SetMacrosView(viewModel: viewModel, focusedField: $focusedField)

            AddIngredientsButtonView(viewModel: viewModel)

            AddSpicesButtonView(viewModel: viewModel)

            AddStepsView(viewModel: viewModel, focusedField: $focusedField)

            CategoriesScrollView(viewModel: viewModel) {
                draftCategoryName = ""
                showAddCategorySheet = true
            }

            RecipeSaveButtonView(viewModel: viewModel, recipeToEdit: recipeToEdit)
        }
        .navigationTitle("New Recipe")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            if unitStores.isEmpty {
                modelContext.insert(UnitStore())
            }
            if categoryStores.isEmpty {
                modelContext.insert(CategoryStore())
            }
        }
        .sheet(isPresented: $showAddCategorySheet) {
            List {
                Section {
                    TextField("New Category", text: $draftCategoryName)
                        .textInputAutocapitalization(.words)
                }
                
                Section {
                    Button {
                        if !(draftCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                            saveCategory(draftCategoryName)
                            showAddCategorySheet = false
                        }
                    } label: {
                        Text("Add Category")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.bold)
                    }
                }
            }
            .presentationDetents([.height(160)])
            .scrollDisabled(true)
        }
    }

    private func saveCategory(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // current store (if it exists)
        let store = categoryStores.first

        let existing = store?.categories ?? []
        guard !existing.contains(where: { $0.lowercased() == trimmed.lowercased() }) else { return }

        if let store {
            store.categories.append(trimmed)
        } else {
            modelContext.insert(CategoryStore(categories: [trimmed]))
        }

        // optional: directly select the new category for the recipe
        // viewModel.categories.insert(trimmed)
    }
}

#Preview {
    NewRecipeView(recipeToEdit: nil)
}
