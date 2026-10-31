import SwiftUI

/// The glass, selection wash, and geometry shared by liquid-list row variants.
public struct LiquidListRowConfiguration {
    public enum Shape: String, CaseIterable, Sendable {
        case adaptive
        case capsule
        case roundedRectangle
    }

    public var glassTint: Color?
    public var selectionTint: Color
    public var selectionOpacity: Double
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    public var minimumHeight: CGFloat
    public var shape: Shape
    public var cornerRadius: CGFloat

    public init(
        glassTint: Color? = nil,
        selectionTint: Color = .accentColor,
        selectionOpacity: Double = 0.10,
        horizontalPadding: CGFloat = 18,
        verticalPadding: CGFloat = 10,
        minimumHeight: CGFloat = 54,
        shape: Shape = .adaptive,
        cornerRadius: CGFloat = 24
    ) {
        self.glassTint = glassTint
        self.selectionTint = selectionTint
        self.selectionOpacity = selectionOpacity
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.minimumHeight = minimumHeight
        self.shape = shape
        self.cornerRadius = cornerRadius
    }
}

/// Presents row content while its caller owns buttons, navigation, and contained controls.
/// Pass `isInteractive: false` when the content contains its own control, such as a toggle.
public struct LiquidListRow<Content: View>: View {
    public var isSelected: Bool
    public var isInteractive: Bool
    public var configuration: LiquidListRowConfiguration
    private let content: Content

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    public init(
        isSelected: Bool = false,
        isInteractive: Bool = true,
        configuration: LiquidListRowConfiguration = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.isSelected = isSelected
        self.isInteractive = isInteractive
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        content
            .padding(.horizontal, LiquidListMetrics.dimension(configuration.horizontalPadding, fallback: 18))
            .padding(.vertical, LiquidListMetrics.dimension(configuration.verticalPadding, fallback: 10))
            .frame(
                maxWidth: .infinity,
                minHeight: LiquidListMetrics.dimension(configuration.minimumHeight, fallback: 54),
                alignment: .leading
            )
            .contentShape(resolvedShape)
            .background(
                isSelected && isEnabled
                    ? configuration.selectionTint.opacity(selectionOpacity) : .clear,
                in: resolvedShape
            )
            .glassEffect(glass, in: resolvedShape)
            .saturation(isEnabled ? 1 : 0)
            .opacity(isEnabled ? 1 : 0.5)
    }

    private var glass: Glass {
        let glass = configuration.glassTint.map { Glass.regular.tint($0) } ?? .regular
        return glass.interactive(isEnabled && isInteractive)
    }

    private var selectionOpacity: Double {
        let opacity = configuration.selectionOpacity
        return opacity.isFinite ? min(1, max(0, opacity)) : 0.10
    }

    private var resolvedShape: AnyShape {
        switch configuration.shape {
        case .capsule:
            AnyShape(Capsule())
        case .roundedRectangle:
            roundedRectangle
        case .adaptive:
            dynamicTypeSize.isAccessibilitySize ? roundedRectangle : AnyShape(Capsule())
        }
    }

    private var roundedRectangle: AnyShape {
        AnyShape(RoundedRectangle(
            cornerRadius: LiquidListMetrics.dimension(configuration.cornerRadius, fallback: 24),
            style: .continuous
        ))
    }
}
