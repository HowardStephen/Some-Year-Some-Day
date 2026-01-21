//
//  AppViewModel.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import Foundation
import SwiftUI
import Combine

final class AppViewModel: ObservableObject {
    @Published var contentViewModel: ContentViewModel

    init() {
        self.contentViewModel = ContentViewModel()
    }
}
