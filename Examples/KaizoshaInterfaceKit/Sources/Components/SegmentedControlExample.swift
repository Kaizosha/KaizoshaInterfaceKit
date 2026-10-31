import KaizoshaInterfaceKit
import SwiftUI

struct SegmentedControlExample: View {
    @State private var selection = 0
    @State private var configuration = SegmentedControlConfiguration(width: 320)
    @State private var options = [EditableOption(id: 0, title: "Annual"), EditableOption(id: 1, title: "Monthly")]
    @State private var count = 2
    @State private var preset = "Payment"
    @State private var enabled = true
    @State private var automaticWidth = false
    @State private var customSelectionColor = false
    @State private var selectionColor = Color.orange
    @Environment(\.self) private var environment

    var body: some View {
        ComponentPage(title: "Segmented Control", code: code, reset: reset) {
            SegmentedControl(selection: $selection, items: options.map { .init(id: $0.id, title: $0.title) }, configuration: effectiveConfiguration)
                .disabled(!enabled)
                .accessibilityIdentifier("segmented.element")
        } controls: {
            Section("Control") {
                Picker("Preset", selection: $preset) {
                    Text("Payment").tag("Payment")
                    Text("Language").tag("Language")
                    Text("Options").tag("Options")
                }
                .accessibilityIdentifier("segmented.preset")
                Toggle("Enabled", isOn: $enabled)
                Stepper("Options: \(count)", value: $count, in: 1...6)
                    .accessibilityIdentifier("segmented.count")
                Toggle("Automatic width", isOn: $automaticWidth)
                ValueControl(title: "Width", value: Binding(get: { configuration.width ?? 320 }, set: { configuration.width = $0 }), range: 140...340, suffix: " pt")
                    .disabled(automaticWidth)
                ValueControl(title: "Height", value: $configuration.height, range: 28...90, suffix: " pt")
                ValueControl(title: "Text size", value: $configuration.fontSize, range: 10...24, suffix: " pt")
            }
            Section("Colors") {
                Toggle("Custom selection tint", isOn: $customSelectionColor)
                ColorPicker("Selection tint", selection: $selectionColor).disabled(!customSelectionColor)
                ColorPicker("Text", selection: $configuration.foregroundColor)
                ColorPicker("Selected text", selection: $configuration.selectedForegroundColor)
            }
            Section("Option titles") {
                ForEach($options) { option in
                    TextField("Option \(option.wrappedValue.id + 1)", text: option.title)
                }
            }
        }
        .onChange(of: count) { _, value in resize(value) }
        .onChange(of: preset) { _, value in apply(value) }
    }

    private var effectiveConfiguration: SegmentedControlConfiguration {
        var value = configuration
        value.width = automaticWidth ? nil : configuration.width
        value.selectionTint = customSelectionColor ? selectionColor : nil
        return value
    }

    private var code: String {
        let value = effectiveConfiguration
        let items = options.map { "    SegmentedControlItem(id: \($0.id), title: \(String(reflecting: $0.title)))" }.joined(separator: ",\n")
        return """
        import KaizoshaInterfaceKit
        import SwiftUI

        @State private var selection = \(selection)

        SegmentedControl(selection: $selection, items: [
        \(items)
        ], configuration: SegmentedControlConfiguration(
            width: \(value.width.map { String(Double($0)) } ?? "nil"),
            height: \(Double(value.height)),
            fontSize: \(Double(value.fontSize)),
            selectionTint: \(value.selectionTint.map { UsageSource.color($0, in: environment) } ?? "nil"),
            foregroundColor: \(UsageSource.color(value.foregroundColor, in: environment)),
            selectedForegroundColor: \(UsageSource.color(value.selectedForegroundColor, in: environment))
        ))
        .disabled(\(!enabled))
        """
    }

    private func resize(_ value: Int) {
        if value < options.count { options = Array(options.prefix(value)) }
        while options.count < value { options.append(.init(id: options.count, title: "Option \(options.count + 1)")) }
        if !options.contains(where: { $0.id == selection }) { selection = options.first?.id ?? 0 }
    }

    private func apply(_ value: String) {
        selection = 0
        automaticWidth = false
        customSelectionColor = false
        if value == "Language" {
            count = 2
            options = [.init(id: 0, title: "Source"), .init(id: 1, title: "Translate")]
            configuration = .init(width: 210, height: 32, fontSize: 13)
        } else if value == "Options" {
            count = 3
            options = [.init(id: 0, title: "First"), .init(id: 1, title: "Second"), .init(id: 2, title: "Third")]
            configuration = .init(width: 320, height: 44)
        } else {
            count = 2
            options = [.init(id: 0, title: "Annual"), .init(id: 1, title: "Monthly")]
            configuration = .init(width: 320)
        }
    }

    private func reset() {
        preset = "Payment"
        apply("Payment")
        enabled = true
        selectionColor = .orange
    }
}
