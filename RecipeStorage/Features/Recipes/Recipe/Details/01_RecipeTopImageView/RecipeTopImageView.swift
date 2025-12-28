//
//  RecipeTopImageView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct RecipeTopImageView: View {
    
    let image: String
    let name: String
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 230)
                .clipped()
                .cornerRadius(15)
                .padding(.horizontal, 5)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(name)
                    .fontWeight(.bold)
                    .font(.title)
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
        .frame(width: 400, height: 230)
    }
}


#Preview {
    RecipeTopImageView(image: "lasagna", name: "Lasagne")
}
