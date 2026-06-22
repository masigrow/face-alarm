import Foundation

struct Alarm: Identifiable, Codable {
    var id: UUID = UUID()
    var hour: Int
    var minute: Int
    var repeatDays: Set<Weekday> = []
    var soundName: String = "Radar"
    var isEnabled: Bool = true
    var snoozeEnabled: Bool = false
    var faceEnabled: Bool = true
    var faceDuration: Int = 5

    var timeString: String {
        String(format: "%d:%02d", hour, minute)
    }

    var repeatLabel: String {
        if repeatDays.isEmpty { return "Once" }
        if repeatDays.count == 7 { return "Every day" }
        return repeatDays.sorted().map(\.shortName).joined(separator: " ")
    }
}

enum Weekday: Int, Codable, Comparable, CaseIterable {
    case sun = 1, mon, tue, wed, thu, fri, sat

    var shortName: String {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][rawValue - 1]
    }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
