import KaizoshaInterfaceKit
import SwiftUI

struct OptionPillExample: View {
    @State private var selection = 0
    @State private var configuration = OptionPillConfiguration(width: 300)
    @State private var options = [EditableOption(id: 0, title: "Low"), EditableOption(id: 1, title: "High", tint: .orange)]
    @State private var count = 2
    @State private var enabled = true
    @State private var glassTint = Color.orange
    @State private var customGlassTint = true
    @Environment(\.self) private var environment

    var body: some View {
        ComponentPage(title: "Option Pill", code: code, reset: reset) {
            OptionPill(selection: $selection, items: options.map { .init(id: $0.id, title: $0.title, tint: $0.tint, foregroundColor: $0.foreground, selectedForegroundColor: $0.selectedForeground) }, configuration: effectiveConfiguration)
                .disabled(!enabled)
        } controls: {
            Section("Pill") {
                Toggle("Enabled", isOn: $enabled)
                Stepper("Options: \(count)", value: $count, in: 1...6)
                    .accessibilityIdentifier("pill.count")
                ValueControl(title: "Width", value: Binding(get: { configuration.width ?? 300 }, set: { configuration.width = $0 }), range: 160...340, suffix: " pt")
                ValueControl(title: "Height", value: $configuration.height, range: 44...80, suffix: " pt")
                ValueControl(title: "Spacing", value: $configuration.spacing, range: 0...16, suffix: " pt")
                Toggle("Custom glass tint", isOn: $customGlassTint)
                ColorPicker("Glass tint", selection: $glassTint).disabled(!customGlassTint)
            }
            ForEach($options) { option in
                Section("Option \(option.wrappedValue.id + 1)") {
                    TextField("Title", text: option.title)
                        .accessibilityIdentifier("pill.title.\(option.wrappedValue.id)")
                    ColorPicker("Selection tint", selection: option.tint)
                    ColorPicker("Text", selection: option.foreground)
                    ColorPicker("Selected text", selection: option.selectedForeground)
                }
            }
        }
        .onChange(of: count) { _, value in
            if value < options.count { options = Array(options.prefix(value)) }
            while options.count < value { options.append(.init(id: options.count, title: "Option \(options.count + 1)", tint: palette[options.count % palette.count])) }
            if !options.contains(where: { $0.id == selection }) { selection = 0 }
        }
    }

    private var effectiveConfiguration: OptionPillConfiguration {
        var value = configuration
        value.glassTint = customGlassTint ? glassTint : nil
        return value
    }

    private var code: String {
        let items = options.map {
            "    OptionPillItem(id: \($0.id), title: \(String(reflecting: $0.title)), tint: \(UsageSource.color($0.tint, in: environment)), foregroundColor: \(UsageSource.color($0.foreground, in: environment)), selectedForegroundColor: \(UsageSource.color($0.selectedForeground, in: environment)))"
        }.joined(separator: ",\n")
        return """
        import KaizoshaInterfaceKit
        import SwiftUI

        @State private var selection = \(selection)

        OptionPill(selection: $selection, items: [
        \(items)
        ], configuration: OptionPillConfiguration(
            glassTint: \(customGlassTint ? UsageSource.color(glassTint, in: environment) : "nil"),
            width: \(Double(configuration.width ?? 300)),
            height: \(Double(configuration.height)),
            spacing: \(Double(configuration.spacing))
        ))
        .disabled(\(!enabled))
        """
    }

    private func reset() {
        configuration = .init(width: 300)
        selection = 0
        count = 2
        enabled = true
        glassTint = .orange
        customGlassTint = true
        options = [.init(id: 0, title: "Low"), .init(id: 1, title: "High", tint: .orange)]
    }
    private let palette: [Color] = [.primary, .orange, .blue, .green, .pink, .purple]
}
