//
//  CalendarScrollView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 17.01.26.
//

import SwiftUI

struct CalendarScrollView: View {
    
    @ObservedObject var viewModel: CalendarScrollViewModel
    let width: CGFloat
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.weekStarts(), id: \.self) { weekStart in
                        let weekDays = viewModel.daysOfWeek(from: weekStart)

                        HStack(spacing: 20) {
                            ForEach(weekDays, id: \.self) { day in
                                let dayName = day.formatted(.dateTime.weekday(.abbreviated))
                                let dayNumber = day.formatted(.dateTime.day())
                                let isToday = viewModel.isToday(day)

                                VStack(spacing: 10) {
                                    Text(dayName)
                                    Text(dayNumber)
                                        .background {
                                            if isToday {
                                                Circle()
                                                    .frame(width: 35, height: 35)
                                                    .foregroundStyle(.brandPrimary)
                                                    .opacity(0.3)
                                            }
                                        }
                                }
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.brandPrimary)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(width: width, alignment: .leading)
                        .id(weekStart)
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 80)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onAppear {
                DispatchQueue.main.async {
                    scrollProxy.scrollTo(viewModel.startOfThisWeek, anchor: .leading)
                }
            }
        }
    }
}

#Preview {
    CalendarScrollView(viewModel: CalendarScrollViewModel(), width: 390)
}
