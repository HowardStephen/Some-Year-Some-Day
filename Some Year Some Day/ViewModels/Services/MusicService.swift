import Foundation
import MediaPlayer

final class MusicService {
    static let shared = MusicService()
    private init() {}

    struct TrackRef: Codable, Hashable {
        var id: String
        var title: String?
        var artist: String?
    }

    // best-effort: read recent played items from MPMediaLibrary nowPlayingItem or query last played
    func loadToday(completion: @escaping ([MusicService.TrackRef]) -> Void) {
        // Request permission
        if #available(iOS 16.0, *) {
            let status = MPMediaLibrary.authorizationStatus()
            if status == .authorized {
                _fetchToday(completion: completion)
            } else {
                MPMediaLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        self._fetchToday(completion: completion)
                    } else {
                        completion([])
                    }
                }
            }
        } else {
            completion([])
        }
    }

    private func _fetchToday(completion: @escaping ([MusicService.TrackRef]) -> Void) {
        // Use nowPlayingItem as a lightweight default
        var out: [MusicService.TrackRef] = []
        if let now = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem {
            let id = now.persistentID.description
            out.append(MusicService.TrackRef(id: id, title: now.title, artist: now.artist))
        }
        completion(out)
    }
}
