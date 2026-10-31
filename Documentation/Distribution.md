# Deliver Kaizōsha’s InterfaceKit to TestFlight

The current display name is **Kaizōsha’s InterfaceKit**. The shipping identity remains `org.kaizosha.CustomKit`, company team `564DV375U4`, App Store Connect app `6827106597`. Version 1.0 build 5 uploaded successfully on October 31, 2026, and Apple reported that the package is processing. Build 4 remains the latest confirmed Testing assignment. The App Store Connect listing rename and build 5 tester-group verification await Apple sign-in in the Codex browser.

## Build 5 upload receipt

- Package release: `0.4.0`, source `c704f572d76c6d441e93a9f8279ca996721acee7`.
- Archive: `/tmp/InterfaceKit-Cleanup/KaizoshaInterfaceKit-1.0-5-final.xcarchive`.
- Archived executable SHA256: `f1c2709c7576c2582ed8fa0507da952755b551fd624a0070c2ecf543a21781fd`.
- Upload log: `/tmp/InterfaceKit-Cleanup-upload.log`.
- Xcode reported **Upload succeeded** and **EXPORT SUCCEEDED**, with **Uploaded package is processing**.
- The app bundle uses the exact display name Kaizōsha’s InterfaceKit and the compiled Icon Composer asset. The existing App Store Connect listing has not yet been renamed in this pass.
- Distribution uses the existing Xcode account and TestFlight Internal Only. Processing completion, build ID, and assignment to Kon's Testing are not yet verified.

The Codex browser remains on Apple's sign-in page. Its input controls reject automation, including in a fresh tab, so saved-login use could not be completed there. Do not treat this upload receipt as confirmation that testers can install build 5.

## Create the archive

```sh
python3 Scripts/generate-example-project.py
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild \
	-project Examples/KaizoshaInterfaceKit/KaizoshaInterfaceKit.xcodeproj \
	-scheme KaizoshaInterfaceKit \
	-configuration Release \
	-destination 'generic/platform=iOS' \
	-derivedDataPath /tmp/kaizosha-interfacekit-device-build \
	-archivePath /tmp/KaizoshaInterfaceKit-1.0-5-final.xcarchive \
	-allowProvisioningUpdates archive
```

Read the archived app's metadata. Verify its signature, bundle ID, team, display name, version, compiled Icon Composer icon, and privacy manifest.

## Upload and assign

1. Use the Codex browser's existing authenticated App Store Connect session when available.
2. Update the existing app's visible name to Kaizōsha’s InterfaceKit.
3. Upload the verified archive with TestFlight Internal Only distribution.
4. Wait for upload confirmation and processing.
5. Add the exact version and build to the existing Kon's Testing internal group.
6. Verify that the group reports the build as Testing.

The [TestFlight record](https://appstoreconnect.apple.com/apps/6827106597/testflight) uses the existing app ID. Record upload and group availability only after App Store Connect confirms them.

## Historical build 4 delivery receipt

Build 4 used the previous eight-item catalog and public API. Its example app
included the Native Glass Button presets, customization, and generated usage code. Its signed archive and distribution retain the original
app identity, iPhone/iPad device families, and iOS 26 minimum. Command-line export
and upload succeeded using the existing Xcode account and internal-only options.
App Store Connect processing completed and Kon's Testing reported **Testing**.
The visible App Store Connect name at delivery was KaizoshaInterfaceKit.

- Package release: `0.3.0`, source `033ed669c177809f92e7bf0de3c4034bed006ae6`.
- Archive: `/tmp/KaizoshaInterfaceKit42/KaizoshaInterfaceKit-1.0-4.xcarchive`.
- Distribution: `/tmp/KaizoshaInterfaceKit42/KitDistribution/KaizoshaInterfaceKit.ipa`.
- Upload log: `/tmp/KaizoshaInterfaceKit42/kit-upload.log`.
- Build ID: `8bdaf34f-22eb-43f8-b381-3de65d664e28`.
- Group: `1edd3d1b-a5e3-4cc1-8385-d3f1cd191428`.
- Testing proof: `/tmp/KaizoshaInterfaceKit42/kit-build4-testing.png`.

This is private TestFlight delivery, not public App Store submission or proof of
physical installation. Physical iPad validation remains deferred.

## Historical build 3 delivery receipt

Version 1.0 build 3, named KaizoshaUIKit, uploaded successfully on October 27, 2026, finished processing, and is assigned to the existing Kon's Testing internal group. App Store Connect reports **Testing** for build 3. The existing app identity and internal-only distribution are preserved.

- Build ID: `ca969bd4-7a71-43d7-9346-4816446d6972`.
- [Build 3 in App Store Connect](https://appstoreconnect.apple.com/teams/437df873-269a-455e-91ee-7dfc8af90cd1/apps/6827106597/testflight/ios/ca969bd4-7a71-43d7-9346-4816446d6972).
- Final archive: `/tmp/KaizoshaUIKit-1.0-3-final.xcarchive`.
- Verified executable SHA256: `0ef5559a227101f98373fa41cc57f32dcdd0c2e94bc09da2cfef9e6a60c0de6a`.
- Successful upload log: `/tmp/kaizosha-uikit-upload-ready.log`.
- Testing status screenshot: `/tmp/kaizosha-uikit-build3-testing.png`.

Physical installation and tactile feel are not established by the distribution status.
