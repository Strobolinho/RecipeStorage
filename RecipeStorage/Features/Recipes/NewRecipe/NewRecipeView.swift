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
            
            BasicsView()
            
            SetMacrosView()
            
            AddIngredientsView()
            
            AddSpicesView()
        }
        .navigationTitle("New Recipe")
    }
}

#Preview {
    NewRecipeView()
}
