//
//  MealPlanListSection.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 19.01.26.
//

import SwiftUI
import SwiftData

struct MealPlanListSection: View {

    @Environment(\.modelContext) private var modelContext

    let entries: [MealPlanEntry]
    let mealType: String
    let isEditing: Bool
    
    @Binding var date: Date
    
    @State private var showRecipes = false

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            
            Text(mealType.capitalized)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(MealType(rawValue: mealType)?.color ?? .brandPrimary)
                .padding(.horizontal)

            if entries.isEmpty {
                ZStack {
                    EmptyRecipeCardView(isEditing: isEditing)
                        .contentShape(Rectangle())

                    if isEditing {
                        Rectangle()
                            .fill(.black.opacity(0.7))
                            .allowsHitTesting(false)

                        Button {
                            showRecipes = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 70, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.brandPrimary)
                                .shadow(radius: 8)
                        }
                        .buttonStyle(.plain)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .scaleEffect(isEditing ? 0.98 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: isEditing)
                .padding(.horizontal)
            } else {
                VStack(spacing: 12) {
                    ForEach(entries) { entry in
                        row(for: entry)
                    }
                    
                    if isEditing {
                        ZStack {
                            EmptyRecipeCardView(isEditing: isEditing)
                                .contentShape(Rectangle())

                            Rectangle()
                                .fill(.black.opacity(0.7))
                                .allowsHitTesting(false)

                            Button {
                                showRecipes = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 70, weight: .bold))
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.brandPrimary)
                                    .shadow(radius: 8)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .scaleEffect(isEditing ? 0.98 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.9), value: isEditing)
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: 350, alignment: .leading)
        .navigationDestination(isPresented: $showRecipes) {
            RecipesView(isAddingToWeekPlanner: true, date: date, mealType: mealType, isPresented: $showRecipes)
        }
    }

    @ViewBuilder
    private func row(for entry: MealPlanEntry) -> some View {
        if let recipe = entry.recipe {

            ZStack {
                Group {
                    if isEditing {
                        MealPlanRecipeCardView(imageData: recipe.imageData, recipe: recipe)
                    } else {
                        NavigationLink {
                            RecipeView(recipe: recipe)
                        } label: {
                            MealPlanRecipeCardView(imageData: recipe.imageData, recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .contentShape(Rectangle())

                if isEditing {
                    Rectangle()
                        .fill(.black.opacity(0.7))
                        .allowsHitTesting(false)

                    Button(role: .destructive) {
                        delete(entry)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 70, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.brandPrimary)
                            .shadow(radius: 8)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(isEditing ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: isEditing)

        } else {
            Text("No recipe")
                .foregroundStyle(.secondary)
        }
    }

    private func delete(_ entry: MealPlanEntry) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            modelContext.delete(entry)
        }
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete MealPlanEntry:", error)
        }
    }
}


#Preview {
    MealPlanListSection(entries: [MealPlanEntry(day: Date(), mealType: .dinner, recipe: mockRecipes[0]), MealPlanEntry(day: Date(), mealType: .dinner, recipe: mockRecipes[1])], mealType: "Breakfast", isEditing: false, date: .constant(Date()))
}
