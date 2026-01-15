//
//  IngredientsListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 15.01.26.
//

import SwiftUI

struct IngredientsListView: View {
    
    @EnvironmentObject var ingredientStore: IngredientStore
    
    var body: some View {
        List(ingredientStore.ingredientNames, id: \.self) {
            Text($0)
        }
    }
}

#Preview {
    IngredientsListView()
        .environmentObject(IngredientStore())
}
