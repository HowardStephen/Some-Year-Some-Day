import SwiftUI
import Combine

final class KeepDiaryViewModel: ObservableObject {
    @Published var context: DiaryContext = DiaryContext(date: Date())

    // Module selection states
    @Published var photosSelected: Bool = false
    @Published var musicSelected: Bool = false
    @Published var healthSelected: Bool = false
    @Published var locationsSelected: Bool = false
    @Published var eventsSelected: Bool = false

    // UI state
    @Published var isSaving: Bool = false
    @Published var showDiscardAlert: Bool = false

    // Services placeholders - in-app adapters to platform frameworks
    // We'll provide simple APIs so the UI can call loadToday..
    var photosService = PhotosService.shared
    var musicService = MusicService.shared
    var healthService = HealthService.shared
    var mapService = MapService.shared
    var calendarService = CalendarService.shared

    private var cancellables = Set<AnyCancellable>()

    init() {
        // load defaults
        loadDefaults()

        // observe selection flags to update canConfirm if needed
        Publishers.CombineLatest3($photosSelected, $musicSelected, $eventsSelected)
            .sink { [weak self] p, m, e in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func loadDefaults() {
        // Load today's data for each module (best-effort, async)
        let today = Calendar.current.startOfDay(for: Date())
        context.date = today

        photosService.loadToday { assets in
            DispatchQueue.main.async {
                self.context.photoIDs = assets
                self.photosSelected = !assets.isEmpty
            }
        }

        musicService.loadToday { tracks in
            DispatchQueue.main.async {
                // Map MusicService.TrackRef to DiaryContext.TrackRef
                self.context.tracks = tracks.map { DiaryContext.TrackRef(id: $0.id, title: $0.title, artist: $0.artist) }
                self.musicSelected = !self.context.tracks.isEmpty
            }
        }

        healthService.loadToday { metrics in
            DispatchQueue.main.async {
                self.context.healthMetrics = metrics
                self.healthSelected = !metrics.isEmpty
            }
        }

        calendarService.loadToday { events in
            DispatchQueue.main.async {
                self.context.events = events
                self.eventsSelected = !events.isEmpty
            }
        }

        // Map defaults: not auto-select any location, but can set current location
    }

    var canConfirm: Bool {
        // At least one module must be selected, or a non-empty title/body
        let hasText = (context.title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false) || (context.body?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
        return hasText || photosSelected || musicSelected || healthSelected || locationsSelected || eventsSelected
    }

    func confirm() {
        guard canConfirm else { return }
        isSaving = true
        // Build DiaryEntry or pass to repository - for now we just simulate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isSaving = false
            // In real app we'd persist and notify AppViewModel
        }
    }

    func cancel() {
        // If context empty, allow immediate dismiss. Else show discard alert
        let hasAny = (context.title?.isEmpty == false) || (context.body?.isEmpty == false) || photosSelected || musicSelected || healthSelected || locationsSelected || eventsSelected
        if hasAny {
            showDiscardAlert = true
        } else {
            // caller should dismiss
        }
    }

    func discardChanges() {
        // reset
        context = DiaryContext(date: Calendar.current.startOfDay(for: Date()))
        photosSelected = false
        musicSelected = false
        healthSelected = false
        locationsSelected = false
        eventsSelected = false
    }
}
