import KaizoshaInterfaceKit
import SwiftUI
import Testing
import UIKit

@Suite("Liquid list layout")
@MainActor
struct LiquidListTests {
    @Test("A compact row fills its proposed width and keeps Together's minimum target")
    func compactRowGeometry() {
        let row = LiquidListRow {
            Color.clear.frame(width: 20, height: 20)
        }
        let size = measure(row)

        #expect(abs(size.width - 300) < 0.5)
        #expect(abs(size.height - 54) < 0.5)
    }

    @Test("Row geometry follows customized padding and minimum height")
    func customizedRowGeometry() {
        let row = LiquidListRow(configuration: .init(
            horizontalPadding: 24,
            verticalPadding: 16,
            minimumHeight: 80,
            shape: .roundedRectangle,
            cornerRadius: 20
        )) {
            Color.clear.frame(width: 20, height: 60)
        }
        let size = measure(row)

        #expect(abs(size.width - 300) < 0.5)
        #expect(abs(size.height - 92) < 0.5)
    }

    @Test("Accessibility text grows the row instead of clipping to its minimum")
    func accessibilityRowExpands() {
        let text = "Choose a language for every video in your library."
        let normal = measure(LiquidListRow {
            Text(text).font(.body)
        }.dynamicTypeSize(.large))
        let accessible = measure(LiquidListRow {
            Text(text).font(.body)
        }.dynamicTypeSize(.accessibility5))

        #expect(accessible.height > normal.height)
        #expect(abs(accessible.width - normal.width) < 0.5)
    }

    @Test("Nonfinite configuration dimensions fall back to usable row geometry")
    func nonfiniteRowGeometry() {
        let row = LiquidListRow(configuration: .init(
            horizontalPadding: .nan,
            verticalPadding: .infinity,
            minimumHeight: .nan,
            shape: .roundedRectangle,
            cornerRadius: .infinity
        )) {
            Color.clear.frame(width: 20, height: 20)
        }
        let size = measure(row)

        #expect(size.width.isFinite && size.height.isFinite)
        #expect(abs(size.width - 300) < 0.5)
        #expect(abs(size.height - 54) < 0.5)
    }

    private func measure<Content: View>(_ content: Content) -> CGSize {
        let host = UIHostingController(rootView: content)
        return host.sizeThatFits(in: CGSize(width: 300, height: 1_000))
    }
}
