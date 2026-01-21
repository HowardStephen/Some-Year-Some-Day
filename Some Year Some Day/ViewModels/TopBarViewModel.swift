//
//  TopBarViewModel.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import Foundation
import SwiftUI
import Combine

final class TopBarViewModel: ObservableObject {
    @Published var title: String = "日记"
    @Published var subtitle: String? = nil

    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}

    init(title: String = "日记", leftAction: @escaping () -> Void = {}, rightAction: @escaping () -> Void = {}) {
        self.title = title
        self.leftAction = leftAction
        self.rightAction = rightAction
    }

    func primaryLeft() { leftAction() }
    func primaryRight() { rightAction() }
}
