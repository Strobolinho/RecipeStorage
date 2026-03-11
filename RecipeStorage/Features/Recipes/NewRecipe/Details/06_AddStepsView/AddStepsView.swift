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
                TextField(
                    viewModel.isUpdatingStep
                        ? "Step bearbeiten"
                        : "\(viewModel.steps.count + 1). Step",
                    text: $viewModel.step
                )
                    .focused(focusedField, equals: .steps)
                
                Button {
                    if viewModel.isUpdatingStep {
                        viewModel.updateStep()
                    } else {
                        viewModel.addStep()
                    }
                } label: {
                    Image(systemName: viewModel.isUpdatingStep ? "checkmark.circle" : "plus.circle")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundStyle(.brandPrimary)
                        .padding(.trailing, 22)
                }
            }
            
            if !viewModel.steps.isEmpty {
                ForEach(viewModel.steps.indices, id: \.self) { index in
                    Button {
                        viewModel.startEditingStep(at: index)
                        focusedField.wrappedValue = .steps
                    } label: {
                        HStack {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                            Text(viewModel.steps[index])
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteStep(at: index)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
                .onMove { indices, newOffset in
                    viewModel.moveSteps(fromOffsets: indices, toOffset: newOffset)
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
