import ActivityKit
import SwiftUI
import WidgetKit

struct PersistentIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttributes.self) { _ in
            invisibleContent
                .activityBackgroundTint(.clear)
                .activitySystemActionForegroundColor(.clear)
                .widgetURL(IslandConfiguration.deepLink)
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { invisibleContent }
                DynamicIslandExpandedRegion(.trailing) { invisibleContent }
                DynamicIslandExpandedRegion(.bottom) { invisibleContent }
            } compactLeading: {
                invisibleContent
            } compactTrailing: {
                invisibleContent
            } minimal: {
                invisibleContent
            }
            .widgetURL(IslandConfiguration.deepLink)
            .keylineTint(.clear)
        }
    }

    private var invisibleContent: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .accessibilityLabel("PersistentIsland")
    }
}

