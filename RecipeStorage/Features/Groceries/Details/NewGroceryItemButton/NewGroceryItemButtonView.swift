//
//  NewGroceryItemButtonView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import SwiftUI

struct NewGroceryItemButtonView: View {
    
    @ObservedObject var viewModel: GroceryListViewModel

    var focusedField: FocusState<NewGroceryItemField?>.Binding
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                viewModel.showNewGroceryItemTextField.toggle()
                focusedField.wrappedValue = .groceryItemName
            } label: {
                ZStack {
                    Text(viewModel.showNewGroceryItemTextField ? "Done" : "New Grocery Item")
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 250, height: 40)
                                .foregroundStyle(Color(uiColor: .systemGray6))
                                .opacity(0.8)
                        )
                }
                .padding(.bottom, 25)
            }
        }
    }
}
