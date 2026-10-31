import SwiftUI
import Testing
import UIKit
@testable import KaizoshaInterfaceKit

@Suite("Reusable selection controls")
@MainActor
struct ControlsTests {
    private enum Plan: Hashable { case monthly, annual, lifetime }
    private let plans: [SegmentedControlItem<Plan>] = [
        .init(id: .monthly, title: "Monthly"),
        .init(id: .annual, title: "Annual"),
        .init(id: .lifetime, title: "Lifetime")
    ]

    @Test("Payment defaults keep native untinted selection and equal-width segments")
    func paymentAppearance() throws {
        let picker = NativeSegmentedControl(selection: .constant(Plan.annual), items: plans, configuration: .init())
        let control = picker.makeControl(coordinator: picker.makeCoordinator())
        #expect(control.numberOfSegments == 3)
        #expect(!control.apportionsSegmentWidthsByContent)
        #expect(control.selectedSegmentTintColor == nil)
        #expect(control.selectedSegmentIndex == 1)
        #expect(control.intrinsicContentSize.height == 60)
        let font = try #require(control.titleTextAttributes(for: .normal)?[.font] as? UIFont)
        #expect(font.pointSize == 16)
        let paragraph = try #require(control.titleTextAttributes(for: .normal)?[.paragraphStyle] as? NSParagraphStyle)
        #expect(paragraph.lineBreakMode == .byTruncatingTail)
    }

    @Test("Native selection events update arbitrary typed IDs")
    func selectionUpdatesHost() {
        var selection = Plan.monthly
        let picker = NativeSegmentedControl(
            selection: .init(get: { selection }, set: { selection = $0 }),
            items: plans,
            configuration: .init()
        )
        let coordinator = picker.makeCoordinator()
        let control = picker.makeControl(coordinator: coordinator)
        control.selectedSegmentIndex = 2
        control.sendActions(for: .valueChanged)
        #expect(selection == .lifetime)
        #expect(control.accessibilityValue == "Lifetime")
        control.selectedSegmentIndex = 0
        control.sendActions(for: .valueChanged)
        #expect(selection == .monthly)
        #expect(control.accessibilityValue == "Monthly")
    }

    @Test("Reordering and relabeling items preserve selection by ID")
    func reorderedItems() {
        var selection = Plan.annual
        var picker = NativeSegmentedControl(
            selection: .init(get: { selection }, set: { selection = $0 }),
            items: plans,
            configuration: .init()
        )
        let coordinator = picker.makeCoordinator()
        let control = picker.makeControl(coordinator: coordinator)
        picker.items = [
            .init(id: .lifetime, title: "Forever"),
            .init(id: .monthly, title: "Every month"),
            .init(id: .annual, title: "Every year")
        ]
        coordinator.picker = picker
        picker.update(control)
        #expect(control.selectedSegmentIndex == 2)
        #expect(control.accessibilityValue == "Every year")
        control.selectedSegmentIndex = 0
        control.sendActions(for: .valueChanged)
        #expect(selection == .lifetime)
        #expect(control.accessibilityValue == "Forever")
    }

    @Test("Rejected host changes restore the visible native selection")
    func rejectedSelection() {
        let picker = NativeSegmentedControl(
            selection: Binding(get: { Plan.monthly }, set: { _ in }),
            items: plans,
            configuration: .init()
        )
        let coordinator = picker.makeCoordinator()
        let control = picker.makeControl(coordinator: coordinator)
        control.selectedSegmentIndex = 2
        control.sendActions(for: .valueChanged)
        #expect(control.selectedSegmentIndex == 0)
        #expect(control.accessibilityValue == "Monthly")
    }

    @Test("Disabled and invalid native events leave the host unchanged")
    func disabledSelection() {
        var selection = Plan.annual
        let picker = NativeSegmentedControl(
            selection: .init(get: { selection }, set: { selection = $0 }),
            items: plans,
            configuration: .init()
        )
        let coordinator = picker.makeCoordinator()
        let control = picker.makeControl(coordinator: coordinator)
        control.isEnabled = false
        control.selectedSegmentIndex = 2
        control.sendActions(for: .valueChanged)
        #expect(selection == .annual)
        #expect(control.selectedSegmentIndex == 1)
        control.isEnabled = true
        control.selectedSegmentIndex = UISegmentedControl.noSegment
        control.sendActions(for: .valueChanged)
        #expect(selection == .annual)
        #expect(control.selectedSegmentIndex == 1)
    }

    @Test("Equal display titles do not replace item identity")
    func identicalTitles() {
        var selection = 10
        let picker = NativeSegmentedControl(
            selection: .init(get: { selection }, set: { selection = $0 }),
            items: [SegmentedControlItem(id: 10, title: "Option"), .init(id: 20, title: "Option")],
            configuration: .init()
        )
        let coordinator = picker.makeCoordinator()
        let control = picker.makeControl(coordinator: coordinator)
        control.selectedSegmentIndex = 1
        control.sendActions(for: .valueChanged)
        #expect(selection == 20)
    }

    @Test("An absent host ID remains unselected without rewriting host state")
    func missingSelection() {
        let picker = NativeSegmentedControl(selection: .constant(Plan.lifetime), items: Array(plans.prefix(2)), configuration: .init())
        let control = picker.makeControl(coordinator: picker.makeCoordinator())
        #expect(control.selectedSegmentIndex == UISegmentedControl.noSegment)
        #expect(control.accessibilityValue == nil)
    }

    @Test("An empty item list has no selection or interactive surface")
    func emptyItems() {
        let picker = NativeSegmentedControl<Plan>(selection: .constant(.monthly), items: [], configuration: .init())
        let control = picker.makeControl(coordinator: picker.makeCoordinator())
        #expect(control.numberOfSegments == 0)
        #expect(control.selectedSegmentIndex == UISegmentedControl.noSegment)
        #expect(!control.isEnabled)
        #expect(control.intrinsicContentSize == .zero)
    }

    @Test("Selection colors reach the public native appearance attributes")
    func customizedAppearance() throws {
        let picker = NativeSegmentedControl(
            selection: .constant(Plan.monthly),
            items: plans,
            configuration: .init(selectionTint: .orange, foregroundColor: .blue, selectedForegroundColor: .white)
        )
        let control = picker.makeControl(coordinator: picker.makeCoordinator())
        #expect(control.selectedSegmentTintColor != nil)
        let foreground = try #require(control.titleTextAttributes(for: .normal)?[.foregroundColor] as? UIColor)
        let selected = try #require(control.titleTextAttributes(for: .selected)?[.foregroundColor] as? UIColor)
        #expect(!foreground.isEqual(selected))
    }
}
