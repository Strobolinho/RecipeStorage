//
//  WeekPlannerView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 22.12.25.
//

import SwiftUI

struct WeekPlannerView: View {

    @StateObject private var viewModel = CalendarScrollViewModel()

    var body: some View {
        GeometryReader { geo in
            VStack {
                CalendarScrollView(viewModel: viewModel, width: geo.size.width)

                Spacer()
            }
        }
    }
}

#Preview {
    WeekPlannerView()
}
