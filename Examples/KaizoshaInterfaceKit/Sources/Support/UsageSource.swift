import SwiftUI

enum UsageSource {
    static func color(_ color: Color, in environment: EnvironmentValues) -> String {
        let value = color.resolve(in: environment)
        return "Color(.sRGB, red: \(value.red), green: \(value.green), blue: \(value.blue), opacity: \(value.opacity))"
    }
}
