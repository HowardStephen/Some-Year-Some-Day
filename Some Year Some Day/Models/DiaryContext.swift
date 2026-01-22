import Foundation
import CoreLocation

// Lightweight, serializable container that aggregates selected data from modules.
public struct DiaryContext: Identifiable, Codable {
    public var id: UUID = UUID()
    public var date: Date
    public var title: String?
    public var body: String?

    // Photos: PHAsset local identifiers (convertible later to UIImage/URL)
    public var photoIDs: [String]

    // Music: simple metadata reference
    public struct TrackRef: Codable, Hashable, Identifiable {
        public var id: String
        public var title: String?
        public var artist: String?
    }
    public var tracks: [TrackRef]

    // Health: simple metric placeholder
    public struct HealthMetric: Codable, Hashable, Identifiable {
        public var id: String
        public var name: String
        public var value: String
    }
    public var healthMetrics: [HealthMetric]

    // Locations
    public struct LocationRef: Codable, Hashable, Identifiable {
        public var id: String
        public var name: String?
        public var latitude: Double
        public var longitude: Double
    }
    public var locations: [LocationRef]

    // Calendar events
    public struct EventRef: Codable, Hashable, Identifiable {
        public var id: String
        public var title: String
        public var startDate: Date
        public var endDate: Date
        public var location: String?
    }
    public var events: [EventRef]

    public init(date: Date = Date(), title: String? = nil, body: String? = nil, photoIDs: [String] = [], tracks: [TrackRef] = [], healthMetrics: [HealthMetric] = [], locations: [LocationRef] = [], events: [EventRef] = []) {
        self.date = date
        self.title = title
        self.body = body
        self.photoIDs = photoIDs
        self.tracks = tracks
        self.healthMetrics = healthMetrics
        self.locations = locations
        self.events = events
    }
}
