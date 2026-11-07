import Foundation

enum IslandConfiguration {
    static let activityName = "PersistentIsland"
    static let deepLink = URL(string: "persistentisland://activity")!
    static let limitationText = "PersistentIsland uses Live Activities. iOS controls when activities appear and how long they remain active. Permanent visibility cannot be guaranteed."
}

