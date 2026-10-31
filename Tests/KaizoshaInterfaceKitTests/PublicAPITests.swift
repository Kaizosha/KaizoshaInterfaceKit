import KaizoshaInterfaceKit
import SwiftUI
import Testing

@MainActor
struct PublicAPITests {
    @Test func consumingAppCanConstructAndCustomizeTheLogo() {
        var configuration = KaizoshaLogoConfiguration()
        #expect(configuration.size == 160)
        #expect(configuration.interactive)
        #expect(configuration.hapticsEnabled)
        #expect(configuration.motionEnabled)
        configuration.size = 220
        configuration.motionEnabled = false
        configuration.lightDirection = CGVector(dx: 0.5, dy: -0.5)
        _ = KaizoshaLogo(configuration: configuration)
        _ = KaizoshaLogo(configuration: configuration, onOpenCredits: {})
    }

    @Test func consumingAppCanConstructEveryComponentWithOneImport() {
        var credits = CreditsSheetConfiguration.together
        credits.title = "Made for Kaizōsha."
        _ = CreditsSheet(configuration: credits)

        enum Choice: Hashable { case first, second, third }
        let selection = Binding.constant(Choice.second)
        _ = SegmentedControl(selection: selection, items: [
            SegmentedControlItem(id: .first, title: "Annual"),
            .init(id: .second, title: "Monthly"),
            .init(id: .third, title: "Lifetime")
        ], configuration: .init(width: 320, selectionTint: .orange))
        _ = OptionPill(selection: selection, items: [
            OptionPillItem(id: .first, title: "Low", tint: .blue),
            .init(id: .second, title: "High", tint: .orange),
            .init(id: .third, title: "Custom", tint: .green, foregroundColor: .purple,
                  selectedForegroundColor: .white)
        ], configuration: .init(glassTint: .pink, width: 300))

        _ = LiquidList(configuration: .init(rowSpacing: 12, horizontalInset: 20)) {
            Button {} label: {
                LiquidListRow(isSelected: true, configuration: .init(glassTint: .blue)) {
                    Text("Appearance")
                }
            }
            .buttonStyle(.plain)
            LiquidListRow(isInteractive: false) {
                Toggle("Tactile feedback", isOn: .constant(true))
            }
        }
        _ = MasonryGrid { Color.clear.frame(height: 100) }
        _ = MasonryLayout { Color.clear.frame(height: 100) }
        _ = Button("Continue") { }
            .kaizoshaGlassButtonStyle()
    }

    @Test func selectionAndListConfigurationsExposeReusableAppearance() {
        var segmented = SegmentedControlConfiguration()
        #expect(segmented.height == 60)
        #expect(segmented.selectionTint == nil)
        segmented.width = 210
        segmented.height = 32
        segmented.fontSize = 13
        segmented.foregroundColor = .blue
        segmented.selectedForegroundColor = .white
        _ = SegmentedControl(selection: .constant("source"), items: [
            SegmentedControlItem(id: "source", title: "Source"),
            .init(id: "translation", title: "Translate")
        ], configuration: segmented)

        var pill = OptionPillConfiguration()
        pill.glassTint = .green
        pill.width = 280
        pill.height = 50
        pill.spacing = 8
        #expect(pill.glassTint == .green)
        #expect(pill.width == 280)
        #expect(pill.height == 50)
        #expect(pill.spacing == 8)

        var row = LiquidListRowConfiguration()
        row.selectionTint = .purple
        row.selectionOpacity = 0.2
        row.shape = .roundedRectangle
        row.cornerRadius = 18
        #expect(row.selectionTint == .purple)
        #expect(row.selectionOpacity == 0.2)
        #expect(row.shape == .roundedRectangle)
        #expect(row.cornerRadius == 18)
    }

    @Test func glassConfigurationUsesNativeDefaultsAndAcceptsCustomization() {
        var configuration = GlassButtonConfiguration()
        #expect(configuration.surface == .prominent)
        #expect(configuration.tint == .accentColor)
        #expect(configuration.borderShape == .capsule)

        configuration.surface = .regular
        configuration.tint = .orange
        configuration.borderShape = .circle
        #expect(configuration.surface == .regular)
        #expect(configuration.tint == .orange)
        #expect(configuration.borderShape == .circle)

        let initialized = GlassButtonConfiguration(
            surface: .regular,
            tint: .orange,
            borderShape: .circle
        )
        #expect(initialized.surface == configuration.surface)
        #expect(initialized.tint == configuration.tint)
        #expect(initialized.borderShape == configuration.borderShape)
    }

    @Test func glassComposesWithNativeButtonsMenusAndInheritedDisabling() {
        for surface in [GlassButtonConfiguration.Surface.regular, .prominent] {
            let configuration = GlassButtonConfiguration(
                surface: surface,
                tint: .red,
                borderShape: .circle
            )

            _ = Button("Delete", systemImage: "trash", role: .destructive) { }
                .kaizoshaGlassButtonStyle(configuration)
                .controlSize(.regular)
                .accessibilityHint("Deletes the selected item")

            _ = VStack {
                Button(role: .close) { } label: {
                    Label("Close", systemImage: "xmark")
                }
                .kaizoshaGlassButtonStyle(configuration)

                Menu {
                    Button("Select All") { }
                    Button("Delete", role: .destructive) { }
                } label: {
                    Label("Actions", systemImage: "ellipsis")
                }
                .menuStyle(.button)
                .kaizoshaGlassButtonStyle(configuration)
            }
            .disabled(true)
        }
    }
}
