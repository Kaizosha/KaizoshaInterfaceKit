import SwiftUI

public struct OptionPillItem<ID: Hashable>: Identifiable {
    public var id: ID
    public var title: String
    public var tint: Color
    public var foregroundColor: Color
    public var selectedForegroundColor: Color

    public init(
        id: ID,
        title: String,
        tint: Color = .primary,
        foregroundColor: Color = .primary,
        selectedForegroundColor: Color = Color(uiColor: .systemBackground)
    ) {
        self.id = id
        self.title = title
        self.tint = tint
        self.foregroundColor = foregroundColor
        self.selectedForegroundColor = selectedForegroundColor
    }
}

public struct OptionPillConfiguration {
    public var glassTint: Color?
    public var width: CGFloat?
    public var height: CGFloat
    public var spacing: CGFloat

    public init(
        glassTint: Color? = nil,
        width: CGFloat? = nil,
        height: CGFloat = 46,
        spacing: CGFloat = 4
    ) {
        self.glassTint = glassTint
        self.width = width
        self.height = height
        self.spacing = spacing
    }

    var resolvedWidth: CGFloat? {
        width.map { $0.isFinite ? min(max(0, $0), 10_000) : 300 }
    }

    var resolvedHeight: CGFloat {
        height.isFinite ? min(max(44, height), 512) : 46
    }

    var resolvedSpacing: CGFloat {
        spacing.isFinite ? min(max(0, spacing), 32) : 4
    }
}

/// A glass option selector with independently colored, single-line choices.
public struct OptionPill<ID: Hashable>: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var selectionNamespace
    @Binding private var selection: ID
    private let items: [OptionPillItem<ID>]
    private let configuration: OptionPillConfiguration

    public init(
        selection: Binding<ID>,
        items: [OptionPillItem<ID>],
        configuration: OptionPillConfiguration = .init()
    ) {
        self._selection = selection
        self.items = items
        self.configuration = configuration
    }

    public var body: some View {
        if !items.isEmpty {
            GlassEffectContainer(spacing: configuration.resolvedSpacing) {
                HStack(spacing: configuration.resolvedSpacing) {
                    ForEach(items) { item in
                        option(item)
                    }
                }
                .padding(4)
                .frame(minHeight: configuration.resolvedHeight)
                .glassEffect(surfaceGlass, in: Capsule())
            }
            .frame(width: configuration.resolvedWidth)
            .animation(reduceMotion ? nil : .snappy(duration: 0.2), value: selection)
        }
    }

    private var surfaceGlass: Glass {
        var glass = Glass.regular
        if let tint = configuration.glassTint { glass = glass.tint(tint) }
        return glass.interactive(isEnabled)
    }

    private func option(_ item: OptionPillItem<ID>) -> some View {
        let selected = selection == item.id
        return Button {
            selection = item.id
        } label: {
            Text(verbatim: item.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(selected ? item.selectedForegroundColor : item.foregroundColor)
                .padding(.horizontal, 8)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: max(0, configuration.resolvedHeight - 8))
                .background {
                    if selected {
                        Capsule()
                            .fill(.clear)
                            .glassEffect(.regular.tint(item.tint).interactive(isEnabled), in: Capsule())
                            .glassEffectID("selection", in: selectionNamespace)
                    }
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(verbatim: item.title))
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}
