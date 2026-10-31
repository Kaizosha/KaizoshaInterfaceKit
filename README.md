# Kaizōsha’s InterfaceKit

Reusable SwiftUI components from Kaizōsha's apps. The example app opens with a plain list. Each destination contains its component and a navigation-bar button for live customization, reset, and usage code.

## Add to your app

Add `https://github.com/Kaizosha/KaizoshaInterfaceKit` as a Swift package dependency and select the **KaizoshaInterfaceKit** product from version **0.4.0** or later. The package, product, and import module use the ASCII name `KaizoshaInterfaceKit`. Requires Xcode 27, Swift 6.4, and iOS 26 or later.

```swift
import KaizoshaInterfaceKit

KaizoshaLogo()
```

The catalog contains these seven component families:

| Catalog item | Public component | Configuration |
| --- | --- | --- |
| Kaizōsha Logo | `KaizoshaLogo` | `KaizoshaLogoConfiguration` |
| Credits Sheet | `CreditsSheet` | `CreditsSheetConfiguration` |
| Segmented Control | `SegmentedControl` and `SegmentedControlItem` | `SegmentedControlConfiguration` |
| Option Pill | `OptionPill` and `OptionPillItem` | `OptionPillConfiguration` |
| Liquid List | `LiquidList` and `LiquidListRow` | `LiquidListConfiguration` and `LiquidListRowConfiguration` |
| Masonry Grid | `MasonryGrid` or `MasonryLayout` | Column width, insets, and spacing |
| Glass Button | `.kaizoshaGlassButtonStyle()` | `GlassButtonConfiguration` |

The segmented control uses Together's Annual/Monthly payment-sheet picker. Payment, Language, and Options are gallery presets of the same reusable control. The host supplies item IDs, titles, and selection.

```swift
import KaizoshaInterfaceKit
import SwiftUI

struct LanguageControls: View {
	@State private var language = "source"
	@State private var quality = "low"

	var body: some View {
		VStack {
			SegmentedControl(selection: $language, items: [
				SegmentedControlItem(id: "source", title: "Source"),
				SegmentedControlItem(id: "translation", title: "Translate")
			], configuration: .init(width: 210, height: 32, fontSize: 13))

			OptionPill(selection: $quality, items: [
				OptionPillItem(id: "low", title: "Low"),
				OptionPillItem(id: "balanced", title: "Balanced", tint: .blue),
				OptionPillItem(id: "high", title: "High", tint: .orange)
			], configuration: .init(glassTint: .orange, width: 320))
		}
	}
}
```

Your app owns bindings, actions, availability, and presentation. Components do not depend on Together purchases, translation engines, or sibling repositories. Metal resources are bundled with the package.

Apply the glass style to native controls:

```swift
Button("Help", systemImage: "questionmark") {
	showHelp = true
}
.labelStyle(.iconOnly)
.kaizoshaGlassButtonStyle(.init(tint: .yellow, borderShape: .circle))
.disabled(!canShowHelp)
```

For device lighting on the logo, add `NSMotionUsageDescription` to your app's Info.plist. See the [component reference](Documentation/Components.md) for configuration and defaults.

## Run the example

Open [KaizoshaInterfaceKit.xcodeproj](Examples/KaizoshaInterfaceKit/KaizoshaInterfaceKit.xcodeproj) and choose the **KaizoshaInterfaceKit** scheme.

Run `python3 Scripts/generate-example-project.py` after changing example files. The generated project is checked in. The app icon is the layered [InterfaceKit.icon](Examples/KaizoshaInterfaceKit/Resources/InterfaceKit.icon) document created in Icon Composer.

## Verify changes

Run `Scripts/verify.sh SIMULATOR_ID` on an iOS 26 or later simulator. It runs package and gallery UI tests and retains screenshots in result bundles. See [verification](Documentation/Verification.md) and [TestFlight delivery](Documentation/Distribution.md) for evidence and delivery steps.

## License

Developed by Kaizōsha and Kaizō Konpaku. Available under the [MIT License](LICENSE).
