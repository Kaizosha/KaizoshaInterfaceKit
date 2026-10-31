# Kaizōsha’s InterfaceKit design

The package exports one library, `KaizoshaInterfaceKit`. Components live in `Sources/KaizoshaInterfaceKit`. The private example app lives in `Examples/KaizoshaInterfaceKit`.

The catalog contains seven component families in order: Kaizōsha Logo, Credits Sheet, Segmented Control, Option Pill, Liquid List, Masonry Grid, and Glass Button. Each destination shows its element and a navigation-bar customization button. Controls, reset, and usage code live in the customization sheet.

Public components are grouped into Branding, Sheets, Controls, Lists, and Layouts. The gallery has no exported product. Its individual screens are in `Sources/Components`; shared customization and code helpers are in `Sources/Support`. Earlier experiments remain in Git history.

## Shipping identity

The display name is **Kaizōsha’s InterfaceKit**. The package, product, module, project, and main folder use `KaizoshaInterfaceKit` so Swift imports and paths use an ASCII identifier.

The shipping bundle identifier remains `org.kaizosha.CustomKit` so existing TestFlight installations receive updates through the same app record.

## Canonical app components

The logo comes from Together's `ControlsKaizoshaLogo.swift` and shared `KaizoshaLogo` helpers. Those files own the canonical three pillars and 改造社 geometry, Metal finish, elastic response, motion lifecycle, and haptic travel.

The extraction adds typed configuration and package resource lookup through `ShaderLibrary.bundle(.module)`. Motion starts with view appearance. The consuming app supplies credits navigation.

`CreditsSheet` comes from Together's `TogetherCreditsSheet.swift`, retaining its exact default copy and justified UIKit text renderer. The consuming app can replace the title, paragraphs, or logo settings.

## Generic controls

`SegmentedControl` comes from `TogetherSubscriptionPlanPicker` in Together's `TogetherSubscriptionStoreControls.swift`. It preserves the Annual/Monthly payment picker's native equal-width segments, minimum height, scaled semibold text, and untinted native selection default. The extraction replaces StoreKit products with caller-owned IDs and titles.

Payment, Language, and Options are presets in one gallery page. Width, height, text size, title colors, and selection tint belong to the same component. Separate app-domain selectors would duplicate the same native control.

`OptionPill` retains the glass capsule treatment for generic choices. Each item owns its title and colors. The caller owns the item count and selection. One-line labels truncate at the tail, while accessibility labels retain the complete title. Translation explanations and availability policy belong in the consuming app.

`LiquidList` and `LiquidListRow` follow Together and TL-Pinch's shared list treatment: regular glass, a subtle selected wash, capsule rows, and rounded rectangles at accessibility text sizes. The caller supplies actions, navigation, or contained controls.

Masonry geometry follows Together's `VideoHomeGeometry.swift`, `VideoImportGridMetrics.swift`, and `ImportVideoCardGeometry.swift`. Media state and playback remain in the host.

The glass-button modifier styles native Button and Menu controls. Together owns semantic colors, symbol effects, actions, and availability. A dedicated button wrapper would hide native constructors without adding behavior.

## Example app and icon

A private `ComponentPage` owns each customization button and native sheet. It reserves space above a medium sheet for the live component. Liquid List and Masonry Grid use a scrollable canvas. The gallery constructs its element and controls while the parent evaluates its body, so a newly presented sheet uses current state.

The app icon is a layered Icon Composer document at `Examples/KaizoshaInterfaceKit/Resources/InterfaceKit.icon`. Its pillar and outlined wordmark SVG layers also live in `Design/AppIcon`. Xcode compiles the native `.icon` document as the app icon.

Rebuild the editable vector artwork with `swift Design/AppIcon/GenerateArtwork.swift Design/AppIcon` on macOS. Import those two SVG layers into Icon Composer when changing the artwork. The native document stores a light material override for Dark appearance and automatic Mono rendering.
