//
//  AddIngredientsButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 03.01.26.
//

import SwiftUI

struct AddIngredientsButtonView: View {
    
    @ObservedObject  var viewModel: NewRecipeViewModel
    
    var body: some View {
        Section("Ingredients") {
            NavigationLink {
                AddIngredientsView(viewModel: viewModel)
            } label: {
                HStack(alignment: .center) {
                    Text("Add Ingredient")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "cross.circle")
                        .font(.system(size: 23, weight: .bold))
                }
                .foregroundStyle(.brandPrimary)
            }
            
            if !viewModel.ingredients.isEmpty {
                ForEach(viewModel.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(ingredient.amount) \(ingredient.unit)")
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        AddIngredientsButtonView(viewModel: NewRecipeViewModel())
    }
}
