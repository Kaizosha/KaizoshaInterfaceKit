import XCTest

@MainActor
final class ComponentUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testEveryComponentHasCustomizationResetAndImportCode() {
        let ids = ["logo", "credits-sheet", "segmented-control", "option-pill", "liquid-list", "masonry-grid", "glass-button"]
        for id in ids {
            let destination = app.buttons["catalog.\(id)"]
            reveal(destination)
            destination.tap()
            XCTAssertTrue(app.buttons["component.customize"].waitForExistence(timeout: 4))
            XCTAssertFalse(app.buttons["component.code"].exists)
            XCTAssertFalse(app.buttons["component.reset"].exists)
            attach(id)
            app.buttons["component.customize"].tap()
            XCTAssertTrue(app.navigationBars["Customize"].waitForExistence(timeout: 4))
            attach("\(id)-customization")
            reveal(app.buttons["component.reset"])
            app.buttons["component.reset"].tap()
            reveal(app.buttons["component.code"])
            app.buttons["component.code"].tap()
            XCTAssertTrue(usageCode.waitForExistence(timeout: 4))
            app.buttons["Copy"].tap()
            XCTAssertTrue(app.buttons["Copied"].exists)
            app.navigationBars["Use in your app"].buttons["Customize"].tap()
            app.buttons["customize.done"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            XCTAssertTrue(app.navigationBars["Kaizōsha’s InterfaceKit"].waitForExistence(timeout: 4))
        }
    }

    func testCreditsPreserveTogetherAndAcceptCustomTitle() {
        app.buttons["catalog.credits-sheet"].tap()
        app.buttons["credits.open"].tap()
        XCTAssertTrue(app.staticTexts["Made by Kaizōsha."].waitForExistence(timeout: 4))
        XCTAssertTrue(app.descendants(matching: .any)["credits.purpose"].firstMatch.exists)
        attach("credits-sheet")
        app.buttons["credits.close"].tap()
        app.buttons["component.customize"].tap()
        let title = app.textFields["Title"]
        XCTAssertTrue(title.waitForExistence(timeout: 4))
        replaceText(in: title, with: "Made for Kaizōsha.")
        app.buttons["customize.done"].tap()
        app.buttons["credits.open"].tap()
        XCTAssertTrue(app.staticTexts["Made for Kaizōsha."].waitForExistence(timeout: 4))
        app.buttons["credits.close"].tap()
    }

    func testPaymentAndLanguageUseTheSameNativeSelectorWithDifferentWidths() {
        app.buttons["catalog.segmented-control"].tap()
        let selector = app.segmentedControls.firstMatch
        XCTAssertTrue(selector.waitForExistence(timeout: 4))
        let paymentWidth = selector.frame.width
        XCTAssertEqual(paymentWidth, 320, accuracy: 2)
        XCTAssertEqual(selector.buttons.count, 2)
        selector.buttons["Monthly"].tap()
        XCTAssertTrue(selector.buttons["Monthly"].isSelected)
        selector.buttons["Annual"].tap()
        XCTAssertTrue(selector.buttons["Annual"].isSelected)
        app.buttons["component.customize"].tap()
        selectSegmentedPreset("Language")
        app.buttons["customize.done"].tap()
        XCTAssertEqual(selector.frame.width, 210, accuracy: 2)
        XCTAssertLessThan(selector.frame.width, paymentWidth)
        selector.buttons["Translate"].tap()
        XCTAssertTrue(selector.buttons["Translate"].isSelected)
        attach("segmented-language-preset")

        app.buttons["component.customize"].tap()
        selectSegmentedPreset("Options")
        app.buttons["customize.done"].tap()
        XCTAssertEqual(selector.buttons.count, 3)
        selector.buttons["Third"].tap()
        XCTAssertTrue(selector.buttons["Third"].isSelected)
        attach("segmented-three-options")
    }

    func testOptionPillSupportsAdditionalChoicesAndSingleLineCustomTitles() {
        app.buttons["catalog.option-pill"].tap()
        let low = app.buttons["Low"]
        XCTAssertTrue(low.waitForExistence(timeout: 4))
        let singleLineHeight = low.frame.height
        app.buttons["High"].tap()
        XCTAssertTrue(app.buttons["High"].isSelected)
        app.buttons["component.customize"].tap()
        let enabled = app.switches["Enabled"]
        XCTAssertTrue(enabled.waitForExistence(timeout: 4))
        enabled.switches.firstMatch.tap()
        app.buttons["customize.done"].tap()
        XCTAssertFalse(app.buttons["High"].isEnabled)
        low.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(app.buttons["High"].isSelected)
        attach("option-pill-disabled")
        app.buttons["component.customize"].tap()
        enabled.switches.firstMatch.tap()
        let count = app.steppers["pill.count"]
        XCTAssertTrue(count.waitForExistence(timeout: 4))
        count.buttons["pill.count-Increment"].tap()
        let title = app.textFields["pill.title.2"]
        reveal(title)
        let customTitle = "An intentionally long third option title"
        replaceText(in: title, with: customTitle)
        app.buttons["customize.done"].tap()
        let customOption = app.buttons[customTitle]
        XCTAssertTrue(customOption.waitForExistence(timeout: 4))
        XCTAssertEqual(customOption.frame.height, singleLineHeight, accuracy: 2)
        XCTAssertLessThan(customOption.frame.width, 140)
        customOption.tap()
        XCTAssertTrue(customOption.isSelected)
        XCTAssertFalse(app.buttons["High"].isSelected)
        attach("option-pill-custom-third-choice")
        app.buttons["component.customize"].tap()
        reveal(app.buttons["component.code"])
        app.buttons["component.code"].tap()
        XCTAssertTrue(usageCode.waitForExistence(timeout: 4))
        XCTAssertTrue(usageCode.label.contains(customTitle))
        XCTAssertTrue(usageCode.label.contains("OptionPillItem(id: 2"))
    }

    func testLiquidRowsKeepSelectionAndContainedToggleBehavior() {
        app.buttons["catalog.liquid-list"].tap()
        let appearance = app.buttons["liquid.row.Appearance"]
        let captions = app.buttons["liquid.row.Captions"]
        XCTAssertTrue(appearance.waitForExistence(timeout: 4))
        XCTAssertTrue(appearance.isSelected)
        captions.tap()
        XCTAssertTrue(captions.isSelected)
        XCTAssertFalse(appearance.isSelected)
        let tactile = app.switches["Tactile feedback"]
        XCTAssertEqual(tactile.value as? String, "1")
        tactile.switches.firstMatch.tap()
        XCTAssertEqual(tactile.value as? String, "0")
        XCTAssertTrue(captions.isSelected)
        attach("liquid-list-selection-and-toggle")
        app.buttons["component.customize"].tap()
        let enabled = app.switches["Enabled"]
        XCTAssertTrue(enabled.waitForExistence(timeout: 4))
        enabled.switches.firstMatch.tap()
        app.buttons["customize.done"].tap()
        XCTAssertFalse(captions.isEnabled)
        XCTAssertFalse(tactile.isEnabled)
        XCTAssertTrue(captions.isSelected)
    }

    func testMasonryPlacesUnequalTilesInSeparateColumns() {
        app.buttons["catalog.masonry-grid"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["masonry.tile.0"].firstMatch.waitForExistence(timeout: 4))
        let first = app.descendants(matching: .any)["masonry.tile.0"].firstMatch.frame
        let second = app.descendants(matching: .any)["masonry.tile.1"].firstMatch.frame
        XCTAssertGreaterThan(second.minX, first.minX)
        XCTAssertNotEqual(first.height, second.height)
        attach("masonry-grid")
    }

    private var usageCode: XCUIElement {
        app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "import KaizoshaInterfaceKit")).firstMatch
    }

    private func selectSegmentedPreset(_ title: String) {
        let picker = app.buttons["segmented.preset"]
        XCTAssertTrue(picker.waitForExistence(timeout: 4))
        picker.tap()
        let option = app.buttons[title].firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 4))
        option.tap()
    }

    private func replaceText(in field: XCUIElement, with text: String) {
        field.tap()
        let current = field.value as? String ?? ""
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count) + text)
    }

    private func reveal(_ element: XCUIElement) {
        for _ in 0..<12 {
            if element.exists && element.isHittable { return }
            app.collectionViews.firstMatch.swipeUp()
        }
        XCTAssertTrue(element.exists && element.isHittable)
    }

    private func attach(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
