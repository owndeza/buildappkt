import ActivityKit
import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var manager: ActivityManager
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("indicatorStyle") private var indicatorStyleRaw = IndicatorStyle.dot.rawValue
    @State private var copied = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Внешний вид") {
                    Picker("Тема", selection: $appearance) {
                        Text("Системная").tag("system")
                        Text("Светлая").tag("light")
                        Text("Тёмная").tag("dark")
                    }
                    Picker("Минимальный индикатор", selection: $indicatorStyleRaw) {
                        ForEach(IndicatorStyle.allCases) { style in
                            Label(style.title, systemImage: style.symbolName).tag(style.rawValue)
                        }
                    }
                    Text("Для применения нового индикатора перезапустите активность.")
                        .font(.caption).foregroundStyle(.secondary)
                }

                Section("Диагностика") {
                    LabeledContent("iOS", value: UIDevice.current.systemVersion)
                    LabeledContent("Устройство", value: UIDevice.current.model)
                    LabeledContent("Авторизация", value: manager.activitiesEnabled ? "Разрешена" : "Недоступна")
                    LabeledContent("Активностей", value: "\(manager.activeCount)")
                    LabeledContent("Состояние", value: manager.lifecycle.title)
                    if let id = manager.activityID { LabeledContent("Activity ID", value: id) }
                    if let date = manager.startedAt { LabeledContent("Запущена", value: date.formatted()) }
                    if let error = manager.lastError { LabeledContent("Ошибка", value: error) }
                    Button(copied ? "Скопировано" : "Копировать диагностику") {
                        UIPasteboard.general.string = diagnostics
                        copied = true
                    }
                }

                Section("Устранение неполадок") {
                    Text("Проверьте Настройки → PersistentIsland → Live Activities, затем остановите и запустите активность снова. iOS может скрыть или завершить её по системным причинам.")
                }

                Section("О приложении") {
                    Text(IslandConfiguration.limitationText)
                    Text("Никакие данные не собираются и не отправляются.")
                }
            }
            .navigationTitle("Настройки")
            .toolbar { Button("Готово") { dismiss() } }
        }
    }

    private var diagnostics: String {
        [
            "PersistentIsland diagnostics",
            "iOS: \(UIDevice.current.systemVersion)",
            "Device class: \(UIDevice.current.model)",
            "Live Activities enabled: \(manager.activitiesEnabled)",
            "Active count: \(manager.activeCount)",
            "State: \(manager.lifecycle.rawValue)",
            "Activity ID: \(manager.activityID ?? "none")",
            "Started: \(manager.startedAt?.formatted() ?? "none")",
            "Last error: \(manager.lastError ?? "none")"
        ].joined(separator: "\n")
    }
}

