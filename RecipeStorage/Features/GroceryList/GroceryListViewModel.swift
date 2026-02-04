//
//  GroceryListViewModel.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 04.02.26.
//

import Foundation
import SwiftData


@MainActor
final class GroceryListViewModel: ObservableObject {
    
    //    var entries: [GroceryListEntry] = [
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //        GroceryListEntry(name: "Eier", unit: "Stueck", amount: 3, isChecked: false),
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //        GroceryListEntry(name: "Milch", unit: "ml", amount: 1000, isChecked: false),
    //    ]
    
    @Published var showAddGrocerySheet: Bool = false
    @Published var showDeleteAllDialog: Bool = false
    
    @Published var groceryName: String = ""
    @Published var groceryAmount: Int? = nil
    @Published var groceryUnit: String = ""
}
