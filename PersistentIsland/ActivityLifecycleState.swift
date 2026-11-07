import Foundation

enum ActivityLifecycleState: String, Equatable {
    case inactive
    case starting
    case active
    case ending
    case ended
    case unsupported
    case error

    var title: String {
        switch self {
        case .inactive: return "Неактивна"
        case .starting: return "Запускается"
        case .active: return "Активна"
        case .ending: return "Завершается"
        case .ended: return "Завершена"
        case .unsupported: return "Недоступна"
        case .error: return "Ошибка"
        }
    }
}

enum ActivityLifecycleReducer {
    static func restored(hasActivity: Bool, authorizationEnabled: Bool) -> ActivityLifecycleState {
        guard authorizationEnabled else { return .unsupported }
        return hasActivity ? .active : .inactive
    }

    static func canStart(from state: ActivityLifecycleState, hasActivity: Bool) -> Bool {
        !hasActivity && ![.starting, .active, .ending, .unsupported].contains(state)
    }
}

