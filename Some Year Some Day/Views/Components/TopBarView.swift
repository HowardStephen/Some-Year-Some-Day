import SwiftUI

// 顶部栏组件：左/右 LiquidGlass 按钮 + 居中标题
struct TopBarView: View {
    var leftAction: () -> Void
    var rightAction: () -> Void
    var title: String = "日记"

    // Search mode bindings
    var isSearching: Bool = false
    var searchText: Binding<String>? = nil
    var onCancel: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center) {
            if !isSearching {
                // 左上角：原始的圆形 Liquid glass 按钮
                LiquidGlassButton(systemName: "calendar", size: 52, isCircular: true) {
                    leftAction()
                }
            }
            Spacer()

            if isSearching, let binding = searchText {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.systemGray))
                    FocusTextField(text: binding, isFirstResponder: true, placeholder: "搜索")
                }
                .padding(.horizontal, 12)
                .frame(height: 52)
                // 更不透明的背景：使用 secondarySystemBackground 并接近不透明以减少透出底层内容
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(UIColor.secondarySystemBackground).opacity(0.98)))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color(.systemGray4).opacity(0.7), lineWidth: 0.6))
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 2)
                .frame(maxWidth: .infinity)
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
            }

            Spacer()

            if isSearching {
                // 右侧取消按钮（liquid glass 文本按钮）
                LiquidGlassTextButton(text: "取消", height: 52, accent: nil) {
                    onCancel?()
                }
                .frame(height: 52)
                .padding(.leading, 8)
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 2)
            } else {
                // 右侧：搜索按钮
                LiquidGlassButton(systemName: "magnifyingglass", size: 52, isCircular: true) {
                    rightAction()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
    }
}

#Preview {
    TopBarView(leftAction: {}, rightAction: {}, title: "日记")
}
