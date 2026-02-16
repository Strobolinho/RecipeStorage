//
//  NewCategorySheet.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI

struct NewCategorySheet: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var viewModel: NewRecipeViewModel
    var categoryStore: CategoryStore?
    
    var body: some View {
        List {
            Section {
                TextField("New Category", text: $viewModel.draftCategoryName)
                    .textInputAutocapitalization(.words)
            }

            Section {
                Button {
                    viewModel.submitAddCategory(store: categoryStore, modelContext: modelContext)
                } label: {
                    Text("Add Category")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(.bold)
                }
                .disabled(!viewModel.canSubmitCategory)
            }
        }
        .presentationDetents([.height(160)])
        .scrollDisabled(true)
    }
}

#Preview {
    NewCategorySheet(viewModel: NewRecipeViewModel())
}
