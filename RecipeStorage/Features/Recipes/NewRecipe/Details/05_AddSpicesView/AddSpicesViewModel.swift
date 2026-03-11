//
//  AddSpicesViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 16.02.26.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class AddSpicesViewModel: ObservableObject {

    @Published var updateSpice: Bool = false
    @Published var spiceToEdit: Spice?
    
    // MARK: - Focus flow

    func nextField(after field: spiceField?) -> spiceField? {
        switch field {
        case .spiceName: return .amount
        case .amount: return nil
        case .newUnit: return nil
        case .none: return .spiceName
        }
    }

    // MARK: - Units

    func units(from unitStore: UnitStore?) -> [String] {
        unitStore?.spiceUnits ?? ["Custom Unit", "TL", "EL"]
    }

    func isCustomUnitSelected(_ unit: String) -> Bool {
        unit == "Custom Unit"
    }

    // MARK: - Actions

    func addNewSpiceUnit(
        recipeVM: NewRecipeViewModel,
        unitStore: UnitStore?
    ) {
        guard let unitStore else { return }

        let newUnit = recipeVM.newSpiceUnit
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newUnit.isEmpty else { return }

        if !unitStore.spiceUnits.contains(newUnit) {
            unitStore.spiceUnits.append(newUnit)
        }

        recipeVM.spiceUnit = newUnit
        recipeVM.newSpiceUnit = ""
    }

    func addSpice(recipeVM: NewRecipeViewModel) {
        recipeVM.addSpice()
    }
    
    func updateSpice(recipeVM: NewRecipeViewModel) {
        guard let spiceToEdit else { return }

        recipeVM.updateSpice(spiceToEdit)

        self.spiceToEdit = nil
        self.updateSpice = false
    }

    func deleteSpice(_ spice: Spice, recipeVM: NewRecipeViewModel) {
        recipeVM.deleteSpice(spice)
        
        if spiceToEdit?.id == spice.id {
            spiceToEdit = nil
            updateSpice = false

            recipeVM.spiceName = ""
            recipeVM.spiceAmount = nil
            recipeVM.spiceUnit = "g"
            recipeVM.newSpiceUnit = ""
        }
    }

    func moveSpices(fromOffsets: IndexSet, toOffset: Int, recipeVM: NewRecipeViewModel) {
        recipeVM.spices.move(fromOffsets: fromOffsets, toOffset: toOffset)
        recipeVM.reindexSpices()
    }

    func sortedSpices(_ spices: [Spice]) -> [Spice] {
        spices.sorted { ($0.position ?? 0) < ($1.position ?? 0) }
    }
}
