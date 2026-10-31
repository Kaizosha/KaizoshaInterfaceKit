import KaizoshaInterfaceKit
import SwiftUI

struct CreditsSheetExample: View {
    @State private var configuration = CreditsSheetConfiguration.together
    @State private var showsCredits = false

    var body: some View {
        ComponentPage(title: "Credits Sheet", code: code, reset: { configuration = .together }) {
            Button("Made by Kaizōsha") { showsCredits = true }
                .buttonStyle(.glass)
                .accessibilityIdentifier("credits.open")
                .sheet(isPresented: $showsCredits) {
                    CreditsSheet(configuration: configuration)
                }
                .sensoryFeedback(.impact(weight: .light), trigger: showsCredits)
        } controls: {
            Section("Credits") {
                TextField("Title", text: $configuration.title)
                Toggle("Show logo", isOn: $configuration.showsLogo)
                ValueControl(title: "Logo size", value: $configuration.logoSize, range: 80...240, suffix: " pt")
            }
            Section("Paragraphs") {
                ForEach(configuration.paragraphs.indices, id: \.self) { index in
                    TextField("Paragraph \(index + 1)", text: $configuration.paragraphs[index], axis: .vertical)
                }
            }
        }
    }

    private var code: String {
        let paragraphs = configuration.paragraphs
            .map { "                        " + String(reflecting: $0) }
            .joined(separator: ",\n")
        return """
        import KaizoshaInterfaceKit
        import SwiftUI

        struct CreditsSheetPreview: View {
            @State private var showsCredits = false

            var body: some View {
                Button("Made by Kaizōsha") { showsCredits = true }
                    .buttonStyle(.glass)
                    .sheet(isPresented: $showsCredits) {
                        CreditsSheet(configuration: CreditsSheetConfiguration(
                            title: \(String(reflecting: configuration.title)),
                            paragraphs: [
        \(paragraphs)
                            ],
                            showsLogo: \(configuration.showsLogo),
                            logoSize: \(Double(configuration.logoSize))
                        ))
                    }
                    .sensoryFeedback(.impact(weight: .light), trigger: showsCredits)
            }
        }
        """
    }
}
