import SwiftUI

struct KeepDiaryCalendarView: View {
    @ObservedObject var vm: KeepDiaryViewModel

    var body: some View {
        List(vm.context.events, id: \.id) { e in
            HStack {
                VStack(alignment: .leading) {
                    Text(e.title)
                    Text(DateFormatter.localizedString(from: e.startDate, dateStyle: .none, timeStyle: .short))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    if let idx = vm.context.events.firstIndex(where: { $0.id == e.id }) {
                        vm.context.events.remove(at: idx)
                        vm.eventsSelected = !vm.context.events.isEmpty
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .navigationTitle("日程")
    }
}
