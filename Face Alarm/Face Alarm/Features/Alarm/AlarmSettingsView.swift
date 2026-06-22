import SwiftUI

struct AlarmSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var alarm: Alarm
    var onSave: (Alarm) -> Void

    @State private var draft: Alarm

    init(alarm: Binding<Alarm>, onSave: @escaping (Alarm) -> Void) {
        self._alarm = alarm
        self.onSave = onSave
        self._draft = State(initialValue: alarm.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Time picker
                Section {
                    HStack(spacing: 0) {
                        Picker("Hour", selection: $draft.hour) {
                            ForEach(0..<24, id: \.self) { h in
                                Text(String(format: "%d", h)).tag(h)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)

                        Text(":")
                            .font(.title2)
                            .padding(.bottom, 2)

                        Picker("Minute", selection: $draft.minute) {
                            ForEach(0..<60, id: \.self) { m in
                                Text(String(format: "%02d", m)).tag(m)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 150)
                }

                // Repeat days
                Section("Repeat") {
                    HStack(spacing: 6) {
                        ForEach(Weekday.allCases, id: \.self) { day in
                            let selected = draft.repeatDays.contains(day)
                            Button(day.shortName) {
                                if selected {
                                    draft.repeatDays.remove(day)
                                } else {
                                    draft.repeatDays.insert(day)
                                }
                            }
                            .buttonStyle(.plain)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(selected ? Color.accentColor : Color(uiColor: .tertiarySystemFill))
                            .foregroundStyle(selected ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Sound
                Section("Sound") {
                    Picker("Sound", selection: $draft.soundName) {
                        ForEach(["Radar", "Chimes", "Ripple", "Sencha"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }

                // Snooze & Face
                Section("Options") {
                    Toggle("Snooze", isOn: $draft.snoozeEnabled)
                        .onChange(of: draft.snoozeEnabled) {
                            if draft.snoozeEnabled { draft.faceEnabled = false }
                        }

                    Toggle(isOn: $draft.faceEnabled) {
                        Label("Face Feature", systemImage: "eye")
                    }
                    .tint(.green)
                    .onChange(of: draft.faceEnabled) {
                        if draft.faceEnabled { draft.snoozeEnabled = false }
                    }

                    if draft.faceEnabled {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Eyes open duration")
                                Spacer()
                                Text("\(draft.faceDuration)s")
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: Binding(
                                get: { Double(draft.faceDuration) },
                                set: { draft.faceDuration = Int($0) }
                            ), in: 3...10, step: 1)
                            .tint(.green)
                            HStack {
                                Text("3s").font(.caption).foregroundStyle(.secondary)
                                Spacer()
                                Text("10s").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Add Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var alarm = Alarm(hour: 7, minute: 0)
    AlarmSettingsView(alarm: $alarm) { _ in }
}
