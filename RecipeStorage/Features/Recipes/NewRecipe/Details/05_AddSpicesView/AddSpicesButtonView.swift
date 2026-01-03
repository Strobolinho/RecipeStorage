//
//  AddIngredientsButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 03.01.26.
//

import SwiftUI

struct AddSpicesButtonView: View {
    
    @ObservedObject  var viewModel: NewRecipeViewModel
    
    var body: some View {
        Section("Spices") {
            NavigationLink {
                AddSpicesView(viewModel: viewModel)
            } label: {
                HStack(alignment: .center) {
                    Text("Add Spice")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "cross.circle")
                        .font(.system(size: 23, weight: .bold))
                }
                .foregroundStyle(.brandPrimary)
            }
            
            if !viewModel.spices.isEmpty {
                ForEach(viewModel.spices) { spice in
                    HStack {
                        Text(spice.name)
                        Spacer()
                        Text("\(spice.amount) \(spice.unit)")
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        AddSpicesButtonView(viewModel: NewRecipeViewModel())
    }
}
