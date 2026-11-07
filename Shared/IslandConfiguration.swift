import Foundation

enum IndicatorStyle: String, Codable, CaseIterable, Identifiable, Sendable {
    case dot
    case ring
    case diamond

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dot: return "Точка"
        case .ring: return "Кольцо"
        case .diamond: return "Ромб"
        }
    }

    var symbolName: String {
        switch self {
        case .dot: return "circle.fill"
        case .ring: return "circle"
        case .diamond: return "diamond.fill"
        }
    }
}

enum IslandConfiguration {
    static let activityName = "PersistentIsland"
    static let deepLink = URL(string: "persistentisland://activity")!
    static let limitationText = "PersistentIsland uses Live Activities. iOS controls when activities appear and how long they remain active. Permanent visibility cannot be guaranteed."
}

