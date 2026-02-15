//
//  EmptyGroceryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.02.26.
//

import SwiftUI

struct EmptyGroceryListView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart.fill.badge.questionmark")
                .font(.system(size: 70))
                .foregroundStyle(.brandPrimary)

            Text("No Groceries added to the List")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Add your Groceries")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Image(systemName: "arrow.up.right.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.brandPrimary)
        }
    }
}

#Preview {
    EmptyGroceryListView()
}
