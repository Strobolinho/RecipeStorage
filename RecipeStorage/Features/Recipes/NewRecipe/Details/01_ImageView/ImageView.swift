//
//  ImageView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI
import PhotosUI

struct ImageView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    @State private var item: PhotosPickerItem?
    
    var body: some View {
        Section("Recipe Image") {
            PhotosPicker(selection: $item, matching: .images) {
                if let imageData = viewModel.imageData,
                   let uiImage = UIImage(data: imageData) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 340, height: 230)
                        .clipped()
                        .cornerRadius(15)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 340, height: 230)
                            .foregroundStyle(Color(.systemGray4))
                        
                        VStack(alignment: .center, spacing: 15) {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                            
                            Text("Add Photo")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(.brandPrimary)
                    }
                }
            }
            .onChange(of: item) { _, newItem in
                guard let newItem else { return }
                Task {
                    viewModel.imageData = try? await newItem.loadTransferable(type: Data.self)
                }
            }
        }
    }
}

#Preview {
    Form {
        ImageView(viewModel: NewRecipeViewModel())
    }
}
