//
//  NewRecipeButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI

struct NewRecipeButtonView: View {
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        VStack() {
            Spacer()
            
            NavigationLink {
                NewRecipeView(recipesViewModel: viewModel)
            } label: {
                ZStack {
                    Text("New Recipe")
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 250, height: 40)
                                .foregroundStyle(.black)
                                .opacity(0.8)
                        )
                    
                    Image(systemName: "document.badge.plus.fill")
                        .padding(.leading, 160)
                }
                .padding(.bottom, 25)
            }
        }
    }
}

#Preview {
    NewRecipeButtonView(viewModel: RecipesViewModel())
}
