//
//  RwcipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct RecipeView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("lasagna")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 230)
                    .clipped()
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("Lasagna")
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


            
            Form {
                Section("Info") {
                    Text("Test")
                }
            }
        }
    }
}

#Preview {
    RecipeView()
}
