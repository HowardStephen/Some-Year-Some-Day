import Foundation
import CoreLocation

final class MapService: NSObject, CLLocationManagerDelegate {
    static let shared = MapService()
    private override init() { super.init() }

    private let locationManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?

    func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.first)
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        completion = nil
    }
}
