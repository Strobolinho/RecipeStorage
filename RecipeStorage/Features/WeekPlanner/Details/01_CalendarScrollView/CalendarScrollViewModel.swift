//
//  CalendarScrollView.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 17.01.26.
//

import Foundation
import SwiftUI

@MainActor
final class CalendarScrollViewModel: ObservableObject {

    let calendar: Calendar = {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Montag
        return cal
    }()

    private(set) var today: Date = Date()

    var startOfThisWeek: Date {
        calendar.dateInterval(of: .weekOfYear, for: today)!.start
    }

    func weekStarts(range: Range<Int> = -1..<3) -> [Date] {
        range.compactMap { offset in
            calendar.date(byAdding: .weekOfYear, value: offset, to: startOfThisWeek)
        }
    }

    func daysOfWeek(from weekStart: Date) -> [Date] {
        (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStart)
        }
    }

    func isToday(_ day: Date) -> Bool {
        calendar.isDate(day, inSameDayAs: Date())
    }
}
