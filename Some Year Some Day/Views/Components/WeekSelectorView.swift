import SwiftUI

struct WeekSelectorView: View {
    let weekDays: [Date]
    let selectedDate: Date?
    var onSelect: (Date) -> Void

    var calendar: Calendar = Calendar.current

    private func dayLabel(for date: Date) -> String {
        // 如果是今天，显示 "今"，否则返回中文单字：一..日（基于 calendar.firstWeekday）
        if calendar.isDateInToday(date) { return "今" }
        let symbols = ["一","二","三","四","五","六","日"]
        let wd = calendar.component(.weekday, from: date) // 1 = Sun, 2 = Mon, ...
        let index = (wd + 7 - calendar.firstWeekday) % 7
        return symbols[index]
    }

    private func dayNumber(for date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df.string(from: date)
    }

    private func shouldHighlight(_ date: Date) -> Bool {
        if let s = selectedDate { return calendar.isDate(s, inSameDayAs: date) }
        return calendar.isDateInToday(date)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(weekDays, id: \.self) { date in
                        Button(action: { onSelect(date) }) {
                            VStack(spacing: 4) {
                                Text(dayLabel(for: date))
                                    .font(.caption)
                                    .foregroundColor(shouldHighlight(date) ? Color.white.opacity(0.9) : .secondary)
                                Text(dayNumber(for: date))
                                    .font(.subheadline).bold()
                                    .foregroundColor(shouldHighlight(date) ? .white : .primary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(shouldHighlight(date) ? Color.accentColor : Color(UIColor.secondarySystemBackground))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .id(date)
                    }
                }
                .padding(.vertical, 16)
                .padding(.trailing, 6)
            }
            .onAppear {
                if let s = selectedDate, let match = weekDays.first(where: { calendar.isDate($0, inSameDayAs: s) }) {
                    withAnimation { proxy.scrollTo(match, anchor: .center) }
                } else if !weekDays.isEmpty {
                    let mid = weekDays[weekDays.count / 2]
                    withAnimation { proxy.scrollTo(mid, anchor: .center) }
                }
            }
            .onChange(of: weekDays) { new, _ in
                if let s = selectedDate, let match = new.first(where: { calendar.isDate($0, inSameDayAs: s) }) {
                    withAnimation { proxy.scrollTo(match, anchor: .center) }
                } else if !new.isEmpty {
                    let mid = new[new.count / 2]
                    withAnimation { proxy.scrollTo(mid, anchor: .center) }
                }
            }
            .onChange(of: selectedDate) { new, _ in
                if let s = new, let match = weekDays.first(where: { calendar.isDate($0, inSameDayAs: s) }) {
                    withAnimation { proxy.scrollTo(match, anchor: .center) }
                }
            }
        }
        .frame(maxWidth: 360)
    }
}
