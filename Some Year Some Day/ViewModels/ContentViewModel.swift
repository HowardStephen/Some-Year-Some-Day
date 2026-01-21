//
//  ContentViewModel.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import Foundation
import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    // 使用同项目中 ContentView 的日历设置
    private(set) var calendar: Calendar = {
        var c = Calendar.current
        c.firstWeekday = 2
        return c
    }()

    // Core date state
    @Published var today: Date = Date()
    @Published var selectedDate: Date? = nil
    @Published var referenceDate: Date = Date()

    // Date picker UI
    @Published var showDatePicker: Bool = false
    @Published var pickerDate: Date = Date() {
        didSet {
            // ensure pickerDate not greater than now
            let now = Date()
            if pickerDate > now {
                DispatchQueue.main.async { [weak self] in self?.pickerDate = now }
            }
        }
    }

    // Search UI state
    @Published var isSearching: Bool = false
    @Published var searchText: String = ""

    // Diary list + selection
    @Published var diaryEntries: [DiaryCardModel] = []
    @Published var selectedDiary: DiaryCardModel? = nil
    @Published var showDiaryDetail: Bool = false

    // Filtered diary entries for UI: only show entries matching the currently displayed date
    var displayedDate: Date { selectedDate ?? referenceDate }
    var diaryEntriesForDisplayedDate: [DiaryCardModel] {
        diaryEntries.filter { calendar.isDate($0.timestamp, inSameDayAs: displayedDate) }
    }

    var weekDays: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    // MARK: - Date helpers
    func dayLabel(for date: Date) -> String {
        if calendar.isDateInToday(date) { return "今" }
        let symbols = ["一","二","三","四","五","六","日"]
        let wd = calendar.component(.weekday, from: date)
        let index = (wd + 7 - calendar.firstWeekday) % 7
        return symbols[index]
    }

    func dayNumber(for date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df.string(from: date)
    }

    func isToday(_ date: Date) -> Bool { calendar.isDate(date, inSameDayAs: today) }
    func isSelected(_ date: Date) -> Bool {
        if let s = selectedDate { return calendar.isDate(s, inSameDayAs: date) }
        return false
    }

    func shouldHighlight(_ date: Date) -> Bool {
        if selectedDate != nil { return isSelected(date) }
        return isToday(date)
    }

    // MARK: - Actions
    func select(date: Date) {
        // Normalize to start of day to keep comparisons consistent
        let normalized = calendar.startOfDay(for: date)
        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
            selectedDate = normalized
            referenceDate = normalized
        }
    }

    func openDatePicker(initial: Date? = nil) {
        pickerDate = initial ?? selectedDate ?? referenceDate
        showDatePicker = true
    }

    func confirmDatePicker() {
        referenceDate = pickerDate
        selectedDate = pickerDate
        showDatePicker = false
    }

    // Jump to today's start-of-day and update state
    func goToToday() {
        let todayStart = calendar.startOfDay(for: Date())
        today = todayStart
        select(date: todayStart)
    }

    // MARK: - Search helpers
    func startSearch() {
        withAnimation(.easeInOut) { isSearching = true }
    }

    func cancelSearch() {
        withAnimation(.easeInOut) {
            isSearching = false
            searchText = ""
        }
    }

    // MARK: - Diary helpers
    func openDiaryDetail(_ diary: DiaryCardModel) {
        selectedDiary = diary
        showDiaryDetail = true
    }

    func closeDiaryDetail() {
        showDiaryDetail = false
        selectedDiary = nil
    }

    private func loadSampleEntries() {
        let base = Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 14, minute: 0)) ?? Date()
        diaryEntries = [
            DiaryCardModel(moodEmoji: "😊", moodText: "开心", timestamp: base, icons: ["music.note", "cloud.sun", "figure.walk", "circlebadge.fill"]),
            DiaryCardModel(moodEmoji: "😌", moodText: "平静", timestamp: Calendar.current.date(byAdding: .hour, value: -3, to: base) ?? base, icons: ["sun.max", "music.note", "flame.fill"]),
            DiaryCardModel(moodEmoji: "😴", moodText: "困倦", timestamp: Calendar.current.date(byAdding: .day, value: -1, to: base) ?? base, icons: ["bed.double", "moon.stars"])        ]
    }

    // MARK: - Init
    init() {
        self.selectedDate = today
        self.referenceDate = today
        self.pickerDate = today
        loadSampleEntries()
    }
}
