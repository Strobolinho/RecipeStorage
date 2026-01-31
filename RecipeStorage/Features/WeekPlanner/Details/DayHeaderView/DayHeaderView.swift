//
//  DayHeaderView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 28.01.26.
//

import SwiftUI

struct DayHeaderView: View {

    @Binding var date: Date

    var body: some View {

        DatePicker("", selection: $date, displayedComponents: [.date])
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .center)
            .scaleEffect(1.2)
    }
}

#Preview {
    DayHeaderView(date: .constant(.now))
}
