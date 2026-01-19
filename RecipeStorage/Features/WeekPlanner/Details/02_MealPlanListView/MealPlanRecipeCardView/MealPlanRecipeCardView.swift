//
//  MealPlanRecipeCardView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 19.01.26.
//

import SwiftUI

struct MealPlanRecipeCardView: View {
    
    let imageData: Data?
    let recipe: Recipe
    
    var body: some View {
        ZStack {
            Group {
                if
                    let imageData,
                    let uiImage = UIImage(data: imageData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .padding(40)
                }
            }
            .scaledToFill()
            .frame(width: 350, height: 100)
            .clipped()
            .cornerRadius(15)
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("\(recipe.servings)")
                    
                    Spacer()
                    
                    Image(systemName: "clock.fill")
                    Text("\(recipe.duration) min")
                }
                .fontWeight(.semibold)
                .font(.title3)
                .padding(.horizontal)
                .padding(.top, 5)
                .foregroundStyle(.recipeTitle)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.9),
                            Color.black.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Spacer()
                
                Text(recipe.name)
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundStyle(.recipeTitle)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.9),
                                Color.black.opacity(0.0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
            }
            
        }
        .frame(width: 350, height: 100)
    }
}


#Preview {
    MealPlanRecipeCardView(
        imageData: UIImage(named: "lasagna")?.jpegData(compressionQuality: 0.8),
        recipe: mockRecipes[0]
    )
}
