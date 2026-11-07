import ActivityKit
import Foundation
import SwiftUI

@MainActor
final class ActivityManager: ObservableObject {
    @Published private(set) var lifecycle: ActivityLifecycleState = .inactive
    @Published private(set) var activityID: String?
    @Published private(set) var startedAt: Date?
    @Published private(set) var lastError: String?
    @Published private(set) var activitiesEnabled = false
    @Published private(set) var activeCount = 0

    private var observationTask: Task<Void, Never>?

    init() {
        observationTask = Task { [weak self] in
            await self?.refresh()
            await self?.observeAuthorizationChanges()
        }
    }

    deinit { observationTask?.cancel() }

    func refresh() async {
        activitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
        let activities = Activity<IslandAttributes>.activities
        activeCount = activities.count

        guard let activity = activities.first else {
            activityID = nil
            startedAt = nil
            lifecycle = ActivityLifecycleReducer.restored(
                hasActivity: false,
                authorizationEnabled: activitiesEnabled
            )
            return
        }

        activityID = activity.id
        startedAt = activity.attributes.startedAt
        lifecycle = map(activity.activityState)
    }

    func start(indicatorStyle: IndicatorStyle) async {
        await refresh()
        guard activitiesEnabled else {
            setError("Live Activities отключены в настройках iOS или недоступны на этом устройстве.", state: .unsupported)
            return
        }
        guard ActivityLifecycleReducer.canStart(from: lifecycle, hasActivity: activeCount > 0) else { return }

        lifecycle = .starting
        lastError = nil
        let startDate = Date()
        let attributes = IslandAttributes(startedAt: startDate)
        let state = IslandAttributes.ContentState(isRunning: true, indicatorStyle: indicatorStyle)

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: nil),
                pushType: nil
            )
            activityID = activity.id
            startedAt = startDate
            activeCount = Activity<IslandAttributes>.activities.count
            lifecycle = map(activity.activityState)
            observeState(of: activity)
        } catch {
            setError(error.localizedDescription)
        }
    }

    func stop() async {
        let activities = Activity<IslandAttributes>.activities
        guard !activities.isEmpty else {
            lifecycle = .ended
            await refresh()
            return
        }

        lifecycle = .ending
        lastError = nil
        let finalState = IslandAttributes.ContentState(isRunning: false, indicatorStyle: .dot)
        for activity in activities {
            await activity.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .immediate
            )
        }
        lifecycle = .ended
        activityID = nil
        startedAt = nil
        activeCount = 0
    }

    func restart(indicatorStyle: IndicatorStyle) async {
        await stop()
        await start(indicatorStyle: indicatorStyle)
    }

    private func observeAuthorizationChanges() async {
        for await enabled in ActivityAuthorizationInfo().activityEnablementUpdates {
            guard !Task.isCancelled else { return }
            activitiesEnabled = enabled
            await refresh()
        }
    }

    private func observeState(of activity: Activity<IslandAttributes>) {
        Task { [weak self] in
            for await state in activity.activityStateUpdates {
                guard !Task.isCancelled else { return }
                await self?.apply(state: state, for: activity.id)
            }
        }
    }

    private func apply(state: ActivityState, for id: String) {
        guard id == activityID else { return }
        lifecycle = map(state)
        if state == .ended || state == .dismissed {
            activityID = nil
            startedAt = nil
            activeCount = Activity<IslandAttributes>.activities.count
        }
    }

    private func map(_ state: ActivityState) -> ActivityLifecycleState {
        switch state {
        case .active, .stale: return .active
        case .ended, .dismissed: return .ended
        @unknown default: return .error
        }
    }

    private func setError(_ message: String, state: ActivityLifecycleState = .error) {
        lastError = message
        lifecycle = state
    }
}

