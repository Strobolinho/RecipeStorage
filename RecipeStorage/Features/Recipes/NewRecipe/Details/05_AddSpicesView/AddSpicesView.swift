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

    @StateObject private var screenVM = AddSpicesViewModel()

    @FocusState private var focusedField: spiceField?

    var body: some View {

        let units = screenVM.units(from: unitStore)

        Form {
            Section("New Spices") {
                TextField("Spice Name", text: $viewModel.spiceName)
                    .focused($focusedField, equals: .spiceName)

                TextField("Amount", value: $viewModel.spiceAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)

                Picker("Unit", selection: $viewModel.spiceUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .onChange(of: viewModel.spiceUnit) {
                    if screenVM.isCustomUnitSelected(viewModel.spiceUnit) {
                        DispatchQueue.main.async {
                            focusedField = .newUnit
                        }
                    }
                }

                if screenVM.isCustomUnitSelected(viewModel.spiceUnit) {
                    HStack {
                        TextField("New Unit", text: $viewModel.newSpiceUnit)
                            .focused($focusedField, equals: .newUnit)

                        Button {
                            screenVM.addNewSpiceUnit(recipeVM: viewModel, unitStore: unitStore)
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }

                Button {
                    screenVM.addSpice(recipeVM: viewModel)
                    focusedField = .spiceName
                } label: {
                    Text("Add Spice")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            if !viewModel.spices.isEmpty {
                Section("Added Spices") {
                    ForEach(screenVM.sortedSpices(viewModel.spices)) { spice in
                        HStack {
                            Text(spice.name)
                            Spacer()
                            Text("\(spice.amount) \(spice.unit)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                screenVM.deleteSpice(spice, recipeVM: viewModel)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        screenVM.moveSpices(fromOffsets: indices, toOffset: newOffset, recipeVM: viewModel)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next") {
                    focusedField = screenVM.nextField(after: focusedField)
                }
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
