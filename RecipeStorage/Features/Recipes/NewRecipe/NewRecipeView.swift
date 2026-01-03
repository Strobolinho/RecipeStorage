//
//  NewRecipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.01.26.
//

import SwiftUI

struct NewRecipeView: View {
    
    @StateObject private var viewModel = NewRecipeViewModel()
    
    var body: some View {
        Form {
            ImageView()
            
            BasicsView(viewModel: viewModel)
            
            SetMacrosView(viewModel: viewModel)
            
            AddIngredientsButtonView(viewModel: viewModel)
            
            AddSpicesButtonView(viewModel: viewModel)
        }
        .navigationTitle("New Recipe")
    }
}

#Preview {
    NewRecipeView()
}


