//
//  GroceryListView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.02.26.
//

import SwiftUI
import SwiftData

struct GroceryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var entries: [GroceryListEntry]

    var openItems: [GroceryListEntry] { entries.filter { !$0.isChecked } }
    var collectedItems: [GroceryListEntry] { entries.filter { $0.isChecked } }

    var body: some View {
        List {
            Section("Open Items") {
                ForEach(openItems) { entry in
                    GroceryListEntryView(entry: entry)
                }
            }

            Section("Collected Items") {
                ForEach(collectedItems) { entry in
                    GroceryListEntryView(entry: entry)
                }
            }
        }
    }
}

#Preview {
    GroceryListView(entries: [
        GroceryListEntry(name: "Hähnchen", unit: "g", amount: 100),
        GroceryListEntry(name: "Milch", unit: "ml", amount: 120),
        GroceryListEntry(name: "Eier", unit: "Stück", amount: 3)
    ])
}
