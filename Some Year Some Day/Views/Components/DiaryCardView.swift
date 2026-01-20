import SwiftUI

// Model representing the data needed by the diary card UI
public struct DiaryCardModel: Identifiable {
    public var id: UUID = UUID()
    public var moodEmoji: String
    public var moodText: String?
    public var timestamp: Date
    /// system image names for small icons shown on the right-bottom
    public var icons: [String]

    public init(moodEmoji: String, moodText: String? = nil, timestamp: Date, icons: [String] = []) {
        self.moodEmoji = moodEmoji
        self.moodText = moodText
        self.timestamp = timestamp
        self.icons = icons
    }
}

// A small non-interactive liquid-like icon used inside the card
struct DiaryCardIconView: View {
    var systemName: String
    var size: CGFloat = 34

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.45))
            .foregroundColor(Color(.systemGray))
            .frame(width: size, height: size)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.systemGray4).opacity(0.08), lineWidth: 0.6)
            )
    }
}

// The Diary Card UI
public struct DiaryCardView: View {
    public var model: DiaryCardModel

    private var timestampText: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh_CN")
        df.dateFormat = "yyyy年M月d日 HH:mm"
        return df.string(from: model.timestamp)
    }

    public init(model: DiaryCardModel) {
        self.model = model
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Left: mood
            VStack(spacing: 6) {
                Text(model.moodEmoji)
                    .font(.system(size: 36))
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(Color(.systemGray4).opacity(0.08), lineWidth: 0.6))
            }
            .padding(.leading, 12)

            // Right: timestamp (top) and icons (bottom)
            VStack(alignment: .trailing, spacing: 8) {
                Text(timestampText)
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Spacer()
                    ForEach(Array(model.icons.prefix(4)), id: \.self) { name in
                        DiaryCardIconView(systemName: name)
                    }
                }
            }
            .padding(.vertical, 12)

            Spacer(minLength: 8)
        }
        .padding(.trailing, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.systemBackground))
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.systemGray4).opacity(0.06), lineWidth: 0.5)
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    VStack(spacing: 8) {
        DiaryCardView(model: DiaryCardModel(moodEmoji: "😊", timestamp: Date(timeIntervalSince1970: 1705788000), icons: ["music.note", "cloud.sun", "figure.walk", "circlebadge.fill"]))
        DiaryCardView(model: DiaryCardModel(moodEmoji: "😌", timestamp: Date(timeIntervalSince1970: 1705798800), icons: ["sun.max", "music.note", "flame.fill"]))
    }
    .padding()
    .background(Color(.systemGroupedBackground).ignoresSafeArea())
}
