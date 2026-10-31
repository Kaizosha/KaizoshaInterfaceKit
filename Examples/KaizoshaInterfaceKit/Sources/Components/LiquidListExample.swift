import KaizoshaInterfaceKit
import SwiftUI

struct LiquidListExample: View {
    @State private var configuration = LiquidListConfiguration()
    @State private var rowConfiguration = LiquidListRowConfiguration()
    @State private var selection = "Appearance"
    @State private var enabled = true
    @State private var tactileFeedback = true
    @State private var customGlassTint = false
    @State private var glassTint = Color.blue
    @State private var count = 3
    @Environment(\.self) private var environment

    var body: some View {
        ComponentPage(title: "Liquid List", fillsCanvas: true, code: code, reset: reset) {
            LiquidList(configuration: configuration) {
                ForEach(Array(names.prefix(count)), id: \.self) { name in
                    Button { selection = name } label: {
                        LiquidListRow(isSelected: selection == name, configuration: effectiveRow) {
                            HStack {
                                Text(name).lineLimit(1)
                                Spacer()
                                Image(systemName: selection == name ? "checkmark" : "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("liquid.row.\(name)")
                    .accessibilityAddTraits(selection == name ? .isSelected : [])
                }
                LiquidListRow(isInteractive: false, configuration: effectiveRow) {
                    Toggle("Tactile feedback", isOn: $tactileFeedback)
                }
            }
            .disabled(!enabled)
        } controls: {
            Section("List") {
                Toggle("Enabled", isOn: $enabled)
                Stepper("Rows: \(count)", value: $count, in: 1...names.count)
                ValueControl(title: "Row spacing", value: $configuration.rowSpacing, range: 0...30, suffix: " pt")
                ValueControl(title: "Horizontal inset", value: $configuration.horizontalInset, range: 0...40, suffix: " pt")
                ValueControl(title: "Vertical inset", value: $configuration.verticalInset, range: 0...40, suffix: " pt")
            }
            Section("Row") {
                Toggle("Custom glass tint", isOn: $customGlassTint)
                ColorPicker("Glass tint", selection: $glassTint).disabled(!customGlassTint)
                ColorPicker("Selection tint", selection: $rowConfiguration.selectionTint)
                Slider(value: $rowConfiguration.selectionOpacity, in: 0...0.5) { Text("Selection strength") }
                ValueControl(title: "Minimum height", value: $rowConfiguration.minimumHeight, range: 44...90, suffix: " pt")
                ValueControl(title: "Horizontal padding", value: $rowConfiguration.horizontalPadding, range: 8...32, suffix: " pt")
                ValueControl(title: "Vertical padding", value: $rowConfiguration.verticalPadding, range: 0...24, suffix: " pt")
                ValueControl(title: "Corner radius", value: $rowConfiguration.cornerRadius, range: 0...44, suffix: " pt")
                Picker("Shape", selection: $rowConfiguration.shape) {
                    ForEach(LiquidListRowConfiguration.Shape.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                }
            }
        }
    }
    private var effectiveRow: LiquidListRowConfiguration {
        var value = rowConfiguration
        value.glassTint = customGlassTint ? glassTint : nil
        return value
    }
    private func reset() {
        configuration = .init()
        rowConfiguration = .init()
        selection = "Appearance"
        enabled = true
        tactileFeedback = true
        customGlassTint = false
        glassTint = .blue
        count = 3
    }
    private let names = ["Appearance", "Captions", "Language", "Playback", "Storage", "Accessibility"]
    private var code: String {
        let row = effectiveRow
        let titles = names.prefix(count).map { String(reflecting: $0) }.joined(separator: ", ")
        return """
        import KaizoshaInterfaceKit
        import SwiftUI

        @State private var selection = \(String(reflecting: selection))
        @State private var tactileFeedback = \(tactileFeedback)
        let titles = [\(titles)]
        let rowConfiguration = LiquidListRowConfiguration(
            glassTint: \(row.glassTint.map { UsageSource.color($0, in: environment) } ?? "nil"),
            selectionTint: \(UsageSource.color(row.selectionTint, in: environment)),
            selectionOpacity: \(row.selectionOpacity),
            horizontalPadding: \(Double(row.horizontalPadding)),
            verticalPadding: \(Double(row.verticalPadding)),
            minimumHeight: \(Double(row.minimumHeight)),
            shape: .\(row.shape.rawValue),
            cornerRadius: \(Double(row.cornerRadius))
        )

        LiquidList(configuration: LiquidListConfiguration(
            rowSpacing: \(Double(configuration.rowSpacing)),
            horizontalInset: \(Double(configuration.horizontalInset)),
            verticalInset: \(Double(configuration.verticalInset))
        )) {
            ForEach(titles, id: \\.self) { title in
                Button { selection = title } label: {
                    LiquidListRow(isSelected: selection == title, configuration: rowConfiguration) {
                        HStack {
                            Text(title).lineLimit(1)
                            Spacer()
                            Image(systemName: selection == title ? "checkmark" : "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == title ? .isSelected : [])
            }
            LiquidListRow(isInteractive: false, configuration: rowConfiguration) {
                Toggle("Tactile feedback", isOn: $tactileFeedback)
            }
        }
        .disabled(\(!enabled))
        """
    }
}
