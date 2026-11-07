import SwiftUI

@main
struct PersistentIslandApp: App {
    @StateObject private var activityManager = ActivityManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(activityManager)
                .onOpenURL { _ in
                    Task { await activityManager.refresh() }
                }
        }
    }
}

