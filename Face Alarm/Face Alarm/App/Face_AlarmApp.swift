import SwiftUI

@main
struct Face_AlarmApp: App {
    var body: some Scene {
        WindowGroup {
            AlarmListView()
                .task {
                    _ = await AlarmScheduler.shared.requestPermission()
                }
        }
    }
}
