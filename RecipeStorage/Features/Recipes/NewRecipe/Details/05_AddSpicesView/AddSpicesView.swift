//
//  AddSpicesView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 02.01.26.
//

import SwiftUI
import SwiftData


enum spiceField: Hashable {
    case spiceName
    case amount
    case newUnit
}


struct AddSpicesView: View {
    
    @Query private var unitStores: [UnitStore]
    private var unitStore: UnitStore? { unitStores.first }
    
    @ObservedObject var viewModel: NewRecipeViewModel
    @FocusState private var focusedField: spiceField?
    
    private func focusNext() {
        switch focusedField {
        case .spiceName: focusedField = .amount
        case .amount: focusedField = nil
        default: focusedField = nil
        }
    }
    
    private func addNewSpiceUnit() {
        guard let unitStore else { return }
        
        let newUnit = viewModel.newSpiceUnit
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newUnit.isEmpty else { return }

        if !unitStore.spiceUnits.contains(newUnit) {
            unitStore.spiceUnits.append(newUnit)
        }

        viewModel.spiceUnit = newUnit
        viewModel.newSpiceUnit = ""
    }
    
    var body: some View {
        
        Form {
            Section("New Spices") {
                TextField("Spice Name", text: $viewModel.spiceName)
                    .focused($focusedField, equals: .spiceName)
                
                TextField("Amount", value: $viewModel.spiceAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
                
                Picker("Unit", selection: $viewModel.spiceUnit) {
                    ForEach(unitStore?.spiceUnits ?? ["Custom Unit", "TL", "EL"], id: \.self) { unit in
                        Text(unit)
                    }
                }
                .onChange(of: viewModel.spiceUnit) {
                    if viewModel.spiceUnit == "Custom Unit" {
                        DispatchQueue.main.async {
                            focusedField = .newUnit
                        }
                    }
                }
                
                if viewModel.spiceUnit == "Custom Unit" {
                    HStack {
                        TextField("New Unit", text: $viewModel.newSpiceUnit)
                            .focused($focusedField, equals: .newUnit)
                        
                        Button {
                            addNewSpiceUnit()
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }
                
                Button {
                    viewModel.addSpice()
                    focusedField = .spiceName
                } label: {
                    Text("Add Ingredient")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            if !viewModel.spices.isEmpty {
                Section("Added Spices") {
                    ForEach(viewModel.spices.sorted { ($0.position ?? 0) < ($1.position ?? 0) }) { spice in
                        HStack {
                            Text(spice.name)
                            Spacer()
                            Text("\(spice.amount) \(spice.unit)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteSpice(spice)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        viewModel.spices.move(fromOffsets: indices, toOffset: newOffset)
                        viewModel.reindexSpices()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") { focusNext() }
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .onAppear {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
            focusedField = .spiceName
        }
    }
}

#Preview {
        AddSpicesView(viewModel: NewRecipeViewModel())
}
