//
//  EmptyRecipeCardView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 21.01.26.
//

import SwiftUI

struct EmptyRecipeCardView: View {
    
    let isEditing: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 320, height: 100)
                .padding(.horizontal, 5)
                .foregroundStyle(
                    LinearGradient(colors: [
                        Color(uiColor: .systemGray4),
                        Color(uiColor: .black)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            if !isEditing {
                ZStack {
                    
                    Image(systemName: "fork.knife")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.recipeTitle)
                        .padding(.trailing, 3)
                    
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 70))
                        //.fontWeight(.bold)
                        .foregroundStyle(.brandPrimary)
                }
            }
            
        }
        .frame(width: 320, height: 100)
    }
}


#Preview {
    EmptyRecipeCardView(isEditing: false)
}
