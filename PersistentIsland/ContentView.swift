import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var manager: ActivityManager
    @AppStorage("appearance") private var appearance = "system"
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    StatusCard()
                    controls
                    ActivityPreview()
                    limitation
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Настройки")
                }
            }
            .sheet(isPresented: $showingSettings) { SettingsView() }
            .task { await manager.refresh() }
        }
        .preferredColorScheme(appearance == "dark" ? .dark : appearance == "light" ? .light : nil)
    }

    private var header: some View {
        VStack(spacing: 6) {
            Image(systemName: "capsule.inset.filled")
                .font(.system(size: 42, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
            Text("PersistentIsland").font(.largeTitle.bold())
            Text("Your island, your way.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private var controls: some View {
        VStack(spacing: 12) {
            Button {
                Task { await manager.start() }
            } label: {
                Label("Start Island", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled([.starting, .active, .ending, .unsupported].contains(manager.lifecycle))

            HStack {
                Button("Stop Island", role: .destructive) {
                    Task { await manager.stop() }
                }
                .disabled(manager.lifecycle != .active)

                Spacer()

                Button("Restart Island") {
                    Task { await manager.restart() }
                }
                .disabled(manager.lifecycle != .active)
            }
            .buttonStyle(.bordered)
        }
    }

    private var limitation: some View {
        Label(IslandConfiguration.limitationText, systemImage: "info.circle")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct StatusCard: View {
    @EnvironmentObject private var manager: ActivityManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Live Activity", systemImage: "waveform.path")
                    .font(.headline)
                Spacer()
                Text(manager.lifecycle.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(manager.lifecycle == .active ? .green : .secondary)
            }
            LabeledContent("ActivityKit", value: manager.activitiesEnabled ? "Доступен" : "Недоступен")
            if let error = manager.lastError {
                Text(error).font(.footnote).foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
    }
}

private struct ActivityPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Предпросмотр").font(.headline)
            Text("Это макет, а не системный оверлей.")
                .font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 14) {
                previewCapsule(title: "Minimal", width: 40)
                previewCapsule(title: "Compact", width: 92)
                previewCapsule(title: "Expanded", width: 150)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
    }

    private func previewCapsule(title: String, width: CGFloat) -> some View {
        VStack(spacing: 6) {
            Capsule()
                .fill(.black)
                .frame(width: width, height: width > 100 ? 52 : 32)
            Text(title).font(.caption2).foregroundStyle(.secondary)
        }
    }
}

