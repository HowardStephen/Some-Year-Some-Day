import SwiftUI

struct KeepDiaryMusicView: View {
    @ObservedObject var vm: KeepDiaryViewModel

    var body: some View {
        VStack(spacing: 12) {
            if vm.context.tracks.isEmpty {
                Text("今日无音乐记录")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(vm.context.tracks, id: \.id) { t in
                        HStack {
                            Image(systemName: "music.note")
                            VStack(alignment: .leading) {
                                Text(t.title ?? "未知曲目")
                                Text(t.artist ?? "未知艺术家")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                // toggle selection
                                if let idx = vm.context.tracks.firstIndex(where: { $0.id == t.id }) {
                                    vm.context.tracks.remove(at: idx)
                                    vm.musicSelected = !vm.context.tracks.isEmpty
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("音乐")
    }
}
