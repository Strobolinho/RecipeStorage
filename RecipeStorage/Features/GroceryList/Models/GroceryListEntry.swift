//
//  GroceryList.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 01.02.26.
//

import SwiftData
import Foundation

@Model
final class GroceryListEntry {
    var id: UUID = UUID()
    
    var name: String = ""
    
    var unit: String = ""
    
    var amount: Int? = nil
    var isChecked: Bool = false

    init(name: String, unit: String, amount: Int, isChecked: Bool = false) {
        self.id = UUID()
        
        self.name = name
        self.unit = unit
        self.amount = amount
        self.isChecked = isChecked
    }
    
    func check() {
        self.isChecked.toggle()
    }
}
