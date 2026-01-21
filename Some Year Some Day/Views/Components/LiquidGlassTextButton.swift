//
//  LiquidGlassTextButton.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import SwiftUI

// A text variant of the LiquidGlassButton for small cancel buttons
struct LiquidGlassTextButton: View {
    var text: String
    var systemName: String? = nil
    var height: CGFloat = 36
    var accent: Color? = nil
    var action: () -> Void = {}

    @State private var pressed: Bool = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.75)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) { pressed = false }
                action()
            }
        }) {
            HStack(spacing: 8) {
                if let name = systemName {
                    Image(systemName: name)
                }
                Text(text)
                    .bold()
            }
            .font(.subheadline)
            .foregroundColor(accent != nil ? .white : .primary)
            .frame(height: height)
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: height / 2, style: .continuous).fill(accent ?? Color(UIColor.systemBackground).opacity(0.001)))
        }
        .buttonStyle(.plain)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: height / 2, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                .stroke(accent != nil ? Color.white.opacity(0.9) : Color(.systemGray4).opacity(0.6), lineWidth: 0.6)
        )
        .scaleEffect(pressed ? 0.96 : 1.0)
        .shadow(color: Color.black.opacity(pressed ? 0.03 : 0.08), radius: pressed ? 1.5 : 4, x: 0, y: pressed ? 1 : 2)
    }
}

#Preview {
    LiquidGlassTextButton(text: "取消")
}
