//
//  MacroDetailView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.12.25.
//

import SwiftUI

struct MacroDetailView: View {
    
    let macroName: String
    let macroAmount: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text(macroName)
                .foregroundStyle(color)
            Text("\(macroAmount) g")
        }
    }
}

#Preview {
    MacroDetailView(
        macroName: "Protein", macroAmount: 78, color: .protein
    )
}
