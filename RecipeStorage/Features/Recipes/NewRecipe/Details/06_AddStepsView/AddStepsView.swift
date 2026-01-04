//
//  AddStepsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 04.01.26.
//

import SwiftUI

struct AddStepsView: View {
    
    @ObservedObject var viewModel: NewRecipeViewModel
    var focusedField: FocusState<newRecipeField?>.Binding    
    
    var body: some View {
        Section("Steps") {
            HStack {
                TextField("\(viewModel.steps.count + 1). Step", text: $viewModel.step)
                    .focused(focusedField, equals: .steps)
                
                Button {
                    if !viewModel.step.isEmpty {
                        viewModel.steps.append(viewModel.step)
                        viewModel.step = ""
                    }
                } label: {
                    Image(systemName: "cross.circle")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundStyle(.brandPrimary)
                        .padding(.trailing, 22)
                }
            }
            
            if !viewModel.steps.isEmpty {
                ForEach(viewModel.steps.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .fontWeight(.bold)
                            .foregroundStyle(.brandPrimary)
                        Text(viewModel.steps[index])
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteStep(at: index)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
                .onMove { indices, newOffset in
                    viewModel.steps.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var vm = NewRecipeViewModel()
        @FocusState var focus: newRecipeField?

        var body: some View {
            Form {
                AddStepsView(viewModel: vm, focusedField: $focus)
            }
        }
    }

    return PreviewWrapper()
}
