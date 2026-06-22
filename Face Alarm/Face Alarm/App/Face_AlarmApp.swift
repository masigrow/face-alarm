import SwiftUI
import UserNotifications
import Combine

@main
struct Face_AlarmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @ObservedObject var state = AppState.shared

    var body: some View {
        AlarmListView()
            .task {
                _ = await AlarmScheduler.shared.requestPermission()
            }
            .sheet(item: $state.firingAlarm) { entry in
                if entry.alarm.faceEnabled {
                    FaceUnlockView(alarm: entry.alarm, firingTime: entry.firingTime)
                        .interactiveDismissDisabled()
                }
            }
    }
}

final class AppState: ObservableObject {
    static let shared = AppState()
    @Published var firingAlarm: FiringEntry?
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.sound, .banner]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let info = response.notification.request.content.userInfo
        let faceEnabled = info["faceEnabled"] as? Bool ?? false
        guard faceEnabled else { return }
        var alarm = Alarm(hour: 0, minute: 0)
        alarm.faceEnabled = true
        DispatchQueue.main.async {
            AppState.shared.firingAlarm = FiringEntry(alarm: alarm, firingTime: .now)
        }
    }
}

struct FiringEntry: Identifiable {
    let id = UUID()
    let alarm: Alarm
    let firingTime: Date
}
