import UserNotifications
import AVFoundation

final class AlarmScheduler {
    static let shared = AlarmScheduler()
    private init() {}

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    func schedule(_ alarm: Alarm) {
        cancel(alarm)
        guard alarm.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Face Alarm"
        content.body = alarm.faceEnabled
            ? "Open your eyes to dismiss"
            : "Tap to dismiss"
        content.sound = .defaultCritical
        content.userInfo = ["alarmId": alarm.id.uuidString, "faceEnabled": alarm.faceEnabled]
        content.interruptionLevel = .timeSensitive

        if alarm.repeatDays.isEmpty {
            var components = DateComponents()
            components.hour = alarm.hour
            components.minute = alarm.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: alarm.id.uuidString,
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request)
        } else {
            for day in alarm.repeatDays {
                var components = DateComponents()
                components.weekday = day.rawValue
                components.hour = alarm.hour
                components.minute = alarm.minute
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "\(alarm.id.uuidString)-\(day.rawValue)",
                    content: content,
                    trigger: trigger
                )
                UNUserNotificationCenter.current().add(request)
            }
        }
    }

    func cancel(_ alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        let ids = alarm.repeatDays.isEmpty
            ? [alarm.id.uuidString]
            : alarm.repeatDays.map { "\(alarm.id.uuidString)-\($0.rawValue)" }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
