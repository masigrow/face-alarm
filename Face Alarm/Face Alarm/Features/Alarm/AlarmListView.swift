import SwiftUI

struct AlarmListView: View {
    @State private var alarms: [Alarm] = [
        Alarm(hour: 6, minute: 30, repeatDays: [.mon, .tue, .wed, .thu, .fri], faceEnabled: true, faceDuration: 5),
        Alarm(hour: 8, minute: 0, repeatDays: [.sat, .sun], faceEnabled: true, faceDuration: 3),
        Alarm(hour: 7, minute: 0, repeatDays: Set(Weekday.allCases), isEnabled: false, faceEnabled: false)
    ]
    @State private var showingAddAlarm = false

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach($alarms) { $alarm in
                        AlarmRowView(alarm: $alarm)
                            .listRowBackground(Color(uiColor: .secondarySystemGroupedBackground))
                    }
                    .onDelete { alarms.remove(atOffsets: $0) }
                }
                .navigationTitle("Alarm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddAlarm = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddAlarm) {
                    Text("Alarm settings coming soon")
                }
            }
            .tabItem {
                Label("Alarm", systemImage: "alarm")
            }

            NavigationStack {
                Text("Stats coming soon")
                    .navigationTitle("Stats")
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
        }
    }
}

struct AlarmRowView: View {
    @Binding var alarm: Alarm

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(alarm.timeString)
                        .font(.system(size: 48, weight: .thin))
                        .foregroundStyle(alarm.isEnabled ? .primary : .secondary)
                    if alarm.faceEnabled {
                        Image(systemName: "eye")
                            .font(.system(size: 14))
                            .foregroundStyle(.green)
                            .padding(.top, 8)
                    }
                }
                Text(alarm.repeatLabel + (alarm.faceEnabled ? " · \(alarm.faceDuration)s" : ""))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $alarm.isEnabled)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AlarmListView()
}
