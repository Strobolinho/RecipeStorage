//
//  RwcipeView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct RecipeView: View {
    var body: some View {
        VStack {
            RecipeTopImageView(
                image: "lasagna",
                name: "Lasagne"
            )
            
            Form {
                MacrosView()
            }
        }
    }
}

#Preview {
    RecipeView()
}

