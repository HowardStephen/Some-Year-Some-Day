import Foundation
import HealthKit

final class HealthService {
    static let shared = HealthService()
    private init() {}

    struct Metric: Codable, Hashable {
        var id: String
        var name: String
        var value: String
    }

    private let store = HKHealthStore()

    func loadToday(completion: @escaping ([DiaryContext.HealthMetric]) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else { completion([]); return }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let start = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            var metrics: [DiaryContext.HealthMetric] = []
            if let sum = result?.sumQuantity() {
                let value = Int(sum.doubleValue(for: HKUnit.count()))
                metrics.append(DiaryContext.HealthMetric(id: "steps", name: "steps", value: "\(value)"))
            }
            completion(metrics)
        }
        store.requestAuthorization(toShare: [], read: [stepType]) { success, _ in
            if success {
                self.store.execute(query)
            } else {
                completion([])
            }
        }
    }
}
