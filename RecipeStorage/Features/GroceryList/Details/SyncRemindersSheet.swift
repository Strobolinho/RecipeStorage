//
//  SyncRemindersSheet.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 12.02.26.
//

import SwiftUI

struct SyncRemindersSheet: View {
    
    @ObservedObject var viewModel: GroceryListViewModel
    
    var body: some View {
        
        VStack {
            Text("Sync Reminder List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
                    .padding(.top)
            
            Form {
                if !viewModel.lists.isEmpty {
                    
                    Section {
                        Picker("Reminder List", selection: $viewModel.selectedListID) {
                            ForEach(viewModel.lists, id: \.calendarIdentifier) { list in
                                Text(list.title).tag(Optional(list.calendarIdentifier))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .fontWeight(.semibold)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal)
                        .onChange(of: viewModel.selectedListID) { _, _ in
                            Task { await viewModel.reloadRemindersForSelection() }
                        }
                    }
                    
                    Section {
                        Button {
                            
                        } label: {
                            Text("Sync")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .scrollDisabled(true)
            .presentationDetents([.height(220)])
            .padding(.top, -30)
        }
    }
}

#Preview {
    SyncRemindersSheet(viewModel: GroceryListViewModel())
}
