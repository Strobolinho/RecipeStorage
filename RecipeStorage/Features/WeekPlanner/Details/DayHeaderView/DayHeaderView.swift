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
        HStack(spacing: 16) {

            DatePicker("", selection: $date, displayedComponents: [.date])
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .center)
                .scaleEffect(1.2)

            // Platzhalter rechts, damit der DatePicker optisch zentriert bleibt
            // (weil links ein Button sitzt)
            Color.clear
                .frame(width: 22, height: 22)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    DayHeaderView(date: .constant(.now))
}
