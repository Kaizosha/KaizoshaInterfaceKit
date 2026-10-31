# Changelog

## Package 0.4.0

- Set the app display name to Kaizōsha’s InterfaceKit and the main folder to KaizoshaInterfaceKit.
- Consolidated payment, language, and generic segmented examples into `SegmentedControl`, based on Together's Annual/Monthly payment picker.
- Replaced translation-specific selectors with `OptionPill`, including multiple options, editable colors, and one-line title truncation.
- Restored reusable `LiquidList` and `LiquidListRow` components.
- Renamed public configuration types to match Kaizosha Logo, Credits Sheet, and Glass Button.
- Reduced the catalog to seven component families with an element and customization button on each page.
- Added a layered app-icon document created in Icon Composer.

## Package 0.3.0

- Renamed the public product and module to KaizoshaInterfaceKit.
- Added the native glass button configuration/modifier with adaptive symbol foreground and native unavailable presentation.
- Added six button/menu presets, live customization, and copyable current usage in the example app.
- Supports iOS and iPadOS 26 with the existing Xcode 27 / Swift 6.4 toolchain.

## 1.0 build 4

- Renamed the package, product, import module, and example app to KaizoshaInterfaceKit.
- Set the package and example app minimum deployment target to iOS 26.
- Preserved the existing app bundle identity for TestFlight updates.

## 1.0 build 3

- Renamed the package, product, import module, and example app to KaizoshaUIKit.
- Replaced the former catalog with seven individual components in the requested order.
- Extracted Together's canonical logo, exact credits sheet, native unlock control, strategy pill, language selector, Low/High selector, and adaptive masonry layout.
- Added live customization sheets, reset, and copyable import examples for every component.
- Kept the existing bundle identity for TestFlight updates.

Earlier experiments remain available in Git history.
