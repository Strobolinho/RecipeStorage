//
//  RecipeCardView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 30.12.25.
//

import SwiftUI

struct RecipeCardView: View {
    
    let recipe: Recipe
    var body: some View {
        
        ZStack {
            Group {
                if
                    let imageData = recipe.imageData,
                    let uiImage = UIImage(data: imageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    // Placeholder wenn kein Bild vorhanden
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .padding(30)
                }
            }
            .scaledToFill()
            .frame(width: 180, height: 200)
            .clipped()
            .cornerRadius(15)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(recipe.name)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                    .foregroundStyle(.recipeTitle)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.9),
                                Color.black.opacity(0.01)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    
                    Spacer()
                    
                    Image(systemName: "clock.fill")
                    
                    Text("\(recipe.duration) min")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.top, 5)
                .foregroundStyle(.recipeTitle)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.9),
                            Color.black.opacity(0.01)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Spacer()
            }
        }
        .frame(width: 180, height: 200)
    }
}

#Preview {
    RecipeCardView(recipe: mockRecipes[3])
}
