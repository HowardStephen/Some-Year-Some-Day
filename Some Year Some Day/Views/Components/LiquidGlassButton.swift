//
//  LiquidGlassButton.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/18.
//

import SwiftUI

// 可复用的 Liquid glass 风格按钮（支持圆形与圆角矩形）
// 从 ContentView 中抽离出来，便于复用与测试
public struct LiquidGlassButton: View {
    public var systemName: String
    public var size: CGFloat = 60
    public var isCircular: Bool = true
    public var accent: Color? = nil
    public var action: () -> Void = {}

    // 点击反馈状态
    @State private var pressed: Bool = false

    public init(systemName: String, size: CGFloat = 60, isCircular: Bool = true, accent: Color? = nil, action: @escaping () -> Void = {}) {
        self.systemName = systemName
        self.size = size
        self.isCircular = isCircular
        self.accent = accent
        self.action = action
    }

    @ViewBuilder
    private func circularButton() -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.75)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) { pressed = false }
                action()
            }
        }) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .regular))
                .foregroundColor(accent != nil ? .white : Color(.systemGray))
                .frame(width: size, height: size)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        // 圆形填充（有 accent 时有色，否则透明）
        .background(Circle().fill(accent ?? Color.clear))
        // 在圆形内应用毛玻璃材质，避免矩形溢出
        .background(.ultraThinMaterial, in: Circle())
        .overlay(
            Circle()
                .stroke(accent != nil ? Color.white.opacity(0.9) : Color(.systemGray4).opacity(0.6), lineWidth: 0.6)
        )
        .overlay(
            Circle()
                .trim(from: 0.0, to: 0.5)
                .rotation(Angle(degrees: -180))
                .stroke(LinearGradient(colors: [Color.white.opacity(0.85), Color.white.opacity(0.0)], startPoint: .top, endPoint: .bottom), lineWidth: 1.0)
                .blendMode(.screen)
                .offset(y: -2)
        )
        .overlay(
            Circle()
                .inset(by: 0.8)
                .stroke(Color.black.opacity(0.06), lineWidth: 1.0)
                .blendMode(.multiply)
                .offset(y: 1)
        )
        .clipShape(Circle())
        .scaleEffect(pressed ? 0.96 : 1.0)
        .shadow(color: Color.black.opacity(pressed ? 0.03 : 0.08), radius: pressed ? 1.5 : 4, x: 0, y: pressed ? 1 : 2)
    }

    @ViewBuilder
    private func roundedButton() -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.75)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) { pressed = false }
                action()
            }
        }) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .regular))
                .foregroundColor(accent != nil ? .white : Color(.systemGray))
                .frame(width: size, height: size)
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(accent ?? Color(.systemBackground).opacity(0.06)))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(LinearGradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.8)
                .blendMode(.overlay)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .scaleEffect(pressed ? 0.96 : 1.0)
        .shadow(color: Color.black.opacity(pressed ? 0.03 : 0.08), radius: pressed ? 1.5 : 4, x: 0, y: pressed ? 1 : 2)
    }

    public var body: some View {
        if isCircular {
            circularButton()
        } else {
            roundedButton()
        }
    }
}

#Preview {
    LiquidGlassButton(systemName: "calendar")
}
