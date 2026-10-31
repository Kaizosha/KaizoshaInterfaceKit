import KaizoshaInterfaceKit
import SwiftUI

struct KaizoshaLogoExample: View {
    @State private var configuration = KaizoshaLogoConfiguration()

    var body: some View {
        ComponentPage(title: "Kaizōsha Logo", code: code, reset: { configuration = .init() }) {
            KaizoshaLogo(configuration: configuration)
                .accessibilityIdentifier("logo.element")
        } controls: {
            Section("Logo") {
                ValueControl(title: "Size", value: $configuration.size, range: 80...280, suffix: " pt")
                ValueControl(title: "Refraction", value: $configuration.refraction, range: 0...2)
                Toggle("Interactive", isOn: $configuration.interactive)
                Toggle("Haptics", isOn: $configuration.hapticsEnabled)
                Toggle("Follow device tilt", isOn: $configuration.motionEnabled)
            }
            Section("Light direction") {
                ValueControl(title: "Horizontal", value: $configuration.lightDirection.dx, range: -1...1)
                ValueControl(title: "Vertical", value: $configuration.lightDirection.dy, range: -1...1)
            }
            .disabled(configuration.motionEnabled)
        }
    }

    private var code: String {
        """
        import KaizoshaInterfaceKit
        import SwiftUI

        struct KaizoshaLogoPreview: View {
            var body: some View {
                KaizoshaLogo(configuration: KaizoshaLogoConfiguration(
                    size: \(Double(configuration.size)),
                    interactive: \(configuration.interactive),
                    hapticsEnabled: \(configuration.hapticsEnabled),
                    motionEnabled: \(configuration.motionEnabled),
                    refraction: \(Double(configuration.refraction)),
                    lightDirection: CGVector(
                        dx: \(Double(configuration.lightDirection.dx)),
                        dy: \(Double(configuration.lightDirection.dy))
                    )
                ))
            }
        }
        """
    }
}
