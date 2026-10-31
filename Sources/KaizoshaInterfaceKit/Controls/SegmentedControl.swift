import SwiftUI
import UIKit

public struct SegmentedControlItem<ID: Hashable>: Identifiable {
    public var id: ID
    public var title: String

    public init(id: ID, title: String) {
        self.id = id
        self.title = title
    }
}

public struct SegmentedControlConfiguration {
    public var width: CGFloat?
    public var height: CGFloat
    public var fontSize: CGFloat
    public var selectionTint: Color?
    public var foregroundColor: Color
    public var selectedForegroundColor: Color

    public init(
        width: CGFloat? = nil,
        height: CGFloat = 60,
        fontSize: CGFloat = 16,
        selectionTint: Color? = nil,
        foregroundColor: Color = .primary,
        selectedForegroundColor: Color = .primary
    ) {
        self.width = width
        self.height = height
        self.fontSize = fontSize
        self.selectionTint = selectionTint
        self.foregroundColor = foregroundColor
        self.selectedForegroundColor = selectedForegroundColor
    }

    var resolvedWidth: CGFloat? {
        width.map { $0.isFinite ? min(max(0, $0), 10_000) : 300 }
    }

    var resolvedHeight: CGFloat {
        height.isFinite ? min(max(28, height), 512) : 60
    }

    var resolvedFontSize: CGFloat {
        fontSize.isFinite ? min(max(8, fontSize), 72) : 16
    }
}

/// Together's payment-sheet selector with caller-owned items and selection.
public struct SegmentedControl<ID: Hashable>: View {
    @Binding private var selection: ID
    private let items: [SegmentedControlItem<ID>]
    private let configuration: SegmentedControlConfiguration

    public init(
        selection: Binding<ID>,
        items: [SegmentedControlItem<ID>],
        configuration: SegmentedControlConfiguration = .init()
    ) {
        self._selection = selection
        self.items = items
        self.configuration = configuration
    }

    public var body: some View {
        NativeSegmentedControl(
            selection: $selection,
            items: items,
            configuration: configuration
        )
        .frame(width: configuration.resolvedWidth)
    }
}

struct NativeSegmentedControl<ID: Hashable>: UIViewRepresentable {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @Binding var selection: ID
    var items: [SegmentedControlItem<ID>]
    var configuration: SegmentedControlConfiguration

    func makeCoordinator() -> Coordinator { Coordinator(picker: self) }

    func makeUIView(context: Context) -> SegmentedControlView {
        makeControl(coordinator: context.coordinator)
    }

    func makeControl(coordinator: Coordinator) -> SegmentedControlView {
        let control = SegmentedControlView(items: [])
        control.apportionsSegmentWidthsByContent = false
        control.addTarget(coordinator, action: #selector(Coordinator.selectionChanged(_:)), for: .valueChanged)
        update(control)
        return control
    }

    func updateUIView(_ control: SegmentedControlView, context: Context) {
        context.coordinator.picker = self
        update(control)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: SegmentedControlView, context: Context) -> CGSize? {
        guard !items.isEmpty else { return .zero }
        let proposedWidth = proposal.width.flatMap { $0.isFinite ? min(max(0, $0), 10_000) : nil }
        return CGSize(
            width: configuration.resolvedWidth ?? proposedWidth ?? uiView.intrinsicContentSize.width,
            height: uiView.intrinsicContentSize.height
        )
    }

    func update(_ control: SegmentedControlView) {
        let requestedTitles = items.map(\.title)
        let displayedTitles = (0..<control.numberOfSegments).map { control.titleForSegment(at: $0) ?? "" }
        if displayedTitles != requestedTitles {
            control.removeAllSegments()
            for (index, item) in items.enumerated() {
                control.insertSegment(withTitle: item.title, at: index, animated: false)
            }
        }

        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light),
            UITraitCollection(preferredContentSizeCategory: dynamicTypeSize.contentSizeCategory)
        ])
        let font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: configuration.resolvedFontSize, weight: .semibold),
            compatibleWith: traits
        )
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        paragraph.alignment = .center
        let shared: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraph]
        let foreground = UIColor(configuration.foregroundColor).resolvedColor(with: traits)
        let selectedForeground = UIColor(configuration.selectedForegroundColor).resolvedColor(with: traits)
        control.setTitleTextAttributes(shared.merging([.foregroundColor: foreground]) { _, new in new }, for: .normal)
        control.setTitleTextAttributes(shared.merging([.foregroundColor: selectedForeground]) { _, new in new }, for: .selected)
        control.selectedSegmentTintColor = configuration.selectionTint.map { UIColor($0).resolvedColor(with: traits) }
        control.minimumHeight = max(configuration.resolvedHeight, ceil(font.lineHeight) + 16)
        control.isEnabled = isEnabled && !items.isEmpty
        synchronizeSelection(control)
    }

    func synchronizeSelection(_ control: UISegmentedControl) {
        let index = items.firstIndex { $0.id == selection }
        control.selectedSegmentIndex = index ?? UISegmentedControl.noSegment
        control.accessibilityValue = index.map { items[$0].title }
    }

    @MainActor
    final class Coordinator: NSObject {
        var picker: NativeSegmentedControl

        init(picker: NativeSegmentedControl) { self.picker = picker }

        @objc func selectionChanged(_ sender: UISegmentedControl) {
            guard sender.isEnabled, picker.items.indices.contains(sender.selectedSegmentIndex) else {
                picker.synchronizeSelection(sender)
                return
            }
            picker.selection = picker.items[sender.selectedSegmentIndex].id
            picker.synchronizeSelection(sender)
        }
    }
}

@MainActor
final class SegmentedControlView: UISegmentedControl {
    var minimumHeight: CGFloat = 60 {
        didSet {
            if minimumHeight != oldValue { invalidateIntrinsicContentSize() }
        }
    }

    override var intrinsicContentSize: CGSize {
        guard numberOfSegments > 0 else { return .zero }
        let native = super.intrinsicContentSize
        return CGSize(width: native.width, height: max(native.height, minimumHeight))
    }
}

private extension DynamicTypeSize {
    var contentSizeCategory: UIContentSizeCategory {
        switch self {
        case .xSmall: .extraSmall
        case .small: .small
        case .medium: .medium
        case .large: .large
        case .xLarge: .extraLarge
        case .xxLarge: .extraExtraLarge
        case .xxxLarge: .extraExtraExtraLarge
        case .accessibility1: .accessibilityMedium
        case .accessibility2: .accessibilityLarge
        case .accessibility3: .accessibilityExtraLarge
        case .accessibility4: .accessibilityExtraExtraLarge
        case .accessibility5: .accessibilityExtraExtraExtraLarge
        @unknown default: .large
        }
    }
}
