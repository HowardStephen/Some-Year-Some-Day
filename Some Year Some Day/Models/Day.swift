//
//  Day.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import Foundation

public struct Day: Identifiable, Hashable {
    public let id: UUID
    public let date: Date
    public var displayText: String {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df.string(from: date)
    }

    public init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}
