//
//  CategorySettingsView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 14.01.26.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct CategorySettingsView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var categoryStores: [CategoryStore]
    private var categoryStore: CategoryStore? { categoryStores.first }

    @Query private var recipes: [Recipe]

    @State private var editingCategory: String? = nil
    @State private var draftName: String = ""

    private var categories: [String] {
        categoryStore?.categories ?? []
    }

    var body: some View {
        Group {
            if let store = categoryStore, !store.categories.isEmpty {
                Form {
                    Section("Categories") {
                        ForEach(store.categories, id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                Text("\(recipes.filter( { $0.categories.contains(category) } ).count)")
                                    .padding(.trailing)
                            }
                            .onTapGesture {
                                editingCategory = category
                                draftName = category
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) { deleteCategory(category) } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onMove { indices, newOffset in
                            store.categories.move(fromOffsets: indices, toOffset: newOffset)
                            try? modelContext.save()
                        }
                    }
                }
                .environment(\.editMode, .constant(.active)) // <- kein EditButton nötig
            } else {
                VStack(spacing: 15) {
                    Text("No Categories found...")
                        .fontWeight(.bold)
                        .font(.title)

                    Image(systemName: "x.circle")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                }
                .foregroundStyle(.brandPrimary)
            }
        }
        .navigationTitle("Categories")
        .sheet(item: $editingCategory) { oldName in
            NavigationStack {
                Form {
                    Section("Rename") {
                        TextField("Category name", text: $draftName)
                    }
                }
                .navigationTitle("Edit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            editingCategory = nil
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            renameCategory(old: oldName, new: draftName)
                            editingCategory = nil
                        }
                        .disabled(draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func renameCategory(old: String, new: String) {
        guard let store = categoryStore else { return }

        let trimmed = new.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard trimmed != old else { return }

        // 1) Update store list
        if let idx = store.categories.firstIndex(of: old) {
            store.categories[idx] = trimmed
        }

        // 2) Update all recipes that contain old
        for recipe in recipes {
            if recipe.categories.contains(old) {
                recipe.categories.remove(old)
                recipe.categories.insert(trimmed)
            }
        }

        try? modelContext.save()
    }

    private func deleteCategory(_ category: String) {
        guard let store = categoryStore else { return }

        // 1) Remove from store
        store.categories.removeAll { $0 == category }

        // 2) Remove from all recipes
        for recipe in recipes {
            if recipe.categories.contains(category) {
                recipe.categories.remove(category)
            }
        }

        try? modelContext.save()
    }
}

// Makes String usable as `.sheet(item:)`
extension String: Identifiable {
    public var id: String { self }
}


#Preview {
    CategorySettingsView()
}
