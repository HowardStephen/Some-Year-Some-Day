import SwiftUI

struct KeepDiaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = KeepDiaryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Top module selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    KeepModuleButton(title: "照片", systemName: "photo.on.rectangle") {
                        // open photos picker
                    }
                    KeepModuleButton(title: "音乐", systemName: "music.note") {
                        // open music picker
                    }
                    KeepModuleButton(title: "健康", systemName: "heart.circle") {
                        // open health view
                    }
                    KeepModuleButton(title: "地图", systemName: "map") {
                        // open map picker
                    }
                    KeepModuleButton(title: "日程", systemName: "calendar") {
                        // open calendar picker
                    }
                }
                .padding()
            }

            Divider()

            // Editor area
            VStack(spacing: 12) {
                TextField("标题（可选）", text: Binding(get: { viewModel.context.title ?? "" }, set: { viewModel.context.title = $0 }))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                TextEditor(text: Binding(get: { viewModel.context.body ?? "" }, set: { viewModel.context.body = $0 }))
                    .frame(height: 160)
                    .padding(.horizontal)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4).opacity(0.2)))

                // Modules selection summary
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("已选择：")
                        Text(viewModel.photosSelected ? "照片" : "")
                        Text(viewModel.musicSelected ? " 音乐" : "")
                        Text(viewModel.healthSelected ? " 健康" : "")
                        Text(viewModel.locationsSelected ? " 地点" : "")
                        Text(viewModel.eventsSelected ? " 日程" : "")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Spacer()
            }

            Spacer()

            // Bottom confirm/cancel
            HStack {
                LiquidGlassTextButton(text: "✘", systemName: nil) {
                    viewModel.cancel()
                    dismiss()
                }
                .padding(.leading, 20)

                Spacer()

                LiquidGlassButton(systemName: "checkmark", size: 56, isCircular: true, accent: Color.accentColor) {
                    viewModel.confirm()
                    dismiss()
                }
                .disabled(!viewModel.canConfirm)
                .padding(.trailing, 20)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("记录今日")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showDiscardAlert) {
            Alert(title: Text("放弃记录?"), message: Text("你将丢失当前编辑内容"), primaryButton: .destructive(Text("放弃"), action: {
                viewModel.discardChanges()
                dismiss()
            }), secondaryButton: .cancel())
        }
        .onAppear {
            viewModel.loadDefaults()
        }
    }
}

struct KeepModuleButton: View {
    var title: String
    var systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemName)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                Text(title)
                    .font(.caption)
            }
        }
        .buttonStyle(.plain)
    }
}
