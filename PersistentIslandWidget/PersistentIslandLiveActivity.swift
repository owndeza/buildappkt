import ActivityKit
import SwiftUI
import WidgetKit

struct PersistentIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttributes.self) { context in
            lockScreenView(context: context)
                .activityBackgroundTint(.black.opacity(0.92))
                .activitySystemActionForegroundColor(.white)
                .widgetURL(IslandConfiguration.deepLink)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    indicator(for: context.state.indicatorStyle, size: 9)
                        .accessibilityLabel("PersistentIsland активен")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.startedAt, style: .timer)
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PersistentIsland").font(.caption.weight(.semibold))
                            Text(context.state.isRunning ? "Live Activity активна" : "Завершена")
                                .font(.caption2).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.app")
                            .font(.caption).foregroundStyle(.mint)
                    }
                    .accessibilityElement(children: .combine)
                }
            } compactLeading: {
                indicator(for: context.state.indicatorStyle, size: 7)
                    .accessibilityLabel("PersistentIsland")
            } compactTrailing: {
                Text(context.attributes.startedAt, style: .timer)
                    .font(.system(size: 9, weight: .medium).monospacedDigit())
                    .frame(maxWidth: 28)
            } minimal: {
                indicator(for: context.state.indicatorStyle, size: 6)
                    .accessibilityLabel("PersistentIsland активен")
            }
            .widgetURL(IslandConfiguration.deepLink)
            .keylineTint(.mint.opacity(0.7))
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<IslandAttributes>) -> some View {
        HStack(spacing: 10) {
            indicator(for: context.state.indicatorStyle, size: 9)
            VStack(alignment: .leading, spacing: 2) {
                Text("PersistentIsland").font(.subheadline.weight(.semibold))
                Text(context.state.isRunning ? "Активна" : "Завершена")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(context.attributes.startedAt, style: .timer)
                .font(.caption.monospacedDigit())
        }
        .padding(.horizontal, 4)
        .accessibilityElement(children: .combine)
    }

    private func indicator(for style: IndicatorStyle, size: CGFloat) -> some View {
        Image(systemName: style.symbolName)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(.mint)
    }
}

