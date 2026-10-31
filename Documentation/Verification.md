# Verify Kaizōsha’s InterfaceKit

Run `Scripts/verify.sh SIMULATOR_ID` with Xcode 27 selected. The script regenerates the example project, runs package tests, and runs gallery UI tests on the supplied iOS 26 or later simulator. Each run creates a separate evidence directory under `/tmp/kaizosha-interfacekit-verify.*`.

The current package checks cover public imports, logo motion and drag policies, haptic travel, native segmented selection, credits text, liquid-list geometry, and masonry geometry. Gallery checks cover the seven-item catalog, individual customization sheets, selection, reset, and usage code.

The cleanup changes public type names and replaces the former app-specific selectors. Earlier test results below describe those earlier revisions. Validate the current source before assigning a new TestFlight build.

UI tests retain screenshots in their result bundle. Export them with:

```sh
xcrun xcresulttool export attachments \
	--path RESULT.xcresult \
	--output-path DIRECTORY
```

Inspect the component screens and customization sheets in Light and Dark appearances. Check the segmented-control presets, more than two pill options, long labels, liquid-list selection and contained toggles, and accessibility text sizes. Confirm the archived app contains the Icon Composer asset output.

## Historical build 4 evidence

Build 4 used the previous eight-item catalog and public API. Its iOS 26 package
passed 30 tests. The complete iPhone simulator gallery passed 13 checks,
including generated customization code. Five button checks also passed on an
iPad simulator in Dark appearance at accessibility XXXL. Two physical iPhone
checks proved repeated activation, local and inherited disabling, and a working
prominent menu.

The first physical menu run was interrupted by a system notification banner;
that failed bundle is retained. Both unchanged checks pass on repeat. Xcode's
post-run simulator diagnostic collector reports that its separate `xcrun`
lookup cannot find `simctl`; the test command still exits zero and reports
`TEST EXECUTE SUCCEEDED`. This does not establish a clean diagnostic collection.
Physical iPad validation was deferred. Build 4 evidence is under
`/tmp/KaizoshaInterfaceKit42`.

## Historical build 3 evidence

These receipts describe the earlier KaizoshaUIKit release and its former components. They do not verify the current API.

- Public consumer smoke tests use ordinary `import KaizoshaUIKit` and construct every exported component. Package suite: 28 tests passed in `/tmp/kaizosha-uikit-package-final.xcresult`.
- Complete iPhone gallery suite: eight tests passed in `/tmp/kaizosha-uikit-gallery-verified.xcresult`. The recorded drag visibly moves the logo, then returns it to its anchor. Recording: `/tmp/kaizosha-uikit-interactions.mp4`.
- Dark iPad at accessibility XXXL: native activation, adaptive masonry, guidance, and compact pill checks passed in `/tmp/kaizosha-uikit-ipad-accessibility.xcresult`. The compact info symbol was bounded and rechecked in `/tmp/kaizosha-uikit-ipad-icon-fitted.xcresult`.
- The seven normal screens and customization sheets were visually reviewed. Stacked pill spacing was corrected after that review and rechecked in `/tmp/kaizosha-uikit-pill-fitted.xcresult`.
- Actual repeated native taps now read two activations in the sheet on iPad, with the original Together control implementation. The gallery constructs its element and controls while the parent evaluates its body, so first presentation uses current state. Evidence: `/tmp/kaizosha-uikit-ipad-activation-state.xcresult`.
- Signed device archive: `/tmp/KaizoshaUIKit-1.0-3-final.xcarchive`. Display name KaizoshaUIKit, version 1.0 build 3, bundle `org.kaizosha.CustomKit`, company team `564DV375U4`. Strict code-signature verification passed, and the privacy manifest and package Metal library are present.
- Archived executable SHA256: `0ef5559a227101f98373fa41cc57f32dcdd0c2e94bc09da2cfef9e6a60c0de6a`.
- REA 6.8.0 inspected that exact binary's Mach-O, dylib resolution, and native dispatch metadata. Evidence: `/tmp/kaizosha-uikit-rea-shipping`. REA reports partial Swift conformance and generic/resilient metadata coverage; these results supplement live UI verification.

Physical device tilt and tactile feel remain device checks. Simulator tests verify lifecycle and bounded input, not physical sensation.

Build 3 completed Apple processing and is Testing in Kon's Testing. See [delivery](Distribution.md).

## Repeat native inspection

Run `Scripts/inspect-with-rea.sh APP NODE REA_CLI OUTPUT_DIRECTORY` for supplementary native analysis. Binary inspection does not establish visual parity or interaction behavior.
