//
//  DateHeaderView.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/21.
//

import SwiftUI

// A small header row that shows the currently displayed date and a "回到今天" button.
struct DateHeaderView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        HStack(alignment: .center) {
            Text({
                let df = DateFormatter()
                df.locale = Locale(identifier: "zh_CN")
                df.dateFormat = "yyyy年M月d日"
                let d = viewModel.selectedDate ?? viewModel.referenceDate
                return df.string(from: d)
            }())
            .font(.subheadline)
            .foregroundColor(.secondary)

            Spacer()

            Button(action: {
                // Use ViewModel helper to go to today's start-of-day
                if let _ = Optional.some(()) {
                    // Prefer goToToday if available
                    viewModel.goToToday()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrowshape.turn.up.backward")
                    Text("回到今天")
                        .bold()
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        // slight lift to match previous placement
        .offset(y: -12)
    }
}

#Preview {
    DateHeaderView(viewModel: ContentViewModel())
}
