//
//  EmptyRecipeCardView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 21.01.26.
//

import SwiftUI

struct EmptyRecipeCardView: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 100)
                .padding(.horizontal, 5)
                .foregroundStyle(
                    LinearGradient(
                        colors: [ Color(uiColor: .systemGray6), .black, .brandPrimary, .black, Color(uiColor: .systemGray6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
            
            Text("No Recipe provided yet...")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.recipeTitle)
            
        }
        .frame(width: 350, height: 100)
    }
}


#Preview {
    EmptyRecipeCardView()
}
