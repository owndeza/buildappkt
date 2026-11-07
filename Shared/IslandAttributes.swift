import ActivityKit
import Foundation

struct IslandAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var isRunning: Bool
    }

    var startedAt: Date
}

