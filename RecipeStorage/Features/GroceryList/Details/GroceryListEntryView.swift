//
//  GroceryListEntryView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 04.02.26.
//

import SwiftUI

struct GroceryListEntryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var entry: GroceryListEntry
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.snappy) {
                    entry.check()
                }
            } label: {
                Image(systemName: entry.isChecked ? "checkmark.circle.fill" : "circle")
            }
            .tint(.brandPrimary)
            
            Text(entry.name)
            Spacer()
            Text("\(String(describing: entry.amount!)) \(entry.unit)")
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                modelContext.delete(entry)
                do { try modelContext.save() }
                catch { print("❌ save failed:", error) }
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

#Preview {
    List {
        GroceryListEntryView(entry: GroceryListEntry(name: "Eier", unit: "Stueck", amount: 3, isChecked: false))
    }
}
