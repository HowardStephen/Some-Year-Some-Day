//
//  Some_Year_Some_DayApp.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/18.
//

import SwiftUI

@main
struct Some_Year_Some_DayApp: App {
    // 使用 AppViewModel 作为根状态容器
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appViewModel.contentViewModel)
                .environmentObject(appViewModel)
        }
    }
}
