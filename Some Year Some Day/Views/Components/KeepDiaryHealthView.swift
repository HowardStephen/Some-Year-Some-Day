import SwiftUI

struct KeepDiaryHealthView: View {
    @ObservedObject var vm: KeepDiaryViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if vm.context.healthMetrics.isEmpty {
                    Text("未获取到今日健康数据")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(vm.context.healthMetrics, id: \.id) { m in
                        HStack {
                            Text(m.name)
                            Spacer()
                            Text(m.value)
                                .foregroundColor(.secondary)
                        }
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("健康")
    }
}
