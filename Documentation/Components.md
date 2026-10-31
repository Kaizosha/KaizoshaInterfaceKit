# Component reference

All public components use `import KaizoshaInterfaceKit`. The example app owns its catalog, navigation, customization sheets, and usage-code view.

## Kaizōsha Logo

`KaizoshaLogo(configuration:onOpenCredits:)` renders the canonical Kaizōsha artwork.

`KaizoshaLogoConfiguration` contains:

| Value | Default | Behavior |
| --- | --- | --- |
| `size` | 160 | Artwork width in points. The canonical 160:151 aspect ratio remains unchanged. |
| `interactive` | true | Enables direct dragging and elastic return. |
| `hapticsEnabled` | true | Enables tactile travel and release feedback. |
| `motionEnabled` | true | Follows device tilt while the component is visible and active. |
| `refraction` | 1 | Multiplies drag-driven refraction from 0 through 2. The resting canonical finish remains applied. |
| `lightDirection` | (-0.22, -0.32) | Manual shader lighting when device tilt is disabled. |

The optional `onOpenCredits` closure enables a 0.6-second long press and a VoiceOver Open Credits action. The consuming app owns the destination. Omitting the closure removes both actions.

Apps using device lighting include `NSMotionUsageDescription` in their Info.plist. Reduce Motion limits displacement and removes deformation and device lighting. Reduce Transparency removes shader effects and the shadow. Device lighting stops when the view disappears, the scene becomes inactive, or motion is disabled. Haptic generators detach when the view disappears or haptics are disabled.

## Credits Sheet

`CreditsSheet(configuration:)` is Together's native credits sheet. `CreditsSheetConfiguration.together` preserves its default title, two paragraphs, serif title, justified monospaced body, static Metal mark, and red close button.

Configuration exposes `title`, `paragraphs`, `showsLogo`, and `logoSize`. Paragraphs support **bold** and *italic* emphasis. The consuming app presents the component with `.sheet`.

## Segmented Control

`SegmentedControl(selection:items:configuration:)` uses Together's payment-sheet `UISegmentedControl`. Each `SegmentedControlItem<ID>` contains a stable `Hashable` ID and a title. The binding and selected item use the same ID type. Items have equal widths. An empty item array produces no visible control.

`SegmentedControlConfiguration` contains:

| Value | Default | Behavior |
| --- | --- | --- |
| `width` | nil | Uses the proposed width or native intrinsic width. A value sets an explicit width in points. |
| `height` | 60 | Minimum height in points. Scaled text can increase it. |
| `fontSize` | 16 | Base size of the semibold font, scaled with Dynamic Type. |
| `selectionTint` | nil | Uses native selection rendering. A color changes the selected segment tint. |
| `foregroundColor` | `.primary` | Unselected title color. |
| `selectedForegroundColor` | `.primary` | Selected title color. |

The gallery's Payment preset shows Annual and Monthly at a 60-point minimum height. Language uses Source and Translate at 210 points wide, 32 points high, and a 13-point base font. Options demonstrates three generic items. All presets use the same public component.

The host owns selection and availability through its binding and `.disabled`. A missing selected ID leaves all segments unselected. A binding that rejects a change restores the host's selection.

## Option Pill

`OptionPill(selection:items:configuration:)` is a glass selector for any number of caller-supplied options. It contains the options without translation status or an information popover.

Each `OptionPillItem<ID>` contains `id`, `title`, `tint`, `foregroundColor`, and `selectedForegroundColor`. The tint colors that option's selected capsule. Normal text defaults to `.primary`, and selected text defaults to the system background color. Stable, unique IDs identify the options.

`OptionPillConfiguration` contains:

| Value | Default | Behavior |
| --- | --- | --- |
| `glassTint` | nil | Optional tint for the outer glass capsule. |
| `width` | nil | Uses available width. A value sets an explicit width in points. |
| `height` | 46 | Minimum capsule height in points. The minimum accepted height is 44. |
| `spacing` | 4 | Space between options. |

Options share the available width. Titles stay on one line and truncate at the tail. VoiceOver retains the complete title and reports the selected option. Empty items produce no visible pill. Native buttons inherit `.disabled`, and selection animation respects Reduce Motion.

## Liquid List

`LiquidList(configuration:content:)` places caller-supplied rows in a scrolling vertical stack with soft scroll edges. `LiquidListConfiguration` defaults to 10-point row spacing and 16-point horizontal and vertical insets.

`LiquidListRow(isSelected:isInteractive:configuration:content:)` gives row content its glass and selection appearance. The host wraps the row in a `Button` or `NavigationLink` and owns its action. A row containing a `Toggle` uses `isInteractive: false`, so the toggle owns interaction.

`LiquidListRowConfiguration` contains:

| Value | Default | Behavior |
| --- | --- | --- |
| `glassTint` | nil | Optional tint for the regular glass. |
| `selectionTint` | `.accentColor` | Color of the selected row wash. |
| `selectionOpacity` | 0.10 | Strength of the selected row wash. |
| `horizontalPadding` | 18 | Horizontal content padding in points. |
| `verticalPadding` | 10 | Vertical content padding in points. |
| `minimumHeight` | 54 | Minimum row height in points. |
| `shape` | `.adaptive` | Capsule normally, rounded rectangle at accessibility text sizes. Explicit shapes are also available. |
| `cornerRadius` | 24 | Radius used for rounded rectangles. |

Rows inherit disabled state, remove saturation, and use half opacity when disabled. Disabled rows have no selected wash or interactive glass. The gallery demonstrates selectable settings rows and a contained toggle.

## Masonry Grid

`MasonryGrid` measures children at the available column width and places each in the shortest column. Defaults are 20-point horizontal insets and 16-point row and column gaps. Automatic minimum column width is 148 points, or 260 at accessibility text sizes. Reading direction mirrors physical columns while preserving data order. Explicit `minimumColumnWidth` overrides automatic sizing.

`MasonryLayout` exposes the same geometry as a SwiftUI `Layout`. It accepts an explicit `layoutDirection`; `MasonryGrid` reads the environment. Each child owns its aspect ratio and padding. A six-point child inset reproduces Together's media-card proportions without playback or thumbnail state.

## Glass Button

`.kaizoshaGlassButtonStyle(_:)` styles a native `Button`, or a native `Menu` with `.menuStyle(.button)`. `GlassButtonConfiguration` contains:

| Value | Default | Behavior |
| --- | --- | --- |
| `surface` | `.prominent` | Native prominent or regular glass. |
| `tint` | `.accentColor` | The enabled glass tint. |
| `borderShape` | `.capsule` | Native border shape. Label size and control size stay with the caller. |

Prominent labels use the adaptive system-background foreground inside the native label. Unavailable prominent controls use the native confirmation rendering role and app accent, including when an ancestor disables them. Re-enabling restores the supplied role and tint. Regular glass preserves its native foreground and supplied tint.

Roles, actions, labels, accessibility, `.controlSize`, `.disabled`, and symbol effects remain native SwiftUI responsibilities.

```swift
Menu("Actions", systemImage: "ellipsis") {
	Button("Select All", action: selectAll)
	Button("Remove", role: .destructive, action: remove)
}
.menuStyle(.button)
.kaizoshaGlassButtonStyle(.init(surface: .regular))
```

The gallery provides Primary, Confirm, Help, Reset, Destructive, and Menu presets. Its customization sheet changes the label, role, tint, glass, shape, control size, and local or inherited availability. The activation count is in the customization sheet. The component canvas contains only the control.
