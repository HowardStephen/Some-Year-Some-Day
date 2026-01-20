import Foundation
import SwiftUI
import Combine

final class AppViewModel: ObservableObject {
    @Published var contentViewModel: ContentViewModel

    init() {
        self.contentViewModel = ContentViewModel()
    }
}
