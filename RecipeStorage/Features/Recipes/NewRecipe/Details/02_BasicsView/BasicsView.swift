//
//  BasicsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI

struct BasicsView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    
    var body: some View {
        
        Section("Basic Data") {
            TextField("Recipe Name", text: $viewModel.name)

            TextField("Servings", value: $viewModel.servings, format: .number)
                .keyboardType(.numberPad)
            
            TextField("Duration", value: $viewModel.duration, format: .number)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    Form {
        BasicsView(viewModel: NewRecipeViewModel())
    }
}
