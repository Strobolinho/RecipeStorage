//
//  GroceriesToolbar.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.02.26.
//

import SwiftUI
import SwiftData

struct GroceriesToolbar: ToolbarContent {
    
    @Binding var showSyncRemindersListSheet: Bool
    @Binding var showDeleteAllDialog: Bool
    @Binding var showAddGrocerySheet: Bool

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                showSyncRemindersListSheet = true
            } label: {
                Image(systemName: "list.bullet.circle")
            }
            .font(.system(size: 22))

            Button {
                showDeleteAllDialog = true
            } label: {
                Image(systemName: "trash.circle")
            }
            .font(.system(size: 22))

            Button {
                showAddGrocerySheet = true
            } label: {
                Image(systemName: "cart.badge.plus")
            }
            .font(.system(size: 18))
        }

        ToolbarItem(placement: .principal) {
            Text("Groceries")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.brandPrimary)
        }
    }
}
