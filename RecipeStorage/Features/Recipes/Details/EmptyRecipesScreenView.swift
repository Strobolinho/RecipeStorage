//
//  EmptyRecipesScreenView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.02.26.
//

import SwiftUI

struct EmptyRecipesScreenView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 70))
                .foregroundStyle(.brandPrimary)

            Text("No Recipes available")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Create your first Recipe")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.brandPrimary)
        }
    }
}

#Preview {
    EmptyRecipesScreenView()
}
