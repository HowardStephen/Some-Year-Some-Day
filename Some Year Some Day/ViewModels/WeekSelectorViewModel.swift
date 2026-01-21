//
//  WeekSelectorViewModel.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import Foundation
import SwiftUI
import Combine

final class WeekSelectorViewModel: ObservableObject {
    @Published var weekDays: [Date] = []
    @Published var selectedDate: Date? = nil
    var calendar: Calendar = Calendar.current

    var onSelect: ((Date) -> Void)?

    init(weekDays: [Date] = [], selectedDate: Date? = nil, calendar: Calendar = Calendar.current) {
        self.weekDays = weekDays
        self.selectedDate = selectedDate
        self.calendar = calendar
    }

    func tap(date: Date) {
        onSelect?(date)
    }
}
