import SwiftUI

/// The spacing and outer insets of a scrolling liquid list.
public struct LiquidListConfiguration {
    public var rowSpacing: CGFloat
    public var horizontalInset: CGFloat
    public var verticalInset: CGFloat

    public init(
        rowSpacing: CGFloat = 10,
        horizontalInset: CGFloat = 16,
        verticalInset: CGFloat = 16
    ) {
        self.rowSpacing = rowSpacing
        self.horizontalInset = horizontalInset
        self.verticalInset = verticalInset
    }
}

/// Scrolls independently actionable glass rows without imposing their actions or selection.
public struct LiquidList<Content: View>: View {
    public var configuration: LiquidListConfiguration
    private let content: Content

    public init(
        configuration: LiquidListConfiguration = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: LiquidListMetrics.dimension(configuration.rowSpacing, fallback: 10)
            ) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, LiquidListMetrics.dimension(configuration.horizontalInset, fallback: 16))
            .padding(.vertical, LiquidListMetrics.dimension(configuration.verticalInset, fallback: 16))
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollEdgeEffectStyle(.soft, for: .top)
        .scrollEdgeEffectStyle(.soft, for: .bottom)
    }
}

enum LiquidListMetrics {
    static func dimension(_ value: CGFloat, fallback: CGFloat) -> CGFloat {
        value.isFinite ? min(10_000, max(0, value)) : fallback
    }
}
