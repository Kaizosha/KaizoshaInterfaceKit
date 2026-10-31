import SwiftUI

@main
struct KaizoshaInterfaceKitApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    NavigationLink("Kaizōsha Logo") { KaizoshaLogoExample() }
                        .accessibilityIdentifier("catalog.logo")
                    NavigationLink("Credits Sheet") { CreditsSheetExample() }
                        .accessibilityIdentifier("catalog.credits-sheet")
                    NavigationLink("Segmented Control") { SegmentedControlExample() }
                        .accessibilityIdentifier("catalog.segmented-control")
                    NavigationLink("Option Pill") { OptionPillExample() }
                        .accessibilityIdentifier("catalog.option-pill")
                    NavigationLink("Liquid List") { LiquidListExample() }
                        .accessibilityIdentifier("catalog.liquid-list")
                    NavigationLink("Masonry Grid") { MasonryGridExample() }
                        .accessibilityIdentifier("catalog.masonry-grid")
                    NavigationLink("Glass Button") { GlassButtonExample() }
                        .accessibilityIdentifier("catalog.glass-button")
                }
                .listStyle(.plain)
                .navigationTitle("Kaizōsha’s InterfaceKit")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tint(.primary)
        }
    }
}
