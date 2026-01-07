//
//  RecipeTopImageView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct RecipeTopImageView: View {
    
    let imageData: Data?
    let name: String
    
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
    RecipeTopImageView(
        imageData: UIImage(named: "lasagna")?.jpegData(compressionQuality: 0.8),
        name: "Lasagne"
    )
}
