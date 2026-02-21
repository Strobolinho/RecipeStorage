import SwiftUI
import SwiftData

enum ingredientField: Hashable {
    case ingredientName
    case amount
    case newUnit
}

struct AddIngredientsView: View {

    @Query private var unitStores: [UnitStore]
    private var unitStore: UnitStore? { unitStores.first }

    @ObservedObject var viewModel: NewRecipeViewModel

    @StateObject private var screenVM = AddIngredientsViewModel()

    @FocusState private var focusedField: ingredientField?

    @EnvironmentObject private var ingredientsStore: IngredientStore

    var body: some View {

        let suggestions = Array(Set(screenVM.ingredientSuggestions(for: viewModel.ingredientName))).sorted()
        let units = screenVM.units(from: unitStore)

        Form {
            Section("New Ingredients") {

                TextField("Ingredient Name", text: $viewModel.ingredientName)
                    .focused($focusedField, equals: .ingredientName)

                if focusedField == .ingredientName && !suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(suggestions.enumerated()), id: \.offset) { i, suggestion in
                            Button {
                                viewModel.ingredientName = suggestion
                                focusedField = .amount
                            } label: {
                                Text("   \(suggestion)")
                                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.brandPrimary.opacity(0.5))
                                    }
                            }
                            .buttonStyle(.plain)
                        }

                    }
                    .padding(.vertical, 4)
                }

                TextField("Amount", value: $viewModel.ingredientAmount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)

                Picker("Unit", selection: $viewModel.ingredientUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .onChange(of: viewModel.ingredientUnit) {
                    if screenVM.isCustomUnitSelected(viewModel.ingredientUnit) {
                        DispatchQueue.main.async {
                            focusedField = .newUnit
                        }
                    }
                }

                if screenVM.isCustomUnitSelected(viewModel.ingredientUnit) {
                    HStack {
                        TextField("New Unit", text: $viewModel.newIngredientUnit)
                            .focused($focusedField, equals: .newUnit)

                        Button {
                            screenVM.addNewIngredientUnit(recipeVM: viewModel, unitStore: unitStore)
                        } label: {
                            Text("+")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                        }
                    }
                }

                Button {
                    screenVM.addIngredient(recipeVM: viewModel)
                    focusedField = .ingredientName
                } label: {
                    Text("Add Ingredient")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            if !viewModel.ingredients.isEmpty {
                Section("Added Ingredients") {
                    ForEach(screenVM.sortedIngredients(viewModel.ingredients)) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.amount) \(ingredient.unit)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                screenVM.deleteIngredient(ingredient, recipeVM: viewModel)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        screenVM.moveIngredients(fromOffsets: indices, toOffset: newOffset, recipeVM: viewModel)
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
            // IngredientStore -> VM sync (nur Daten, keine Logik)
            screenVM.ingredientNames = ingredientsStore.ingredientNames

            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
            focusedField = .ingredientName
        }
        .onChange(of: ingredientsStore.ingredientNames) { _, newValue in
            // falls sich IngredientStore dynamisch ändert
            screenVM.ingredientNames = newValue
        }
    }
}
