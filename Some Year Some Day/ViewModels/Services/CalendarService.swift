import Foundation
import EventKit

final class CalendarService {
    static let shared = CalendarService()
    private init() {}

    struct EventRef: Codable, Hashable {
        var id: String
        var title: String
        var startDate: Date
        var endDate: Date
        var location: String?
    }

    private let store = EKEventStore()

    func loadToday(completion: @escaping ([DiaryContext.EventRef]) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .authorized {
            _fetchToday(completion: completion)
            return
        }
        store.requestAccess(to: .event) { granted, _ in
            if granted {
                self._fetchToday(completion: completion)
            } else {
                completion([])
            }
        }
    }

    private func _fetchToday(completion: @escaping ([DiaryContext.EventRef]) -> Void) {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = store.events(matching: predicate)
        let refs = events.map { e in
            DiaryContext.EventRef(id: e.eventIdentifier, title: e.title, startDate: e.startDate, endDate: e.endDate, location: e.location)
        }
        completion(refs)
    }
}
