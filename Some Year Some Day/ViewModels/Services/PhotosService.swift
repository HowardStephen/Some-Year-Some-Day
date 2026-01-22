import Foundation
import Photos

final class PhotosService {
    static let shared = PhotosService()
    private init() {}

    // returns localIdentifiers of PHAssets taken today
    func loadToday(completion: @escaping ([String]) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        guard status == .authorized || status == .limited else {
            // request authorization
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self._fetchToday(completion: completion)
                } else {
                    completion([])
                }
            }
            return
        }
        _fetchToday(completion: completion)
    }

    private func _fetchToday(completion: @escaping ([String]) -> Void) {
        let fetchOptions = PHFetchOptions()
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@", start as NSDate)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: fetchOptions)
        var ids: [String] = []
        result.enumerateObjects { asset, _, _ in
            ids.append(asset.localIdentifier)
        }
        completion(ids)
    }
}
