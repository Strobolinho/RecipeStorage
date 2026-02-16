//
//  DeleteRecipeButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI

struct DeleteRecipeButtonView: View {
    
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Button(role: .destructive) {
            viewModel.showDeleteDialog = true
        } label: {
            HStack {
                Text("Delete Recipe").fontWeight(.bold)
                Image(systemName: "trash")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(.brandPrimary)
        }
    }
}

#Preview {
    DeleteRecipeButtonView(viewModel: RecipeViewModel())
}
