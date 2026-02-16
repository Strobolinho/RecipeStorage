//
//  WeekPlannerToolbar.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI
import SwiftData

struct WeekPlannerToolbar: ToolbarContent {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealPlanEntry.day) private var mealplanEntries: [MealPlanEntry]
    @Query(sort: \GroceryListEntry.name) private var groceryEntries: [GroceryListEntry]
    
    @ObservedObject var viewModel: WeekPlannerViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Button {
                    if let idx = viewModel.jumpToToday() {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            viewModel.selectedIndex = idx
                        }
                    }
                } label: {
                    Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                        .font(.system(size: 18))
                }

                Button {
                    viewModel.openEntriesSheet()
                } label: {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 18))
                }
            }
        }

        ToolbarItem(placement: .principal) {
            DayHeaderView(date: $viewModel.date)
                .frame(maxWidth: .infinity, alignment: .center)
        }

        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button {
                    viewModel.requestAddGroceriesIfPossible(mealplanEntries: mealplanEntries)
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 18))
                }
                .alert("Are you sure you want to add these groceries?",
                       isPresented: $viewModel.showAddGroceriesDialog) {
                    Button("Add to Grocery List", role: .confirm) {
                        viewModel.addGroceriesForCurrentDay(
                            mealplanEntries: mealplanEntries,
                            groceryEntries: groceryEntries,
                            modelContext: modelContext
                        )
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.showAddGroceriesDialog = false
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                        viewModel.toggleEditing()
                    }
                } label: {
                    Image(systemName: viewModel.isEditing ? "checkmark.circle" : "square.and.pencil.circle")
                        .font(.system(size: 22))
                }
            }
        }
    }
}
