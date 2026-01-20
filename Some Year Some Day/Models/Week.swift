import Foundation

public struct Week: Identifiable, Hashable {
    public let id: UUID
    public let startDate: Date
    public var days: [Day]
    public var label: String {
        let df = DateFormatter()
        df.dateFormat = "M月d日"
        return df.string(from: startDate)
    }

    public init(id: UUID = UUID(), startDate: Date, days: [Day]) {
        self.id = id
        self.startDate = startDate
        self.days = days
    }
}
